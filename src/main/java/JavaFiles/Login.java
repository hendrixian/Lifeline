package JavaFiles;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.Serial;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
                // session.setAttribute("loggedInUser", username);
                // Save the appropriate username (either user or representative) in the session
                if (isUserInTable(con, username)) {
                    session.setAttribute("loggedInUser", username);  // For user
                } else if (isRepresentativeInTable(con, username)) {
                    session.setAttribute("loggedInRepresentative", username);  // For representative
                }
// Debugging: Log the session attribute to check if it's saved correctly
                LOGGER.info("Session loggedInRepresentative: " + session.getAttribute("loggedInRepresentative"));
                LOGGER.info("Session loggedInUser: " + session.getAttribute("loggedInUser"));
                String redirectURL = (String) session.getAttribute("redirectURL");
                response.sendRedirect(redirectURL != null ? redirectURL : "Home.jsp");
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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("Login.jsp");
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
}
