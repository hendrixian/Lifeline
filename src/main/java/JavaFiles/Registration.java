package JavaFiles;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.InputStream;
import java.io.Serial;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@MultipartConfig
@WebServlet(name = "Registration", urlPatterns = {"/Registration"})
public class Registration extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        try (Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/edms", "root", "")) {
            if (username != null && !username.isEmpty()) {
                boolean exists = checkUsernameExists(con, username);
                response.setContentType("text/plain");
                response.getWriter().write(exists ? "taken" : "available");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid username");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/edms", "root", "")) {
            String username = request.getParameter("username");
            System.out.println(username);
            String email = request.getParameter("Email");
            String password1 = request.getParameter("password1");
            String password2 = request.getParameter("password2");
            String userType = request.getParameter("UserType");

            String division = request.getParameter("Division");
            String city = request.getParameter("City");
            String township = request.getParameter("Township");
            String contactNo = request.getParameter("ContactNo");

            Part part = request.getPart("Image");
            String description = request.getParameter("Description");

            // Validate passwords
            if (!password1.equals(password2)) {
                request.setAttribute("message", "Passwords do not match.");
                request.getRequestDispatcher("Registration.jsp").forward(request, response);
                return;
            }

            // Check if username already exists
            if (checkUsernameExists(con, username)) {
                request.setAttribute("message", "Username already exists. Please choose another.");
                request.getRequestDispatcher("Registration.jsp").forward(request, response);
                return;
            }

            // Retrieve zipcode
            String zipcode = getZipcode(con, division, city, township);
            if (zipcode == null) {
                request.setAttribute("message", "Invalid Division, City, or Township. Please check your input.");
                request.getRequestDispatcher("Registration.jsp").forward(request, response);
                return;
            }

            // Insert user into the database
            if (registerUser(con, username, email, password1, userType, contactNo, zipcode, part, description)) {
                response.sendRedirect("Login.jsp");
            } else {
                request.setAttribute("message", "Registration failed. Try again.");
                request.getRequestDispatcher("Registration.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred. Please try again.");
            request.getRequestDispatcher("Registration.jsp").forward(request, response);
        }
    }

    private boolean checkUsernameExists(Connection con, String username) throws SQLException {
        String userQuery = "SELECT COUNT(*) FROM user WHERE Username = ?";
        String repQuery = "SELECT COUNT(*) FROM representative WHERE Representativename = ?";

        try (PreparedStatement stmt1 = con.prepareStatement(userQuery);
             PreparedStatement stmt2 = con.prepareStatement(repQuery)) {

            stmt1.setString(1, username);
            ResultSet rs1 = stmt1.executeQuery();
            if (rs1.next() && rs1.getInt(1) > 0) {
                return true;
            }

            stmt2.setString(1, username);
            ResultSet rs2 = stmt2.executeQuery();
            return rs2.next() && rs2.getInt(1) > 0;
        }
    }

    private String getZipcode(Connection con, String division, String city, String township) throws SQLException {
        String zipcodeQuery = "SELECT Zipcode FROM myanmar WHERE Divisions = ? AND Cities = ? AND Townships = ?";
        try (PreparedStatement stmt = con.prepareStatement(zipcodeQuery)) {
            stmt.setString(1, division);
            stmt.setString(2, city);
            stmt.setString(3, township);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("Zipcode");
            }
        }
        return null;
    }

    private boolean registerUser(Connection con, String username, String email, String password, String userType, String contactNo, String zipcode, Part part, String description) throws SQLException, IOException {
        String insertQuery = "INSERT INTO user (Username, Email, Password, UserType, ContactNo, Zipcode, Image, Description) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(insertQuery)) {
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            InputStream is = null;
            if (part != null && part.getSize() > 0) {
                is = part.getInputStream();
            }

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, userType);
            ps.setString(5, contactNo);
            ps.setString(6, zipcode);
            if (is != null) {
                ps.setBlob(7, is);
            } else {
                ps.setNull(7, java.sql.Types.BLOB);
            }
            ps.setString(8, description);

            return ps.executeUpdate() > 0;
        }
    }
}
