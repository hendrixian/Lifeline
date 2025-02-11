<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Weather Detail</title>
    <link rel="stylesheet" href="CSS/Weather.css">
</head>
<body>
<h1>Weather Details</h1>
<%
    // Get the city from the request parameter
    String city = request.getParameter("city");

    // If the city is null or empty, redirect to the homepage
    if (city == null || city.isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Call the method to fetch weather data for the selected city
    String weatherDataJson = fetchWeatherData(city);

    // Parse the JSON data
    if (weatherDataJson != null) {
        JsonObject weatherData = new JsonObject();
        double temperature = weatherData.getAsJsonObject("main").get("temp").getAsDouble();
        String description = weatherData.getAsJsonArray("weather").get(0).getAsJsonObject().get("description").getAsString();
%>

<h2><%= city %></h2>
<p><strong>Temperature:</strong> <%= temperature %> °C</p>
<p><strong>Description:</strong> <%= description %></p>

<%
} else {
%>
<p>Weather data not available for <%= city %>. Please try again later.</p>
<%
    }
%>

</body>
</html>

<%!
    public String fetchWeatherData(String city) {
        try {
            String apiKey = "be5abba3f222fdb00c12567a19cb6c49";
            String urlString = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=" + apiKey + "&units=metric";
            URL url = new URL(urlString);

            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");

            int responseCode = connection.getResponseCode();
            if (responseCode == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                StringBuilder responseString = new StringBuilder();
                String line;

                while ((line = reader.readLine()) != null) {
                    responseString.append(line);
                }
                reader.close();
                return responseString.toString();
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
%>
