<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Weather Updates</title>
    <link rel="stylesheet" href="CSS/Weather.css">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let containers = document.querySelectorAll(".city-container");
            let dots = document.querySelectorAll(".dot");
            let currentIndex = 0;
            containers[currentIndex].classList.add("active");
            dots[currentIndex].classList.add("active");

            function showContainer(index) {
                containers[currentIndex].classList.remove("active");
                dots[currentIndex].classList.remove("active");

                currentIndex = (index + containers.length) % containers.length;

                containers[currentIndex].classList.add("active");
                dots[currentIndex].classList.add("active");
            }

            setInterval(function () {
                showContainer(currentIndex + 1);
            }, 10000);

            containers.forEach((container, index) => {
                container.querySelector(".arrow.left").addEventListener("click", function () {
                    showContainer(index - 1);
                });

                container.querySelector(".arrow.right").addEventListener("click", function () {
                    showContainer(index + 1);
                });
            });

            dots.forEach((dot, index) => {
                dot.addEventListener("click", function () {
                    showContainer(index);
                });
            });
        });

        function filterCities() {
            let input = document.getElementById('searchBar').value.toLowerCase();
            let containers = document.querySelectorAll('.city-container');
            let suggestionsContainer = document.getElementById('suggestions');
            suggestionsContainer.innerHTML = ''; // Clear previous suggestions

            // If there is no input, hide the suggestions dropdown
            if (input.length === 0) {
                suggestionsContainer.style.display = 'none';
                return;
            }

            let found = false;

            containers.forEach(container => {
                let cityName = container.querySelector('h2').innerText.toLowerCase();
                if (cityName.includes(input)) {
                    found = true;

                    // Create a suggestion div for matching city names
                    let suggestionDiv = document.createElement('div');
                    suggestionDiv.textContent = cityName;
                    suggestionDiv.addEventListener('click', function () {
                        // Redirect to weather_detail.jsp with the selected city
                        window.location.href = `weather_detail.jsp?city=${cityName}`;
                    });
                    suggestionsContainer.appendChild(suggestionDiv);
                }
            });

            if (found) {
                suggestionsContainer.style.display = 'block'; // Show the dropdown if there are suggestions
            } else {
                suggestionsContainer.style.display = 'none'; // Hide the dropdown if no matches
            }
        }


    </script>
</head>
<body>
    <div class="header">
        <h1>Weather Updates</h1>
    </div>

    <div class="container-wrapper">
        <input type="text" id="searchBar" placeholder="Search for a city..." onkeyup="filterCities()"/>
        <div id="suggestions" class="suggestions-dropdown" style="display: none;"></div>
        <%
            Map<String, JsonObject> weatherDataMap = (Map<String, JsonObject>) request.getAttribute("weatherDataMap");

            if (weatherDataMap != null) {
                for (Map.Entry<String, JsonObject> entry : weatherDataMap.entrySet()) {
                    String city = entry.getKey();
                    JsonObject weatherData = entry.getValue();
                    double temperature = weatherData.getAsJsonObject("main").get("temp").getAsDouble();
                    String description = weatherData.getAsJsonArray("weather")
                            .get(0).getAsJsonObject()
                            .get("description").getAsString();
        %>


        <div class="city-container">
            <div class="arrow left">&#9664;</div>
            <h2><%= city %>
            </h2>
            <p><strong>Temperature:</strong> <%= temperature %> °C</p>
            <p><strong>Description:</strong> <%= description %>
            </p>
            <div class="arrow right">&#9654;</div>
            <div class="pagination-dots">
                <%
                    int dotCount = weatherDataMap.size();
                    for (int i = 0; i < dotCount; i++) {
                %>
                <span class="dot"></span>
                <%
                    }
                %>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <p>No weather data available. Please try again later.</p>
        <%
            }
        %>
        <div class=new-container>
            <div class="temp-new-container">
                <h2>Notable Water Levels</h2>
                <dt class="mb-2">
                    <h3 class="text-lg font-semibold">Top 3 Highest Temperatures:</h3>
                    <ul class="list-disc ml-6">
                        <c:forEach items="${highestTemperatures}" var="entry">
                            <li>${entry.key}: <strong>${entry.value} °C</strong></li>
                        </c:forEach>
                    </ul>
                </dt>
                <dt class="mt-4">
                    <h3 class="text-lg font-semibold">Top 3 Lowest Temperatures:</h3>
                    <ul class="list-disc ml-6">
                        <c:forEach items="${lowestTemperatures}" var="entry">
                            <li>${entry.key}: <strong>${entry.value} °C</strong></li>
                        </c:forEach>
                    </ul>
                </dt>
            </div>
            <div class="water-new-container">
                <h2>Notable Temperature</h2>
                <dt class="mb-2">
                    <h3 class="text-lg font-semibold">Top 3 Highest Temperatures:</h3>
                    <ul class="list-disc ml-6">
                        <c:forEach items="${highestTemperatures}" var="entry">
                            <li>${entry.key}: <strong>${entry.value} °C</strong></li>
                        </c:forEach>
                    </ul>
                </dt>
                <dt class="mt-4">
                    <h3 class="text-lg font-semibold">Top 3 Lowest Temperatures:</h3>
                    <ul class="list-disc ml-6">
                        <c:forEach items="${lowestTemperatures}" var="entry">
                            <li>${entry.key}: <strong>${entry.value} °C</strong></li>
                        </c:forEach>
                    </ul>
                </dt>
            </div>
        </div>


    </div>

</body>
</html>
