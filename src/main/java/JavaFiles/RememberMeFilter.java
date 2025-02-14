package JavaFiles;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.logging.Logger;

/**
 * A filter that checks for a "remember me" cookie and logs in the user automatically.
 * this will deal with session
 */
@WebServlet(name = "Login", urlPatterns = {"/Login"})

public class RememberMeFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(Login.class.getName());

    private Connection getConnection() throws Exception {
        Class.forName("org.mariadb.jdbc.Driver");
        String DB_URL = "jdbc:mariadb://localhost:3306/edms";
        String DB_PASSWORD = "";
        String DB_USER = "root";
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        // If user is NOT logged in, check for remember-me cookie
        if (session == null || session.getAttribute("user_id") == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("remember_me".equals(cookie.getName())) {
                        String token = cookie.getValue();
                        try (Connection con = getConnection()) {
                            int userId = RememberMeUtil.validateRememberMeToken(con, token);
                            if (userId != -1) { // Valid token found
                                session = request.getSession(true); // Create session if null
                                session.setAttribute("user_id", userId);

                                // Fetch username and store it in session
                                String username = RememberMeUtil.getUsernameById(con, userId);
                                session.setAttribute("username", username);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        break;
                    }
                }
            }
        }
        chain.doFilter(req, res);
    }
}
