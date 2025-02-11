package JavaFiles;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class post_check {
    public static void main(String[] args) {
        // Database credentials
        String url = "jdbc:mariadb://localhost:3306/edms";
        String user = "root";
        String password = "";

        // Post details
        int postId = 0; // Example post ID
        String username = "testUser";
        String description = "Test description";
        String photo1 = "photo1.jpg";
        String photo2 = "photo2.jpg";
        String zipcode = null;
        String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        int priority = 0;

        // Queries
        String zip_query = "SELECT Zipcode FROM myanmar WHERE Townships = 'Thingangyun'";
        String insert_query = "INSERT INTO user_post (id, username, description, photo1, photo2, zipcode, date, priority) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String id_query = "SELECT MAX(id) FROM user_post";

        try (Connection con = DriverManager.getConnection(url, user, password)) {
            // Fetch Zipcode
            try (PreparedStatement stmt = con.prepareStatement(zip_query);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    zipcode = rs.getString("Zipcode");
                    System.out.println("Zipcode retrieved: " + zipcode);
                } else {
                    System.out.println("No zipcode found for the given township.");
                    return;
                }
            } catch (SQLException e) {
                System.err.println("Error retrieving zipcode: " + e.getMessage());
                e.printStackTrace();
                return;
            }

            try (PreparedStatement ps = con.prepareStatement(id_query)) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    postId = rs.getInt("id")+1;
                    System.out.println("Post id retrieved: " + postId);
                }
            }
            catch (SQLException e) {
                System.err.println("Error retrieving post: " + e.getMessage());
            }

            // Insert Post
            try (PreparedStatement ps = con.prepareStatement(insert_query)) {
                ps.setInt(1, postId);
                ps.setString(2, username);
                ps.setString(3, description);
                ps.setString(4, photo1);
                ps.setString(5, photo2);
                ps.setString(6, zipcode);
                ps.setString(7, date);
                ps.setInt(8, priority);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    System.out.println("Post saved successfully.");
                } else {
                    System.out.println("Failed to save post.");
                }
            } catch (SQLException e) {
                System.err.println("Error saving post: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
