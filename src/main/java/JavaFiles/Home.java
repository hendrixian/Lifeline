package JavaFiles;

import java.lang.System;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.io.IOException;
import java.io.Serial;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import static JavaFiles.Forgot.LOGGER;

@WebServlet("/Home")
public class Home extends HttpServlet {

    @Serial
    private static final long serialVersionUID = 1L;

    // Database credentials
    private static final String DB_URL = "jdbc:mariadb://localhost:3306/edms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        LOGGER.info("The retrieved username is : "+username);
        // Redirect to login page if the session has expired or the user is not logged in
        if (username == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Attempt to find the username in the 'user' or 'representative' table
        String userType = getUserTypeFromDatabase(username);

        if (userType == null) {
            // If the username doesn't exist in either table, redirect to an error page
            response.sendRedirect("error.jsp");
        } else {
            // Set attributes for forwarding to the appropriate profile page
            request.setAttribute("username", username);
            request.setAttribute("userType", userType);

            // Forward to the corresponding profile page based on user type
            if (userType.equals("user")) {
                request.getRequestDispatcher("Profile_user.jsp").forward(request, response);
            } else if (userType.equals("representative")) {
                request.getRequestDispatcher("Profile_rep.jsp").forward(request, response);
            }
        }
    }

    /**
     * This method checks the database to determine the type of user based on the username.
     *
     * @param username The username to check.
     * @return A string indicating the user type ("user" or "representative"), or null if not found.
     */
    private String getUserTypeFromDatabase(String username) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

            // Check if the username exists in the 'user' table
            if (isUserInTable(conn, "user", username)) {
                return "user";
            }

            // Check if the username exists in the 'representative' table
            if (isUserInTable(conn, "representative", username)) {
                return "representative";
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null; // Username not found in either table
    }

    /**
     * This method checks if the username exists in a given table.
     *
     * @param conn The database connection.
     * @param tableName The table name (either "user" or "representative").
     * @param username The username to check.
     * @return true if the username exists in the table, false otherwise.
     */
    private boolean isUserInTable(Connection conn, String tableName, String username) throws SQLException {
        String query = "SELECT * FROM " + tableName + " WHERE username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // Returns true if a record is found
            }
        }
    }
}
