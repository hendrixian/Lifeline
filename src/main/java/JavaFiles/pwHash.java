package JavaFiles;

import org.mindrot.jbcrypt.BCrypt;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class pwHash {
    private static final String DB_URL = "jdbc:mariadb://localhost:3306/edms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    public static void main(String[] args) {
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String selectQuery = "SELECT Username, Password FROM user";
            try (PreparedStatement ps = con.prepareStatement(selectQuery);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    String username = rs.getString("Username");
                    String plainPassword = rs.getString("Password");

                    // Check if the password is plain-text (not hashed)
                    if (!plainPassword.startsWith("$2")) {  // Checking for all bcrypt hashes
                        // Hash the plain-text password
                        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

                        // Update the hashed password in the database
                        String updateQuery = "UPDATE user SET Password = ? WHERE Username = ?";
                        try (PreparedStatement updatePs = con.prepareStatement(updateQuery)) {
                            updatePs.setString(1, hashedPassword);
                            updatePs.setString(2, username);
                            updatePs.executeUpdate();
                            System.out.println("Updated password for user: " + username);
                        }
                    }
                }
            }
            System.out.println("Password hashing completed.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
