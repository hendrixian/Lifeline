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
import java.io.PrintWriter;
import java.io.Serial;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@MultipartConfig

@WebServlet(name = "Representative", urlPatterns = {"/Representative"})
public class Representative extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;
    PrintWriter out;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection con = null;
        PrintWriter out = response.getWriter();
        response.setContentType("text/html");
        out.println("Debug: Servlet Invoked");

        try {
            // Step 1: Establish database connection
            out.println("Connecting to database...");
            Class.forName("org.mariadb.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/edms", "root", "");
            out.println("Database connected successfully.");

            // Step 2: Get form parameters
            out.println("Retrieving form parameters...");
            String representativeName = request.getParameter("Representativename");
            String shelterName = request.getParameter("ShelterName");
            String Email = request.getParameter("Email");
            String password1 = request.getParameter("password1");
            String password2 = request.getParameter("password2");
            String type = request.getParameter("Type");
            String funding = request.getParameter("Funding");
            String url = request.getParameter("URL");
            Part photo1 = request.getPart("Photo1");
            Part photo2 = request.getPart("Photo2");
            String contact = request.getParameter("Contact");
            String affectedMale = request.getParameter("AffectedMale");
            String affectedFemale = request.getParameter("AffectedFemale");
            String affectedChildren = request.getParameter("AffectedChildren");
            String staffTotal = request.getParameter("StaffTotal");
            String division = request.getParameter("Division");
            String city = request.getParameter("City");
            String township = request.getParameter("Township");
            String description = request.getParameter("Description");
            String capacity = request.getParameter("Capacity");
            String activity = request.getParameter("Activity");
            String priority = request.getParameter("Priority");
            String totalPriority = request.getParameter("TotalPriority");

            out.println("Parameters retrieved successfully.");

            // Step 3: Check for duplicate username
            out.println("Checking for duplicate username...");
            String checkQuery = "SELECT COUNT(*) FROM representative WHERE Representativename = ?";
            try (PreparedStatement checkStmt = con.prepareStatement(checkQuery)) {
                checkStmt.setString(1, representativeName);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    request.setAttribute("message", "Username already exists.");
                    request.getRequestDispatcher("representative.jsp").forward(request, response);
                    return;
                }
            }

            if (!password1.equals(password2)) {
                request.setAttribute("message", "Passwords do not match");
                request.getRequestDispatcher("representative.jsp").forward(request, response);
                return;
            }
            // Step 4: Retrieve Zipcode from the database
            out.println("Fetching Zipcode for Division, City, and Township...");
            String zipcode = null;
            String zipcodeQuery = "SELECT Zipcode FROM myanmar WHERE Divisions = ? AND Cities = ? AND Townships = ?";
            try (PreparedStatement zipcodeStmt = con.prepareStatement(zipcodeQuery)) {
                zipcodeStmt.setString(1, division);
                zipcodeStmt.setString(2, city);
                zipcodeStmt.setString(3, township);
                ResultSet rs = zipcodeStmt.executeQuery();
                if (rs.next()) {
                    zipcode = rs.getString("Zipcode");
                    out.println("Zipcode found: " + zipcode);
                } else {
                    request.setAttribute("message", "Invalid Division, City, or Township. Please check your input.");
                    request.getRequestDispatcher("representative.jsp").forward(request, response);
                    return;
                }
            }

            // Step 5: Insert data into the database
            out.println("Inserting representative data...");
            String insertQuery = "INSERT INTO representative (Representativename, sheltername, Email, Password, type, funding, url, photo1, photo2, contact, affectedmale, affectedfemale, affectedchildren, stafftotal, Zipcode, description, capacity, activity, priority, totalpriority) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertQuery)) {
                // Prepare password hash
                String hashedPassword = BCrypt.hashpw(password1, BCrypt.gensalt());

                InputStream photo1Stream = (photo1 != null && photo1.getSize() > 0) ? photo1.getInputStream() : null;
                InputStream photo2Stream = (photo2 != null && photo2.getSize() > 0) ? photo2.getInputStream() : null;

                ps.setString(1, representativeName);
                ps.setString(2, shelterName);
                ps.setString(3, Email);
                ps.setString(4, hashedPassword);
                ps.setString(5, type);
                ps.setString(6, funding);
                ps.setString(7, url);
                ps.setBlob(8, photo1Stream);
                ps.setBlob(9, photo2Stream);
                ps.setString(10, contact);
                ps.setString(11, affectedMale);
                ps.setString(12, affectedFemale);
                ps.setString(13, affectedChildren);
                ps.setString(14, staffTotal);
                ps.setString(15, zipcode);
                ps.setString(16, description);
                ps.setString(17, capacity);
                ps.setString(18, activity);
                ps.setString(19, priority);
                ps.setString(20, totalPriority);

                int res = ps.executeUpdate();
                if (res > 0) {
                    out.println("Insert successful. Redirecting to Login.jsp...");
                    response.sendRedirect("Login.jsp");
                } else {
                    request.setAttribute("message", "Registration failed. Try again.");
                    request.getRequestDispatcher("representative.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace(out);
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("representative.jsp").forward(request, response);
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace(out);
            }
        }
    }
}
