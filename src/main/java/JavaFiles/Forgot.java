package JavaFiles;

import com.warrenstrange.googleauth.GoogleAuthenticator;
import com.warrenstrange.googleauth.GoogleAuthenticatorKey;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Forgot {
    private static final String DB_URL = "jdbc:mariadb://localhost:3306/edms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    static final Logger LOGGER = Logger.getLogger(Forgot.class.getName());

    // Request password reset using phone number (OTP)
    public boolean requestPasswordResetByPhone(String phoneNumber) {
        String otp = generateOTP();
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "INSERT INTO reset_info (id, otp, otp_expiry) SELECT id, ?, NOW() + INTERVAL 15 MINUTE FROM registrationinfo WHERE ContactNo = ?";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, otp);
                ps.setString(2, phoneNumber);
                int updatedRows = ps.executeUpdate();
                if (updatedRows > 0) {
                    sendResetSMS(phoneNumber, otp);
                    return true;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during password reset request by phone.", e);
        }
        return false;
    }

    // Request password reset using email (Token)
    public boolean requestPasswordReset(String email) {
        String resetToken = UUID.randomUUID().toString();
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "INSERT INTO reset_info (id, reset_token, token_expiry) SELECT id, ?, NOW() + INTERVAL 15 MINUTE FROM registrationinfo WHERE email = ?";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, resetToken);
                ps.setString(2, email);
                int updatedRows = ps.executeUpdate();
                if (updatedRows > 0) {
                    sendResetEmail(email, resetToken);
                    return true;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during password reset request.", e);
        }
        return false;
    }

    // Verify the reset token for email
    public boolean verifyResetToken(String email, String token) {
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "SELECT reset_token FROM reset_info INNER JOIN registrationinfo ON reset_info.id = registrationinfo.id WHERE registrationinfo.email = ? AND reset_info.reset_token = ? AND reset_info.token_expiry > NOW()";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, email);
                ps.setString(2, token);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return true;
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error verifying reset token.", e);
        }
        return false;
    }

    // Verify the OTP for phone
    public boolean verifyOTP(String phoneNumber, String otp) {
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "SELECT otp FROM reset_info INNER JOIN registrationinfo ON reset_info.id = registrationinfo.id WHERE registrationinfo.ContactNo = ? AND reset_info.otp = ? AND reset_info.otp_expiry > NOW()";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, phoneNumber);
                ps.setString(2, otp);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return true;
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error verifying OTP.", e);
        }
        return false;
    }

    // Reset the password after verifying token or OTP
    public boolean resetPassword(String email, String newPassword) {
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "UPDATE registrationinfo SET password = ? WHERE email = ?";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, newPassword); // Hash the password before storing
                ps.setString(2, email);
                int updatedRows = ps.executeUpdate();
                if (updatedRows > 0) {
                    clearResetInfo(email);
                    sendResetNotification(email);
                    return true;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error resetting password.", e);
        }
        return false;
    }

    // Clear reset info after successful password reset
    private void clearResetInfo(String email) {
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "DELETE reset_info FROM reset_info INNER JOIN registrationinfo ON reset_info.id = registrationinfo.id WHERE registrationinfo.email = ?";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, email);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error clearing reset info.", e);
        }
    }

    private String generateOTP() {
        // Generate a 6-digit OTP
        return String.valueOf((int)(Math.random() * 900000) + 100000);
    }

    private void sendResetSMS(String phoneNumber, String otp) {
        // Implement SMS sending logic with the OTP
        LOGGER.info("Password reset SMS sent to: " + phoneNumber);
    }

    private void sendResetEmail(String email, String resetToken) {
        // Implement email sending logic with the resetToken link
        LOGGER.info("Password reset email sent to: " + email);
    }

    private void sendResetNotification(String email) {
        // Implement email or SMS notification logic
        LOGGER.info("Password reset notification sent to: " + email);
    }

    // Setup Google Authenticator for MFA
    public void setupGoogleAuthenticator(String email) {
        GoogleAuthenticator gAuth = new GoogleAuthenticator();
        final GoogleAuthenticatorKey key = gAuth.createCredentials();
        String secretKey = key.getKey();
        storeSecretKey(email, secretKey);
        String qrCodeUrl = "otpauth://totp/YourAppName:" + email + "?secret=" + secretKey + "&issuer=YourAppName";
        // Send this QR code URL to the user to scan
    }

    // Verify MFA using Google Authenticator
    public boolean verifyMFA(String email, String otp) {
        GoogleAuthenticator gAuth = new GoogleAuthenticator();
        String secretKey = getSecretKey(email);
        return gAuth.authorize(secretKey, Integer.parseInt(otp));
    }

    private void storeSecretKey(String email, String secretKey) {
        // Implement logic to store the secret key in the database
    }

    private String getSecretKey(String email) {
        // Implement logic to retrieve the secret key from the database
        return ""; // Replace with actual retrieval logic
    }
}
