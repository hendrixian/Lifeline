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
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

@MultipartConfig
@WebServlet(name = "AddContribution", urlPatterns = { "/AddContribution" })
public class AddContribution extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Connection con = null;

		// Get form data
		String locationUsername = request.getParameter("LocationUsername");
		String email = request.getParameter("Email");
		String shelterName = request.getParameter("ShelterName");
		double amount = Double.parseDouble(request.getParameter("Amount"));
		String paymentMethod = request.getParameter("PaymentMethod");
		String cardInfo = request.getParameter("CardInfo");
		String note = request.getParameter("Note");
		try {
			Class.forName("org.mariadb.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/edms", "root", "");

			String sql = "INSERT INTO contributions (LocationUsername, Email, ShelterName, Amount, PaymentMethod, CardInfo, Note, Date, Seconds) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(sql);

			ps.setString(1, locationUsername);
			ps.setString(2, email);
			ps.setString(3, shelterName);
			ps.setDouble(4, amount);
			ps.setString(5, paymentMethod);
			ps.setString(6, cardInfo);
			ps.setString(7, note);

			Date currentDate = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
			ps.setString(8, sdf.format(currentDate));

			long seconds = currentDate.getTime() / 1000;
			ps.setLong(9, seconds);

			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		response.sendRedirect("success.jsp");
	}
}
