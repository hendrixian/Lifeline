package JavaFiles;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.InputStream;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.URI;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.util.zip.GZIPInputStream;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.LinkedHashMap;
import java.util.stream.Collectors;

@WebServlet("/WeatherServlet")
public class Weather extends HttpServlet {
    private static final String API_KEY = "be5abba3f222fdb00c12567a19cb6c49";
    private static final String BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
    private static final String CITIES_LIST_URL = "http://bulk.openweathermap.org/sample/city.list.json.gz";
    private static final String[] PREDEFINED_CITIES = {
            "Yangon", "Mandalay", "Sagaing",
            "Pago", "Naypyidaw", "Myeik",
            "Taunggyi", "Mawlamyine"
    };

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, JsonObject> weatherDataMap = new HashMap<>();
        Map<String, Double> myanmarTemperatures = new HashMap<>();

        // Fetch weather data for predefined cities
        for (String city : PREDEFINED_CITIES) {
            JsonObject weatherData = fetchWeather(city);
            if (weatherData != null) {
                weatherDataMap.put(city, weatherData);
                double temp = weatherData.getAsJsonObject("main").get("temp").getAsDouble();
                myanmarTemperatures.put(city, temp);
            }
        }

        // Fetch and parse the bulk list of cities
        JsonArray citiesList = fetchCitiesList();
        if (citiesList != null) {
            // Filter cities in Myanmar and add their temperatures to the map
            for (int i = 0; i < citiesList.size(); i++) {
                JsonObject city = citiesList.get(i).getAsJsonObject();
                String country = city.get("country").getAsString();
                if ("MM".equals(country)) { // "MM" is the country code for Myanmar
                    String cityName = city.get("name").getAsString();
                    int cityId = city.get("id").getAsInt();
                    JsonObject weatherData = fetchWeatherById(cityId);
                    if (weatherData != null) {
                        double temp = weatherData.getAsJsonObject("main").get("temp").getAsDouble();
                        myanmarTemperatures.put(cityName, temp);
                    }
                }
            }
        }

        // Sort to find the 3 highest temperatures
        Map<String, Double> highestTemperatures = myanmarTemperatures.entrySet()
                .stream()
                .sorted((a, b) -> Double.compare(b.getValue(), a.getValue()))
                .limit(3)
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (e1, e2) -> e1,
                        LinkedHashMap::new
                ));

        // Sort to find the 3 lowest temperatures
        Map<String, Double> lowestTemperatures = myanmarTemperatures.entrySet()
                .stream()
                .sorted(Map.Entry.comparingByValue())
                .limit(3)
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (e1, e2) -> e1,
                        LinkedHashMap::new
                ));

        // Debugging outputs
        System.out.println("Weather Data Map (Predefined Cities): " + weatherDataMap);
        System.out.println("Highest Temperatures: " + highestTemperatures);
        System.out.println("Lowest Temperatures: " + lowestTemperatures);

        // Set attributes for the JSP
        request.setAttribute("weatherDataMap", weatherDataMap);
        request.setAttribute("highestTemperatures", highestTemperatures);
        request.setAttribute("lowestTemperatures", lowestTemperatures);

        // Forward to JSP
        request.getRequestDispatcher("Weather.jsp").forward(request, response);
    }

    private JsonObject fetchWeather(String city) {
        try {
            String urlString = BASE_URL + "?q=" + city + "&appid=" + API_KEY + "&units=metric";
            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(urlString))
                    .timeout(Duration.ofSeconds(10))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                return JsonParser.parseString(response.body()).getAsJsonObject();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // Restore interrupted status
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private JsonArray fetchCitiesList() {
        try {
            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(CITIES_LIST_URL))
                    .timeout(Duration.ofSeconds(10))
                    .build();

            HttpResponse<InputStream> response = client.send(request, HttpResponse.BodyHandlers.ofInputStream());

            if (response.statusCode() == 200) {
                // Decompress the .gz file
                GZIPInputStream gzipInputStream = new GZIPInputStream(response.body());
                BufferedReader reader = new BufferedReader(new InputStreamReader(gzipInputStream));
                StringBuilder jsonContent = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonContent.append(line);
                }
                // Parse the JSON array
                return JsonParser.parseString(jsonContent.toString()).getAsJsonArray();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // Restore interrupted status
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private JsonObject fetchWeatherById(int cityId) {
        try {
            String urlString = BASE_URL + "?id=" + cityId + "&appid=" + API_KEY + "&units=metric";
            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(urlString))
                    .timeout(Duration.ofSeconds(10))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                return JsonParser.parseString(response.body()).getAsJsonObject();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // Restore interrupted status
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}