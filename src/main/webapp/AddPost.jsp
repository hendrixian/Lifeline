<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@page import="java.sql.*" %>

<%

    Connection con = null;

    try {
        Class.forName("org.mariadb.jdbc.Driver");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }
    try {
        con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/edms", "root", "");
    } catch (SQLException e) {
        e.printStackTrace();
    }

%>

<%
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        String currentURL = request.getRequestURI();
        session.setAttribute("redirectURL", currentURL);
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!DOCTYPE html>

<head>
    <title>Emergency Disaster Management System</title>
    <link rel="stylesheet" href="CSS/Profile.css"/>
    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- DaisyUI CDN -->
    <link href="https://cdn.jsdelivr.net/npm/daisyui@3.7.3/dist/full.css" rel="stylesheet" type="text/css"/>
    <!-- Animate.css CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <!-- AOS CDN -->
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css"/>
    <!-- Font Awesome -->
    <script src="https://kit.fontawesome.com/f13afb77f1.js" crossorigin="anonymous"></script>
    <script src="LocationData.js" defer></script>
</head>

<body>


<script>


    window.onload = function () {
        console.log(subjectObject); // Log the object to verify it's loaded
        const DivisionSelect = document.getElementById("DivisionSelect");
        const CitySelect = document.getElementById("CitySelect");
        const TownshipSelect = document.getElementById("TownshipSelect");

        // Populate Division dropdown
        for (const division in subjectObject) {
            DivisionSelect.options[DivisionSelect.options.length] = new Option(division, division);
        }

        DivisionSelect.onchange = function () {
            console.log("Division: " + this.value);
            CitySelect.length = 1; // Reset City dropdown
            TownshipSelect.length = 1; // Reset Township dropdown

            const cities = subjectObject[this.value];
            if (cities) {
                console.log(cities); // Log the cities object to verify it's correct
                for (const city in cities) {
                    CitySelect.options[CitySelect.options.length] = new Option(city, city);
                }
            }
        };

        CitySelect.onchange = function () {
            console.log("City: " + this.value);
            TownshipSelect.length = 1; // Reset Township dropdown

            const townships = subjectObject[DivisionSelect.value]?.[this.value];
            if (townships) {
                console.log(townships); // Log the townships array to verify it's correct
                for (let i = 0; i < townships.length; i++) {
                    TownshipSelect.options[TownshipSelect.options.length] = new Option(townships[i], townships[i]);
                }
            }
        };


    };


</script>
<div class="bg-white">
    <div class="lg:min-h-screen">
        <div class="flex items-center justify-center px-5 py-5">
            <div class="w-full mx-auto">
                <div class="relative mt-1 block text-center">
                    <a href="Home.jsp">
                        <h1 class="font-extrabold text-5xl text-amber-500">
                            edms<span class="text-red-500">.</span>
                        </h1>
                    </a>
                </div>

                <h1 class="text-3xl my-5 font-bold text-center">Post</h1>

                <!-- Form -->
                <form class="my-5 max-w-[400px] mx-auto" action="AddPost" method="post"
                      enctype="multipart/form-data">

                    <div class="form-control">
                        <label class="label">
                            <span class="label-text text-xl">Write your post here</span>
                        </label>
                        <textarea name="PostString" required class="textarea textarea-bordered h-24"
                                  placeholder=""></textarea>
                    </div>

                    <label class="label">
                        <span class="label-text text-xl">Add 2 photos of your post</span>
                    </label>
                    <div class="flex flex-col my-2 gap-1">
                        <input required type="file" id="myFile" name="ImageName1">
                        <input required type="file" id="myFile" name="ImageName2">
                    </div>
                    <!-- Add your relief / shelter location: -->
                    <!-- select Division -->
                    <label class="label">
                        <span class="label-text">Add your post related location :</span>
                    </label>


                    <select id="DivisionSelect"
                            class="select select-bordered w-full mb-2"
                            name="Divisionitem"
                            required>
                        <option disabled selected>Add Division</option>

                    </select>

                    <!-- select Division js -->
                    <script>
                        document.getElementById("DivisionSelect").addEventListener("change", function () {
                            var selectElement = document.getElementById("DivisionSelect");
                            var selectOption = selectElement.options[selectElement.selectedIndex];

                            var selectedText = selectOption.text;

                            // Use AJAX to send selectedText to server
                            fetch("AddPost.jsp?jsValue=" + encodeURIComponent(selectedText))
                                .then(response => response.text())
                                .then(data => {
                                    console.log(data); // Log the response from the server
                                })
                                .catch(error => {
                                    console.error("Error:", error);
                                });
                        });
                    </script>

                    <%
                        String selectedDivision = request.getParameter("jsValue");%>
                    <input type="hidden" name="selectedDivision" value="<%= selectedDivision %>">

                    <!-- select upazila -->

                    <select id="CitySelect"
                            class="select select-bordered w-full mb-2"
                            name="Cityitem"
                            required
                    >
                        <option disabled selected>Add City</option>

                    </select>

                    <!-- select City js -->
                    <script>
                        document.getElementById("CitySelect").addEventListener("change", function () {
                            var selectElement = document.getElementById("CitySelect");
                            var selectOption = selectElement.options[selectElement.selectedIndex];

                            var selectedText = selectOption.text;

                            // Use AJAX to send selectedText to server
                            fetch("AddPost.jsp?UpValue=" + encodeURIComponent(selectedText))
                                .then(response => response.text())
                                .then(data => {

                                    console.log(data); // Log the response from the server
                                })
                                .catch(error => {
                                    console.error("Error:", error);
                                });
                        });
                    </script>

                    <%

                        String selectedCity = request.getParameter("UpValue");%>

                    <!-- select Township -->

                    <select id="TownshipSelect"
                            class="select select-bordered w-full mb-2"
                            name="Townshipitem"
                            required
                    >
                        <option disabled selected>Add Township</option>

                    </select>

                    <!-- select Township js -->
                    <script>
                        document.getElementById("TownshipSelect").addEventListener("change", function () {
                            var selectElement = document.getElementById("TownshipSelect");
                            var selectOption = selectElement.options[selectElement.selectedIndex];

                            var selectedText = selectOption.text;

                            // Use AJAX to send selectedText to server
                            fetch("AddPost.jsp?TownshipValue=" + encodeURIComponent(selectedText))
                                .then(response => response.text())
                                .then(data => {


                                    console.log(data); // Log the response from the server
                                })
                                .catch(error => {
                                    console.error("Error:", error);
                                });
                        });

                    </script>

                    <%

                        String selectedTownship = request.getParameter("TownshipValue");%>

                    <input type="hidden" id="selectedTownshipHiddenBox" name="selectedTownship"
                           value=<%=selectedTownship %>/>

                    <script>
                        const TownshipSelectDropDown = document.getElementById('TownshipSelect')
                        TownshipSelectDropDown.addEventListener('change', function () {
                            document.getElementById('selectedTownshipHiddenBox').value = TownshipSelectDropDown.options[TownshipSelectDropDown.selectedIndex].text
                        })
                    </script>


                    <!-- submit button -->
                    <input class="btn btn-warning my-5 w-full" type="submit" value="Post">
                    <p style="color:red;">${message}</p>
                </form>

            </div>
        </div>
    </div>
</div>
</body>

</html>
