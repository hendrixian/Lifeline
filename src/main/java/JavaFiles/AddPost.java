package JavaFiles;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@MultipartConfig
@WebServlet(name = "AddPost", urlPatterns = {"/AddPost"})
public class AddPost extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection con = null;
        System.out.println("Request received: " + new Date());

        try {
            // Establish database connection
            Class.forName("org.mariadb.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/edms", "root", "");
            System.out.println("Connection established.");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database connection error.");
            return;
        }

        // Validate user session
        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("loggedInUser") : null;

        if (username == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Get form inputs
        String postDescription = request.getParameter("PostString");
        String selectedDivision = request.getParameter("Divisionitem");
        String selectedCity = request.getParameter("Cityitem");
        String selectedTownship = request.getParameter("Townshipitem");

        // Fetch Zipcode
        String zipcode = fetchZipcode(con, selectedDivision, selectedCity, selectedTownship);
        if (zipcode == null) {
            request.setAttribute("message", "No Zipcode found for the selected location.");
            request.getRequestDispatcher("AddPost.jsp").forward(request, response);
            return;
        }

        // Handle file uploads
        Part photo1 = request.getPart("ImageName1");
        Part photo2 = request.getPart("ImageName2");

        if (!isValidImage(photo1) || !isValidImage(photo2)) {
            request.setAttribute("message", "Invalid image file. Please upload valid images.");
            request.getRequestDispatcher("AddPost.jsp").forward(request, response);
            return;
        }

        // Directory for storing images
        String uploadPath = "D:/projects/Java project/java projects_intellij/Lifeline/post_images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to create directory for file uploads.");
            return;
        }

        // Generate Post ID using the previous approach
        int postId = fetchPostId(con);

        // Save images with dynamic names
        String fileName1 = saveFile(photo1, uploadPath, postId, username, 1);
        String fileName2 = saveFile(photo2, uploadPath, postId, username, 2);

        // Save post to the database using the previous approach
        if (savePost(con, postId, username, postDescription, fileName1, fileName2, zipcode)) {
            response.sendRedirect("Profile.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save post.");
        }
    }

    private String fetchZipcode(Connection con, String division, String city, String township) {
        String query = "SELECT Zipcode FROM myanmar WHERE Divisions = ? AND Cities = ? AND Townships = ?";
        try (PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setString(1, division);
            stmt.setString(2, city);
            stmt.setString(3, township);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Zipcode");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private boolean isValidImage(Part part) {
        String contentType = part.getContentType();
        return contentType != null && contentType.startsWith("image/");
    }

    private int fetchPostId(Connection con) {
        String query = "SELECT MAX(id) FROM user_post";
        try (PreparedStatement stmt = con.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) + 1; // Increment max ID by 1
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1; // Default ID if table is empty
    }

    private String saveFile(Part part, String uploadPath, int postId, String username, int photoNumber) throws IOException {
        String extension = extractFileExtension(part);
        String fileName = postId + "_" + username + "_photo" + photoNumber + extension;
        File file = new File(uploadPath, fileName);
        try (InputStream inputStream = part.getInputStream();
             FileOutputStream outputStream = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        }
        return fileName;
    }

    private String extractFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String content : contentDisp.split(";")) {
            if (content.trim().startsWith("filename")) {
                String fileName = content.substring(content.indexOf('=') + 2, content.length() - 1);
                return fileName.substring(fileName.lastIndexOf('.'));
            }
        }
        return "";
    }

    private boolean savePost(Connection con, int postId, String username, String description, String photo1, String photo2, String zipcode) {
        String query = "INSERT INTO user_post (id, username, description, photo1, photo2, zipcode, date, priority) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, postId);
            ps.setString(2, username);
            ps.setString(3, description);
            ps.setString(4, photo1);
            ps.setString(5, photo2);
            ps.setString(6, zipcode);
            ps.setString(7, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            ps.setInt(8, 0); // Priority default value
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
