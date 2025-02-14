package JavaFiles;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.Serial;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig
@WebServlet(name = "Login", urlPatterns = {"/Login"})
public class Login extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mariadb://localhost:3306/edms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    private static final Logger LOGGER = Logger.getLogger(Login.class.getName());

    // Establish database connection
    private Connection getConnection() throws Exception {
        Class.forName("org.mariadb.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("log_username");
        String password = request.getParameter("log_password");
        System.out.println(username);
        int userId;
        boolean rememberMe = request.getParameter("remember_me") != null;
        System.out.println(rememberMe);

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("message", "Username and password are required.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        try (Connection con = getConnection()) {
            LOGGER.info("Database connection successful.");

            if (authenticateUser(con, username, password)) {
                verifyUser(con, username);

                HttpSession session = request.getSession();
                if (isUserInTable(con, username)) {
                    session.setAttribute("loggedInUser", username);  // For user
                } else if (isRepresentativeInTable(con, username)) {
                    session.setAttribute("loggedInRepresentative", username);  // For representative
                }

                LOGGER.info("Session loggedInRepresentative: " + session.getAttribute("loggedInRepresentative"));
                LOGGER.info("Session loggedInUser: " + session.getAttribute("loggedInUser"));

                String query = "SELECT ID FROM user WHERE username = ? AND password = ?";
                try (PreparedStatement ps = con.prepareStatement(query)) {
                    ps.setString(1, username);
                    ps.setString(2, password);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            userId = rs.getInt("ID"); // Get user ID
                            session = request.getSession();
                            session.setAttribute("user_id", userId); // Store in session
                            System.out.println("user_id: " + userId);

                            // Add the "Remember Me" functionality here
                            System.out.println("This is remember me boolean: "+rememberMe);
                            if (rememberMe) {
                                String token = RememberMeUtil.generateToken();
                                Timestamp expiryDate = new Timestamp(System.currentTimeMillis() + TimeUnit.DAYS.toMillis(30)); // 30 days
                                RememberMeUtil.storeRememberMeToken(con, userId, token, expiryDate);
                                RememberMeUtil.setRememberMeCookie(response, token, (int) TimeUnit.DAYS.toSeconds(30));
                                LOGGER.info("Remember Me token created and stored for user ID: " + userId);
                            }

                            response.sendRedirect("Home.jsp");
                            return;
                        }
                    }
                }
            } else {
                request.setAttribute("message", "Invalid username or password.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "An error occurred during login.", e);
            request.setAttribute("message", "An error occurred. Please try again later.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check for "Remember Me" cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember_me".equals(cookie.getName())) {
                    String token = cookie.getValue();
                    try (Connection con = getConnection()) {
                        int userId = RememberMeUtil.validateRememberMeToken(con,token);
                        if (userId != -1) {
                            String username = getUsernameById(con, userId);
                            HttpSession session = request.getSession();
                            if (isUserInTable(con, username)) {
                                session.setAttribute("loggedInUser", username);
                            } else if (isRepresentativeInTable(con, username)) {
                                session.setAttribute("loggedInRepresentative", username);
                            }
                            response.sendRedirect("Home.jsp");
                            return;
                        }
                    } catch (Exception e) {
                        LOGGER.log(Level.SEVERE, "Error during auto-login.", e);
                    }
                }
            }
        }
    }

    // Helper method to check if the username exists in the 'user' table
    private boolean isUserInTable(Connection con, String username) throws Exception {
        String userQuery = "SELECT Username FROM user WHERE Username = ?";
        try (PreparedStatement ps = con.prepareStatement(userQuery)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Helper method to check if the username exists in the 'representative' table
    private boolean isRepresentativeInTable(Connection con, String username) throws Exception {
        String repQuery = "SELECT Representativename FROM representative WHERE Representativename = ?";
        try (PreparedStatement ps = con.prepareStatement(repQuery)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private boolean authenticateUser(Connection con, String username, String password) throws Exception {
        // Check in 'user' table first
        String userQuery = "SELECT Username, Password FROM user WHERE Username = ?";
        try (PreparedStatement ps = con.prepareStatement(userQuery)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbUsername = rs.getString("Username");
                    String dbPassword = rs.getString("Password");

                    LOGGER.info("Checking 'user' table for username: " + username);

                    if (BCrypt.checkpw(password, dbPassword)) {
                        LOGGER.info("Password match successful for user: " + username);
                        return true;
                    } else {
                        LOGGER.warning("Password mismatch for user: " + username);
                        return false;
                    }
                }
            }
        }

        // Check in 'representative' table if not found in 'user'
        String repQuery = "SELECT Representativename,Password FROM representative WHERE Representativename = ?";
        try (PreparedStatement ps = con.prepareStatement(repQuery)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbRepName = rs.getString("Representativename");
                    String dbPassword = rs.getString("Password");

                    LOGGER.info("Checking 'representative' table for Representativename: " + username);

                    if (BCrypt.checkpw(password, dbPassword)) {
                        LOGGER.info("Password match successful for representative: " + username);
                        return true;
                    } else {
                        LOGGER.warning("Password mismatch for representative: " + username);
                        return false;
                    }
                }
            }
        }

        LOGGER.warning("User not found in either 'user' or 'representative' table: " + username);
        return false;
    }

    private void verifyUser(Connection con, String username) throws Exception {
        String checkVerifiedQuery = "SELECT Username FROM verified WHERE Username = ?";
        try (PreparedStatement ps = con.prepareStatement(checkVerifiedQuery)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LOGGER.info("User already verified: " + username);
                    return;
                }
            }
        }

        int contributionCount = calculateContributionCount(con, username);

        if (contributionCount >= 20) {
            String verifyQuery = "INSERT INTO verified (Username) VALUES (?)";
            try (PreparedStatement ps = con.prepareStatement(verifyQuery)) {
                ps.setString(1, username);
                ps.executeUpdate();
                LOGGER.info("User verified: " + username);
            }
        } else {
            LOGGER.info("User not eligible for verification: " + username);
        }
    }

    //make it as comment because it is using the table that doesnt exist but might need for smth-TTW
    private int calculateContributionCount(Connection con, String username) throws Exception {
        int count = 0;
        String locationQuery = "SELECT LocationUsername FROM " + username + "_location";

        try (PreparedStatement stmt = con.prepareStatement(locationQuery);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String locUsername = rs.getString("LocationUsername");
                String askHelpQuery = "SELECT COUNT(*) AS helpCount FROM " + locUsername + "_askhelp";
                try (PreparedStatement helpStmt = con.prepareStatement(askHelpQuery);
                     ResultSet helpRs = helpStmt.executeQuery()) {
                    if (helpRs.next()) {
                        count += helpRs.getInt("helpCount");
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error calculating contributions for user: " + username, e);
        }

        LOGGER.info("Total contributions for " + username + ": " + count);
        return count;
    }

    private int getUserId(Connection con, String username) throws Exception {
        String query = "SELECT id FROM user WHERE Username = ? UNION SELECT id FROM representative WHERE Representativename = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return -1; // User not found
    }

    private String getUsernameById(Connection con, int userId) throws Exception {
        String query = "SELECT Username FROM user WHERE id = ? UNION SELECT Representativename FROM representative WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Username");
                }
            }
        }
        return null; // User not found
    }
}