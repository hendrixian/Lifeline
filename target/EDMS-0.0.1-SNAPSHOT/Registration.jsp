<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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


<!DOCTYPE html>
<html>
<head>
    <title>Emergency Disaster Management System</title>
    <link rel="stylesheet" href="CSS/Profile.css"/>
    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- DaisyUI CDN -->
    <link
            href="https://cdn.jsdelivr.net/npm/daisyui@3.7.3/dist/full.css"
            rel="stylesheet"
            type="text/css"
    />
    <!-- Animate.css CDN -->
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
    />
    <!-- AOS CDN -->
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css"/>
    <!-- Font Awesome -->
    <script
            src="https://kit.fontawesome.com/f13afb77f1.js"
            crossorigin="anonymous"
    ></script>
    <script src="LocationData.js" defer></script>

    <style>
        .border-red-500 {
            border: 2px solid red;
        }

        .border-green-500 {
            border: 2px solid green;
        }

        .text-red-500 {
            color: red;
        }
    </style>
    <style>
        /* Flower Border Pattern with Custom Color */
        .flower-border {
            position: relative;
            padding: 2rem;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border: 8px solid transparent; /* Making space for the border */
            border-image: url('https://www.svgrepo.com/show/281107/flower-pattern-border.svg') 30 stretch; /* Custom flower pattern SVG */
            background-color: #fff; /* Ensures the background is white behind the border */
            border-color: #FB923C; /* Custom border color (can be any color you prefer) */
        }

        /* Fancy border for inputs */
        .input-floral {
            border: 2px solid #fca311;
            border-radius: 8px;
            padding: 10px;
            background-color: #fefae0;
            font-size: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease-in-out;
        }

        .input-floral:focus {
            outline: none;
            border-color: #e85d04;
            box-shadow: 0 0 10px rgba(255, 165, 0, 0.7);
        }

        /* Custom button styling */
        .btn-floral {
            background-color: #fca311;
            color: white;
            border-radius: 8px;
            padding: 12px;
            font-size: 18px;
            border: none;
            width: 100%;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease-in-out;
        }

        .btn-floral:hover {
            background-color: #e85d04;
            box-shadow: 0 0 10px rgba(255, 165, 0, 0.7);
        }

        /* Make the form container stretch full width */
        .form-container {
            width: 100%; /* Take up full width of the screen */
            max-width: 100%; /* Disable any maximum width constraint */
            margin: 0 auto;
            padding: 40px;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        /* Additional styling for responsiveness */
        @media (min-width: 768px) {
            .form-container {
                width: 40%; /* Optionally restrict the width on larger screens */
                max-width: 1200px; /* Maximum width on large screens */
            }
        }
    </style>

</head>


<!-- JavaScript Code -->

<script>


    window.onload = function () {
        var DistrictSelect = document.getElementById("DistrictSelectS");
        var UpazillaSelect = document.getElementById("UpazillaSelectS");
        var UnionSelect = document.getElementById("UnionSelectS");
        for (var x in subjectObject) {
            DistrictSelect.options[DistrictSelect.options.length] = new Option(x, x);
        }

        DistrictSelect.onchange = function () {
            UpazillaSelect.length = 1;
            UnionSelect.length = 1;

            for (var y in subjectObject[this.value]) {
                UpazillaSelect.options[UpazillaSelect.options.length] = new Option(y, y);
            }
        }

        UpazillaSelect.onchange = function () {
            UnionSelect.length = 1;

            var z = subjectObject[DistrictSelect.value][this.value];
            for (var i = 0; i < z.length; i++) {
                UnionSelect.options[UnionSelect.options.length] = new Option(z[i], z[i]);
            }

        }

    }
</script>
<body>
<!-- Start of Navbar -->
<div class="border-b-[1px] bg-amber-500 ">
    <div class="my-container">

        <!-- For Large Devices -->
        <div class="hidden lg:flex items-center justify-between">
            <!-- Back Arrow -->
            <div class="flex items-center ">
                <button onclick="window.location.href='Login.jsp'"
                        class="text-white hover:text-red-500 transition duration-300">
                    <i class="fa-solid fa-arrow-left text-3xl"></i>
                </button>
            </div>

            <!-- Logo Centered -->
            <div class="flex-grow text-center">
                <h1 class="font-extrabold text-5xl text-white py-4 px-5 border-b-amber-500 hover:border-b-white border-b-[2px]
                ">edms<span class="text-red-500">.</span></h1>
            </div>

            <!-- User Icon -->
            <div class="flex justify-end items-center text-[18px]">
                <div class="tooltip tooltip-left" data-tip="Profile">
                    <a href="Profile_user.jsp" class="hover:text-white transition duration-300">
                        <i class="fa-regular fa-circle-user"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- For Medium and Small Devices -->
        <div class="navbar bg-base-100 lg:hidden bg-amber-500 min-h-[100px]">
            <div class="navbar-start flex items-center">
                <!-- Back Arrow -->
                <button onclick="window.location.href='Login.jsp'"
                        class="text-white hover:text-red-500 transition duration-300">
                    <i class="fa-solid fa-arrow-left text-[40px]"></i>
                </button>
            </div>

            <!-- Logo Centered -->
            <div class="navbar-center flex justify-center">
                <a href='Home.jsp'>
                    <h1 class="font-extrabold text-[50px] text-white">edms<span class="text-red-500">.</span></h1>
                </a>
            </div>

            <!-- User Icon -->
            <div class="navbar-end">
                <a href="Profile.jsp" class="hover:text-[#F17829] transition duration-300">
                    <i class="fa-regular fa-circle-user text-[40px]"></i>
                </a>
            </div>
        </div>
    </div>
</div>


<div class="pt-[20px]">
    <!-- Your page content here -->
</div>


<!-- Form -->
<form class="my-3 max-w-[800px] mx-auto p-6 bg-white border-2 border-orange-300 rounded-lg shadow-lg"
      action="Registration" method="post" enctype="multipart/form-data"
>

    <label class="label">
        <span class="label-text">Username</span>
    </label>
    <input
            id="usernameInput"
            name="username"
            type="text"
            class="input-floral w-full"
            placeholder="Choose a username (only letters allowed)"
            required
            oninput="validateUsername()"
    />
    <span id="usernameError" class="text-red-500 text-sm" style="display: none;">
        Username already taken
    </span>

    <script>
        function validateUsername() {
            const usernameInput = document.getElementById('usernameInput');
            const usernameError = document.getElementById('usernameError');

            // Regular expression to allow only alphabetic characters
            const usernameRegex = /^[a-zA-Z]+$/;

            // Clear previous error and border states
            usernameError.textContent = '';
            usernameInput.classList.remove('border-red-500', 'border-green-500');

            // Validate the format of the username (only alphabetic characters)
            if (!usernameRegex.test(usernameInput.value)) {
                usernameError.textContent = 'Username must contain only letters (A-Z or a-z).';
                usernameInput.classList.add('border-red-500');
                return;
            }

            // If the format is valid, check if the username already exists in the database
            const username = usernameInput.value.trim();

            // Create an XMLHttpRequest to check availability
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'Registration', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        console.log("Server response: " + xhr.responseText);
                        if (xhr.responseText === 'exists') {
                            // Show error if username is taken
                            usernameError.textContent = 'Username is already taken.';
                            usernameInput.classList.add('border-red-500');
                        } else if (xhr.responseText === 'available') {
                            // Clear error if username is available
                            usernameError.textContent = '';
                            usernameInput.classList.add('border-green-500');
                        }
                    } else {
                        // Handle server errors
                        usernameError.textContent = 'An error occurred. Please try again later.';
                        usernameInput.classList.add('border-red-500');
                    }
                }
            };

            // Send the username as POST data
            xhr.send('username=' + encodeURIComponent(username));
        }

    </script>

    <label class="label">
        <span class="label-text">Email</span>
    </label>
    <input
            id="emailInput"
            name="Email"
            type="email"
            class="input-floral w-full"
            placeholder="Enter your email (e.g., example@gmail.com)"
            required
            oninput="validateEmail()"
    />
    <span id="emailError" class="text-red-500 text-sm"></span>


    <script>
        function validateEmail() {
            const emailInput = document.getElementById('emailInput');
            const emailError = document.getElementById('emailError');

            // Check if the email ends with "@gmail.com"
            const gmailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;

            if (!gmailRegex.test(emailInput.value)) {
                // Show error if the email does not match the required format
                emailError.textContent = 'Email must be in the format "example@gmail.com".';
                emailInput.classList.add('border-red-500');
                emailInput.classList.remove('border-green-500');
            } else {
                // Clear error if the email is valid
                emailError.textContent = '';
                emailInput.classList.remove('border-red-500');
                emailInput.classList.add('border-green-500');
            }
        }
    </script>

    <!-- Password -->
    <div class="grid grid-cols-2 gap-4">
        <!-- Password -->
        <div>
            <label class="label">
                <span class="label-text">Password</span>
            </label>
            <input
                    id="password1"
                    name="password1"
                    type="password"
                    class="input-floral w-full"
                    placeholder="Enter password"
                    required
                    oninput="validatePassword()"
            />
            <span id="passwordError" class="text-red-500 text-sm"></span>
        </div>
        <!-- Re-enter Password -->
        <div>
            <label class="label">
                <span class="label-text">Re-enter Password</span>
            </label>
            <input
                    id="password2"
                    name="password2"
                    type="password"
                    class="input-floral w-full"
                    placeholder="Confirm password"
                    required
                    oninput="validatePasswordMatch()"
            />
            <span id="confirmPasswordError" class="text-red-500 text-sm"></span>
        </div>
    </div>


    <script>
        function validatePassword() {
            const password1 = document.getElementById('password1');
            const passwordError = document.getElementById('passwordError');

            // Strong password regex
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

            if (!passwordRegex.test(password1.value)) {
                // Show error if password does not meet criteria
                passwordError.textContent = 'Password must be at least 8 characters long, include uppercase, lowercase, numbers, and special characters.';
                password1.classList.add('border-red-500');
                password1.classList.remove('border-green-500');
            } else {
                // Clear error if password is valid
                passwordError.textContent = '';
                password1.classList.remove('border-red-500');
                password1.classList.add('border-green-500');
            }
        }

        function validatePasswordMatch() {
            const password1 = document.getElementById('password1');
            const password2 = document.getElementById('password2');
            const confirmPasswordError = document.getElementById('confirmPasswordError');

            if (password1.value !== password2.value) {
                // Show error if passwords do not match
                confirmPasswordError.textContent = 'Passwords do not match.';
                password2.classList.add('border-red-500');
                password2.classList.remove('border-green-500');
            } else {
                // Clear error if passwords match
                confirmPasswordError.textContent = '';
                password2.classList.remove('border-red-500');
                password2.classList.add('border-green-500');
            }
        }
    </script>

    <!-- select type -->
    <label class="label">
        <span class="label-text">Select User Type</span>
    </label>
    <select class="select select-bordered input-floral w-full" name="UserType" required>
        <option disabled selected>Pick one</option>
        <option>Individual</option>
        <option>Volunteer Group</option>
    </select>

    <!-- select district -->
    <div class="grid grid-cols-3 gap-4">
        <div>
            <label class="label">
                <span class="label-text">Select Division</span>
            </label>
            <select id="DistrictSelectS" class="select select-bordered input-floral w-full" name="Division" required>
                <option disabled selected>Add Divisions</option>
            </select>
        </div>
        <!-- Select District js -->

        <script>
            document.getElementById("DistrictSelectS").addEventListener("change", function () {
                var selectElement = document.getElementById("DistrictSelectS");
                var selectOption = selectElement.options[selectElement.selectedIndex];

                var selectedText = selectOption.text;

                // Use AJAX to send selectedText to server
                fetch("Registration.jsp?jsValue=" + encodeURIComponent(selectedText))
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
            String selectedDistrict = request.getParameter("jsValue");%>
        <input type="hidden" name="selectedDistrict" value="<%= selectedDistrict %>">

        <!-- select upazila -->
        <div>
            <label class="label">
                <span class="label-text">Select City</span>
            </label>
            <select id="UpazillaSelectS" class="select select-bordered input-floral w-full" name="City" required>
                <option disabled selected>Add Cities</option>
            </select>
        </div>

        <!-- Select Upazilla js -->

        <script>
            document.getElementById("UpazillaSelectS").addEventListener("change", function () {
                var selectElement = document.getElementById("UpazillaSelectS");
                var selectOption = selectElement.options[selectElement.selectedIndex];

                var selectedText = selectOption.text;

                // Use AJAX to send selectedText to server
                fetch("Registration.jsp?UpValue=" + encodeURIComponent(selectedText))
                    .then(response => response.text())
                    .then(data => {


                        console.log(data); // Log the response from the server
                    })
                    .catch(error => {
                        console.error("Error:", error);
                    });
            });
        </script>

        <%String selectedUpazilla = request.getParameter("UpValue");%>
        <input type="hidden" name="selectedUpazilla" value="<%= selectedUpazilla %>">


        <!-- select union -->
        <div>
            <label class="label">
                <span class="label-text">Select Township</span>
            </label>
            <select id="UnionSelectS" class="select select-bordered input-floral w-full" name="Township" required>
                <option disabled selected>Add Townships</option>
            </select>
        </div>

        <script>
            const unionSelectDropDown = document.getElementById('UnionSelectS')
            unionSelectDropDown.addEventListener('change', function () {
                document.getElementById('selectedUnionHiddenBox').value = unionSelectDropDown.options[unionSelectDropDown.selectedIndex].text
            })
        </script>

        <!-- select Union js -->
        <script>
            document.getElementById("UnionSelectS").addEventListener("change", function () {
                var selectElement = document.getElementById("UnionSelectS");
                var selectOption = selectElement.options[selectElement.selectedIndex];

                var selectedText = selectOption.text;

                // Use AJAX to send selectedText to server
                fetch("Registration.jsp?UnionValue=" + encodeURIComponent(selectedText))
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

            String selectedUnion = request.getParameter("UnionValue");

						/* String aise="null";

						if(aise=="null"&& selectedUnion!=null){

					 PreparedStatement ps=con.prepareStatement("insert into setloc(Location)values(?)");
					 ps.setString(1,selectedUnion);
					 ps.executeUpdate();

						} */
        %>

        <input type="hidden" name="selectedUnion" id="selectedUnionHiddenBox" value="selectedUnion">
    </div>
    <!-- contact no -->
    <label class="label">
        <span class="label-text">Mobile No</span>
    </label>
    <input
            id="mobileInput"
            name="ContactNo"
            type="text"
            class="input-floral w-full"
            placeholder="Enter Mobile Number (only numbers allowed eg;0923454321)"
            required
            oninput="validateMobile()"
    />
    <span id="mobileError" class="text-red-500 text-sm"></span>

    <script>
        function validateMobile() {
            const mobileInput = document.getElementById('mobileInput');
            const mobileError = document.getElementById('mobileError');

            // Regular expression to allow only numbers (exactly 10 digits)
            const mobileRegex = /^[0-9]+$/;

            if (!mobileRegex.test(mobileInput.value)) {
                // Show error if the input does not match 10 digits
                mobileError.textContent = 'Mobile number must be  digits.';
                mobileInput.classList.add('border-red-500');
                mobileInput.classList.remove('border-green-500');
            } else {
                // Clear error if the mobile number is valid
                mobileError.textContent = '';
                mobileInput.classList.remove('border-red-500');
                mobileInput.classList.add('border-green-500');
            }
        }
    </script>
    <!-- Image upload -->

    <label class="block text-gray-700 font-bold mb-2"></label>
    <input
            class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-100 file:text-orange-400 hover:file:bg-blue-200 mb-4"
            type="file"
            id="myFile"
            name="Image"
            required/>
    <!-- about yourself -->
    <label class="label">
        <span class="label-text">Write Something about yourself or your volunteer group</span>
    </label>
    <textarea
            class="textarea textarea-bordered h-24 input-floral w-full" required
            placeholder="Bio" name="Description"
    ></textarea>

    <!-- Submit Button -->
    <div class="form-control">
        <input class="btn btn-warning w-full py-3 text-black  font-bold text-xl rounded-full shadow-lg transition transform hover:scale-105"
               type="submit" value="Submit">
    </div>

</form>
</div>
</div>
</div>
</div>


<div class='flex flex-col items-center justify-center gap-3 border-[1px] p-8 w-full'>

    <h1 class="font-extrabold text-5xl text-amber-600">edms<span class="text-red-500">.</span></h1>

    <h3 class='text-[16px] text-[#7B7B7B] text-center'>EDMS - Your comprehensive resource for shelter,
        assistance, and information during times of crisis</h3>
    <h3 class='text-[16px] text-[#868686] text-center'>&copy; 2024 EDMS. All rights reserved.</h3>
</div>


</body>

</html>

