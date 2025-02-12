package JavaFiles;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;
import java.util.zip.GZIPInputStream;
import java.util.LinkedHashMap; // Add this import

@WebServlet("/WeatherServlet")
public class Weather extends HttpServlet {

    private static final String API_KEY = "be5abba3f222fdb00c12567a19cb6c49";
    private static final String BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
    private static final String CITIES_LIST_URL = "http://bulk.openweathermap.org/sample/city.list.json.gz";
    private static final String[] PREDEFINED_CITIES = {
            "Yangon", "Mandalay", "Sagaing", "Pago", "Naypyidaw", "Myeik", "Taunggyi", "Mawlamyine"
    };

    // Map to track ongoing HTTP requests
    private static final Map<String, CompletableFuture<JsonObject>> ongoingRequests = new ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Concurrent map to store city temperatures
        Map<String, Double> myanmarTemperatures = new ConcurrentHashMap<>();

        // Fetch weather data for predefined cities asynchronously
        for (String city : PREDEFINED_CITIES) {
            fetchWeather(city, myanmarTemperatures);
        }

        // Fetch and process the bulk list of cities
        JsonArray citiesList = fetchCitiesList();
        if (citiesList != null) {
            processCitiesList(citiesList, myanmarTemperatures);
        }

        // Wait for all ongoing requests to complete
        CompletableFuture.allOf(ongoingRequests.values().toArray(new CompletableFuture[0])).join();

        // Sort and get the top 3 highest and lowest temperatures
        Map<String, Double> highestTemperatures = getTopTemperatures(myanmarTemperatures, true);
        Map<String, Double> lowestTemperatures = getTopTemperatures(myanmarTemperatures, false);

        // Set attributes for the JSP
        request.setAttribute("highestTemperatures", highestTemperatures);
        request.setAttribute("lowestTemperatures", lowestTemperatures);

        // Forward to JSP
        request.getRequestDispatcher("Weather.jsp").forward(request, response);
    }

    /**
     * Fetches weather data for a city asynchronously and updates the temperatures map.
     */
    private void fetchWeather(String city, Map<String, Double> myanmarTemperatures) {
        String urlString = BASE_URL + "?q=" + city + "&appid=" + API_KEY + "&units=metric";
        sendHttpRequest(urlString).thenAccept(weatherData -> {
            if (weatherData != null) {
                double temp = weatherData.getAsJsonObject("main").get("temp").getAsDouble();
                myanmarTemperatures.put(city, temp);
            }
        });
    }

    /**
     * Sends an asynchronous HTTP request and returns a CompletableFuture with the response.
     */
    private CompletableFuture<JsonObject> sendHttpRequest(String urlString) {
        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(urlString))
                .timeout(Duration.ofSeconds(10))
                .build();

        CompletableFuture<JsonObject> future = client.sendAsync(request, HttpResponse.BodyHandlers.ofString())
                .thenApply(response -> {
                    if (response.statusCode() == 200) {
                        return JsonParser.parseString(response.body()).getAsJsonObject();
                    } else {
                        System.err.println("Failed to fetch data: " + response.statusCode());
                        return null;
                    }
                })
                .exceptionally(e -> {
                    System.err.println("Error during HTTP request: " + e.getMessage());
                    return null;
                });

        // Track the ongoing request
        ongoingRequests.put(urlString, future);
        future.whenComplete((result, error) -> ongoingRequests.remove(urlString));
        return future;
    }

    /**
     * Fetches the list of cities from the OpenWeatherMap bulk data endpoint.
     */
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
                GZIPInputStream gzipInputStream = new GZIPInputStream(response.body());
                BufferedReader reader = new BufferedReader(new InputStreamReader(gzipInputStream));
                StringBuilder jsonContent = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonContent.append(line);
                }
                return JsonParser.parseString(jsonContent.toString()).getAsJsonArray();
            }
        } catch (Exception e) {
            System.err.println("Error fetching cities list: " + e.getMessage());
        }
        return null;
    }

    /**
     * Processes the list of cities and fetches weather data for cities in Myanmar.
     */
    private void processCitiesList(JsonArray citiesList, Map<String, Double> myanmarTemperatures) {
        for (int i = 0; i < citiesList.size(); i++) {
            JsonObject city = citiesList.get(i).getAsJsonObject();
            String country = city.get("country").getAsString();
            if ("MM".equals(country)) { // Filter cities from Myanmar
                String cityName = city.get("name").getAsString();
                int cityId = city.get("id").getAsInt();
                fetchWeatherById(cityId, myanmarTemperatures);
            }
        }
    }

    /**
     * Fetches weather data for a city by ID asynchronously.
     */
    private void fetchWeatherById(int cityId, Map<String, Double> myanmarTemperatures) {
        String urlString = BASE_URL + "?id=" + cityId + "&appid=" + API_KEY + "&units=metric";
        sendHttpRequest(urlString).thenAccept(weatherData -> {
            if (weatherData != null) {
                double temp = weatherData.getAsJsonObject("main").get("temp").getAsDouble();
                String cityName = weatherData.get("name").getAsString();
                myanmarTemperatures.put(cityName, temp);
            }
        });
    }

    /**
     * Returns the top 3 highest or lowest temperatures from the given map.
     */
    private Map<String, Double> getTopTemperatures(Map<String, Double> temperatures, boolean highest) {
        return temperatures.entrySet()
                .stream()
                .sorted((a, b) -> highest ? Double.compare(b.getValue(), a.getValue()) : Double.compare(a.getValue(), b.getValue()))
                .limit(3)
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (e1, e2) -> e1,
                        LinkedHashMap::new
                ));
    }

    /**
     * Shutdown hook to cancel ongoing requests when the server shuts down.
     */
    static {
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            ongoingRequests.forEach((url, future) -> future.cancel(true));
        }));
    }
}