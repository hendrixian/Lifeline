package JavaFiles;

import java.nio.charset.StandardCharsets;
import java.util.Random;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class OTPHandler {

    // Generate a 6-digit OTP
    public String generateOTP() {
        Random rand = new Random();
        return String.format("%06d", rand.nextInt(1000000));
    }

    // Validate OTP based on stored data in the database (similar to the verifyOTP method)
    public boolean verifyOTP(String phoneNumber, String otp) {
        // Database logic for verifying OTP
        // Example:
        // - Retrieve OTP from the database
        // - Check if the OTP matches the one entered and if it's still valid (not expired)
        return true; // Implement actual validation logic
    }

    // Send OTP via SMS (integrate with an API like Twilio or VerifyNow)
    public void sendOTP(String phoneNumber, String otp) {
        try {
            // Define the SMS API endpoint and parameters
            String apiUrl = "http://global.datagenit.com/API/sms-api.php";
            String authToken = "your_auth_token";  // Replace with your API auth token
            String senderId = "your_sender_id";  // Replace with your sender ID
            String message = "Your OTP is: " + otp;  // Message body

            // Create the URL for the request with parameters
            String urlString = apiUrl + "?auth=" + URLEncoder.encode(authToken, StandardCharsets.UTF_8) +
                    "&senderid=" + URLEncoder.encode(senderId, StandardCharsets.UTF_8) +
                    "&msisdn=" + URLEncoder.encode(phoneNumber, StandardCharsets.UTF_8) +
                    "&message=" + URLEncoder.encode(message, StandardCharsets.UTF_8);

            // Make the HTTP GET request to the API
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setUseCaches(false);
            conn.connect();

            // Read the response
            BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line;
            StringBuilder responseBuffer = new StringBuilder();
            while ((line = rd.readLine()) != null) {
                responseBuffer.append(line).append("\n");
            }
            System.out.println(responseBuffer.toString());  // Print the response (for debugging)
            rd.close();
            conn.disconnect();

        } catch (Exception e) {
            e.printStackTrace();  // Log any errors
        }
    }
}
