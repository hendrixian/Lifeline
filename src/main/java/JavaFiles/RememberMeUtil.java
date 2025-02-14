package JavaFiles;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for handling "Remember Me" authentication.
 * this will deal with DB
 */
@WebServlet(name = "Login", urlPatterns = {"/Login"})

public class RememberMeUtil {
    private static final SecureRandom random = new SecureRandom();
    private static final Logger LOGGER = Logger.getLogger(RememberMeUtil.class.getName());

    // Generate a secure token
    public static String generateToken() {
        byte[] bytes = new byte[64]; // 64 bytes = 512 bits
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    // Set the "Remember Me" cookie in the response
    public static void setRememberMeCookie(HttpServletResponse response, String token, int maxAge) {
        Cookie cookie = new Cookie("remember_me", token);
        cookie.setMaxAge(maxAge); // 30 days = (30 * 24 * 60 * 60)
        cookie.setHttpOnly(true); // Secure against XSS
        cookie.setSecure(true); // Ensure HTTPS only
        cookie.setPath("/"); // Accessible site-wide
        response.addCookie(cookie);
    }

    // Store the remember-me token in the database
    public static void storeRememberMeToken(Connection con, int userId, String token, Timestamp expiryDate) {
        String query = "INSERT INTO remember_me_tokens (ID, token, expiry_date) VALUES (?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE token = VALUES(token), expiry_date = VALUES(expiry_date)";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiryDate);
            ps.executeUpdate();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error storing remember me token.", e);
        }
    }

    // Validate the token and return the user ID
    public static int validateRememberMeToken(Connection con, String token) {
        String query = "SELECT ID FROM remember_me_tokens WHERE token = ? AND expiry_date > NOW()";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ID"); // Return the user ID if token is valid
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error validating remember me token.", e);
        }
        return -1; // Invalid token
    }

    // Fetch username based on user ID
    public static String getUsernameById(Connection con, int userId) {
        String query = "SELECT username FROM user WHERE ID = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("username");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching username.", e);
        }
        return null;
    }

    // Delete the token (e.g., on logout)
    public static void deleteRememberMeToken(Connection con, String token) {
        String query = "DELETE FROM remember_me_tokens WHERE token = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting remember me token.", e);
        }
    }
}
