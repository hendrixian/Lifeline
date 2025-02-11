package JavaFiles;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.net.HttpURLConnection;
import java.net.URL;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class testConnection {

    // Method to get the database connection
    private static Connection getDatabaseConnection() throws Exception {
        String url = "jdbc:mariadb://localhost:3306/edms";
        String username = "root";
        String password = ""; // Replace with your actual password

        // Explicitly load the MariaDB driver (optional)
        Class.forName("org.mariadb.jdbc.Driver");

        System.out.println("Connected to database");
        return DriverManager.getConnection(url, username, password);
    }

    // Method to fetch weather data from OpenWeather API
    private static JsonObject fetchWeather(String city) {
        String apiKey = "be5abba3f222fdb00c12567a19cb6c49";  // Use your own API key
        String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

        try {
            String urlString = baseUrl + "?q=" + city + "&appid=" + apiKey + "&units=metric";  // Add the city and API key
            URL url = new URL(urlString);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");

            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();

            // Parse the response into a JSON object
            JsonObject weatherData = JsonParser.parseString(response.toString()).getAsJsonObject();
            return weatherData;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Main method to test the connection and fetch data from the API
    public static void main(String[] args) {
        try {
            // Connect to the database
            Connection connection = getDatabaseConnection();
            // Fetch city names from database (optional)
            PreparedStatement statement = connection.prepareStatement("SELECT DISTINCT Cities FROM myanmar");
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                String city = resultSet.getString("Cities");
                System.out.println("Fetching weather for city: " + city);

                // Fetch weather data for each city
                JsonObject weatherData = fetchWeather(city);
                if (weatherData != null) {
                    System.out.println("Weather data for " + city + ": " + weatherData.toString());
                } else {
                    System.out.println("Failed to fetch weather for " + city);
                }
            }

            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
