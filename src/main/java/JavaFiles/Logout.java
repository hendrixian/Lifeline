package JavaFiles;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.logging.Logger;

public class Logout extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(Login.class.getName());

    private Connection getConnection() throws Exception {
        Class.forName("org.mariadb.jdbc.Driver");
        String DB_URL = "jdbc:mariadb://localhost:3306/edms";
        String DB_PASSWORD = "";
        String DB_USER = "root";
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // Handle GET requests for logout
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if there is an active session, and invalidate it if present
        if (session != null) {
            session.invalidate(); // Destroy the session
        }

        // Handle "Remember Me" cookie if it's present
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember_me".equals(cookie.getName())) {
                    // Remove the remember_me token from the database
                    try (Connection con = getConnection()) {
                        RememberMeUtil.deleteRememberMeToken(con, cookie.getValue()); // Delete token from DB
                    } catch (Exception e) {
                        // Log the error and print stack trace
                        e.printStackTrace();
                    }

                    // Expire the "remember_me" cookie immediately
                    cookie.setValue("");
                    cookie.setMaxAge(0);
                    cookie.setPath("/"); // Ensure the cookie is removed from all paths
                    response.addCookie(cookie); // Add cookie to the response, effectively deleting it
                }
            }
        }

        // Redirect to the login page after successful logout
        response.sendRedirect("login.jsp");
    }

    // Handle POST requests (if applicable)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Typically, logout is a GET request. You may include any additional logic here if needed.
        doGet(request, response);
    }
}
