package JavaFiles;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

@MultipartConfig
@WebServlet(name="AddAskHelp", urlPatterns = {"/AddAskHelp"})
public class AddAskHelp extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection con = null;

		// Extract form parameters
		String description = request.getParameter("Description");
		String ams = request.getParameter("help-am");
		String afs = request.getParameter("help-af");
		String acs = request.getParameter("help-ac");

		// Convert string inputs to integers
		int am = Integer.parseInt(ams);
		int af = Integer.parseInt(afs);
		int ac = Integer.parseInt(acs);

		try {
			// Load MySQL Driver
			Class.forName("org.mariadb.jdbc.Driver");

			// Establish database connection
			con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/edms", "root", "");
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			request.setAttribute("message", "Database connection error: " + e.getMessage());
			request.getRequestDispatcher("AddAskHelp.jsp").forward(request, response);
			return;
		}

		// Get image parts from the request
		Part part1 = request.getPart("ImageName1");
		Part part2 = request.getPart("ImageName2");

		// Validate image formats
		if (!isValidImage(part1.getContentType())) {
			request.setAttribute("message", "Provide a proper image (Photo 1)");
			request.getRequestDispatcher("AddAskHelp.jsp").forward(request, response);
			return;
		} else if (!isValidImage(part2.getContentType())) {
			request.setAttribute("message", "Provide a proper image (Photo 2)");
			request.getRequestDispatcher("AddAskHelp.jsp").forward(request, response);
			return;
		}

		try (InputStream is1 = part1.getInputStream(); InputStream is2 = part2.getInputStream()) {
			// Prepare SQL query to insert into the database
			String sql = "INSERT INTO user_loc_1_askhelp (Description, Photo1, Photo2, affectedmale, affectedfemale, affectedchildren, Date, Second) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, description);
			ps.setBlob(2, is1);
			ps.setBlob(3, is2);
			ps.setInt(4, am);
			ps.setInt(5, af);
			ps.setInt(6, ac);

			// Get current date and format it
			Date currentDate = new Date();
			SimpleDateFormat dateFormat = new SimpleDateFormat("h:mma dd MMM, yyyy", Locale.ENGLISH);
			String formattedDateTime = dateFormat.format(currentDate);
			ps.setString(7, formattedDateTime);

			// Convert date to seconds since epoch for 'Second' field
			long secondsSinceEpoch = currentDate.getTime() / 1000;
			ps.setLong(8, secondsSinceEpoch);

			// Execute update
			int rowsInserted = ps.executeUpdate();
			if (rowsInserted > 0) {
				request.setAttribute("message", "Data saved successfully!");
			} else {
				request.setAttribute("message", "Failed to save data. Please try again.");
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("message", "Error during data insertion: " + e.getMessage());
		} finally {
			try {
				if (con != null) con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		// Redirect or forward to a confirmation page
		request.getRequestDispatcher("AddAskHelp.jsp").forward(request, response);
	}

	private boolean isValidImage(String contentType) {
		// Validate image content type
		return contentType != null && (contentType.startsWith("image/jpeg") || contentType.startsWith("image/png") ||
				contentType.startsWith("image/gif") || contentType.startsWith("image/jpg") ||
				contentType.startsWith("image/svg") || contentType.startsWith("image/webp"));
	}
}
