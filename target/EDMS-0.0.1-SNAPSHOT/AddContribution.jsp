<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*" %>

<%

    Connection con = null;

    try
    {
        Class.forName("org.mariadb.jdbc.Driver");
    }
    catch(ClassNotFoundException e)
    {
        e.printStackTrace();
    }
    try
    {
        con=DriverManager.getConnection("jdbc:mariadb://localhost:3306/edms" , "root","");
    }
    catch(SQLException e)
    {
        e.printStackTrace();
    }

%>

<!DOCTYPE html>

<head>
    <title>Emergency Disaster Management System</title>
    <link rel="stylesheet" href="CSS/Profile.css" />
    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- DaisyUI CDN -->
    <link href="https://cdn.jsdelivr.net/npm/daisyui@3.7.3/dist/full.css" rel="stylesheet" type="text/css" />
    <!-- Animate.css CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
    <!-- AOS CDN -->
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
    <!-- Font Awesome -->
    <script src="https://kit.fontawesome.com/f13afb77f1.js" crossorigin="anonymous"></script>

    <style>
        /* Flower Border Pattern with Custom Color */
        .flower-border {
            position: relative;
            padding: 2rem;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border: 4px solid transparent; /* Making space for the border */
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
        .custom-select {
            appearance: none;
            background-image:
                    url('http://localhost:8086/EDMS_war_exploded/IMAGES/kbz_logo.png'),
                    url('http://localhost:8086/EDMS_war_exploded/IMAGES/cb_logo.jpeg'),
                    url('http://localhost:8086/EDMS_war_exploded/IMAGES/mab_logo.jpeg'),
                    url('http://localhost:8086/EDMS_war_exploded/IMAGES/aya_logo.jpeg'),
                    url('http://localhost:8086/EDMS_war_exploded/IMAGES/yoma_logo.jpeg');

            background-repeat: no-repeat;
            background-position: 8% center, 18% center, 28% center, 38% center, 48% center; /* Adjusted spacing */
            background-size: 35px 35px, 35px 35px, 35px 35px, 35px 35px, 35px 35px; /* Reduced size */
            padding-left: 3em; /* Adjusted padding for better spacing */
            border: 2px solid #fca311;
            border-radius: 8px;
            height: 45px;
            width: 100%;
            font-size: 16px;
            background-color: #fefae0;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease-in-out;

        }

        /* Add focus/valid state for the custom select */
        .custom-select:focus {
            outline: none; /* Removes the default blue outline */
            border-color: #e85d04; /* Custom border color */
            box-shadow: 0 0 10px rgba(255, 165, 0, 0.7); /* Your desired focus effect */
        }

        .custom-select:valid {
            background-image: none;
            border-color: #e85d04;
            box-shadow: 0 0 10px rgba(255, 165, 0, 0.7);
        }


    </style>
</head>

<body class="bg-white">
<div class="border-b-[1px] bg-amber-500 ">
    <div class="my-container">

        <!-- For Large Devices -->
        <div class="hidden lg:flex items-center justify-between">
            <!-- Back Arrow -->
            <div class="flex items-center ">
                <button onclick="window.location.href='Shelter_and_Areas.jsp'" class="text-white hover:text-red-500 transition duration-300">
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
                <button onclick="window.location.href='Shelter_and_Areas.jsp'" class="text-white hover:text-red-500 transition duration-300">
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
                <a href="Profile_user.jsp" class="hover:text-[#F17829] transition duration-300">
                    <i class="fa-regular fa-circle-user text-[40px]"></i>
                </a>
            </div>
        </div>
    </div>
</div>

<div class="pt-[20px]">
    <!-- Your page content here -->
</div>

<div class="min-h-screen flex items-center justify-center">
    <div class="form-container flower-border">
        <div class="text-center mb-6">

            <h1 class="text-5xl font-extrabold text-amber-500 animate__animated animate__bounce">
                <span class="text-red-500"></span>
            </h1>

            <h6 class="text-lg font-bold text-gray-800 mt-4">
                Your contribution can make a real difference for people affected by natural disasters. Together, we can help rebuild lives and bring hope to affected communities.
            </h6>

        </div>



        <!-- Form Section -->
        <form class="space-y-6" action="AddContribution" method="post" enctype="multipart/form-data">

            <!-- First Name -->
            <label class="label">
                <span class="label-text">Location UserName</span>
            </label>
            <input
                    id="LocationusernameInput"
                    name="LocationUsername"
                    type="text"
                    class="input-floral w-full"
                    placeholder="Choose a Your First Name (only letters allowed)"
                    required
                    oninput="validateLocationUsername()"
            />
            <span id="usernameError" class="text-red-500 text-sm"></span>


            <script>
                function validateLocationUsername() {
                    const usernameInput = document.getElementById('usernameInput');
                    const usernameError = document.getElementById('usernameError');

                    // Regular expression to allow only alphabetic characters
                    const usernameRegex = /^[a-zA-Z]+$/;

                    if (!usernameRegex.test(usernameInput.value)) {
                        // Show error if the username contains invalid characters
                        usernameError.textContent = 'First Name must contain only letters (A-Z or a-z).';
                        usernameInput.classList.add('border-red-500');
                        usernameInput.classList.remove('border-green-500');
                    } else {
                        // Clear error if the username is valid
                        usernameError.textContent = '';
                        usernameInput.classList.remove('border-red-500');
                        usernameInput.classList.add('border-green-500');
                    }
                }
            </script>




            <!-- Email -->
            <label class="label">
                <span class="label-text">Email</span>
            </label>
            <input
                    id="emailInput"
                    name="Email"
                    type="text"
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


            <label class="label">
                <span class="label-text">Shelter Name(You want to offer)</span>
            </label>
            <input
                    id="usernameInput"
                    name="ShelterName"
                    type="text"
                    class="input-floral w-full"
                    placeholder="Choose a Shelter Name (only letters allowed)"
                    required
                    oninput="validateUsername()"
            />
            <span id="usernameError" class="text-red-500 text-sm"></span>


            <script>
                function validateUsername() {
                    const usernameInput = document.getElementById('usernameInput');
                    const usernameError = document.getElementById('usernameError');

                    // Regular expression to allow only alphabetic characters
                    const usernameRegex = /^[a-zA-Z]+$/;

                    if (!usernameRegex.test(usernameInput.value)) {
                        // Show error if the username contains invalid characters
                        usernameError.textContent = 'Shelter Name must contain only letters (A-Z or a-z).';
                        usernameInput.classList.add('border-red-500');
                        usernameInput.classList.remove('border-green-500');
                    } else {
                        // Clear error if the username is valid
                        usernameError.textContent = '';
                        usernameInput.classList.remove('border-red-500');
                        usernameInput.classList.add('border-green-500');
                    }
                }
            </script>


            <!-- Budget -->
            <label class="label">
                <span class="label-text">Amount(You want to Offer)</span>
            </label>
            <input
                    id="budgetInput"
                    name="Amount"
                    type="number"
                    class="input-floral w-full"
                    placeholder="Enter Amount You want to Offer(only numbers allowed)"
                    required
                    oninput="validateFunding()"
            />
            <span id="budgetError" class="text-red-500 text-sm"></span>

            <script>
                function validateFunding() {
                    const budgetInput = document.getElementById('budgetInput');
                    const budgetError = document.getElementById('budgetError');

                    // Regular expression to allow only numbers (positive integers or decimal numbers)
                    const budgetRegex = /^[0-9]+(\.[0-9]+)?$/;

                    if (!budgetRegex.test(budgetInput.value)) {
                        // Show error if the input contains non-numeric characters
                        budgetError.textContent = 'Funding amount must be a number (e.g., 100).';
                        budgetInput.classList.add('border-red-500');
                        budgetInput.classList.remove('border-green-500');
                    } else {
                        // Clear error if the input is valid
                        budgetError.textContent = '';
                        budgetInput.classList.remove('border-red-500');
                        budgetInput.classList.add('border-green-500');
                    }
                }
            </script>





            <label class="label">
                <span class="label-text">Payment Method</span>
            </label>
            <select
                    class="custom-select"
                    id="PaymentMethod"
                    name="PaymentMethod"
                    type="text"
                    required>
                <option disabled selected value=""></option>
                <option value="mpu">MPU card</option>
                <option value="visa">Visa Card</option>
            </select>


            <label class="label">
                <span class="label-text">Card Info</span>
            </label>
            <input
                    id="cardInput"
                    name="CardInfo"
                    type="text"
                    class="input-floral w-full"
                    placeholder="Enter Card Number (only numbers allowed eg;0923454321)"
                    required
                    oninput="validateCard()"
            />
            <span id="cardError" class="text-red-500 text-sm"></span>

            <script>
                function validateCard() {
                    const cardInput = document.getElementById('cardInput');
                    const cardError = document.getElementById('cardError');

                    // Regular expression to allow only numbers (exactly 10 digits)
                    const cardRegex = /^[0-9]+$/;

                    if (!cardRegex.test(cardInput.value)) {
                        // Show error if the input does not match 10 digits
                        cardError.textContent = 'Card number must be  digits.';
                        cardInput.classList.add('border-red-500');
                        cardInput.classList.remove('border-green-500');
                    } else {
                        // Clear error if the mobile number is valid
                        cardError.textContent = '';
                        cardInput.classList.remove('border-red-500');
                        cardInput.classList.add('border-green-500');
                    }
                }
            </script>

            <label class="label">
                <span class="label-text">Note</span>
            </label>
            <textarea
                    class="textarea textarea-bordered h-24 input-floral w-full" required
                    placeholder="note" name="Note"
            ></textarea>

            <!-- Submit Button -->
            <button type="submit" class="btn-floral">Submit</button>
        </form>
    </div>
</div>
<div class="pt-[20px]">
    <!-- Your page content here -->
</div>
<div class='flex flex-col items-center justify-center gap-3 border-[1px] p-8 w-full'>
    <a href='Home.jsp'>
        <h1 class="font-extrabold text-5xl text-amber-600">edms<span class="text-red-500">.</span></h1>
    </a>
    <h3 class='text-[16px] text-[#7B7B7B] text-center'>EDMS - Your comprehensive resource for shelter,
        assistance, and information during times of crisis</h3>
    <h3 class='text-[16px] text-[#868686] text-center'>&copy; 2024 EDMS. All rights reserved.</h3>
</div>
</body>
</html>
