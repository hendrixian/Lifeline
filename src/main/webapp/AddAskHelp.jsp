<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*" %>


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
    </style>
</head>

<body class="bg-white">
<div class="border-b-[1px] bg-amber-500 ">
    <div class="my-container">

        <!-- For Large Devices -->
        <div class="hidden lg:flex items-center justify-between">
            <!-- Back Arrow -->
            <div class="flex items-center ">
                <button onclick="window.location.href='Location_Profile.jsp'" class="text-white hover:text-red-500 transition duration-300">
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
                    <a href="Profile.jsp" class="hover:text-white transition duration-300">
                        <i class="fa-regular fa-circle-user"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- For Medium and Small Devices -->
        <div class="navbar bg-base-100 lg:hidden bg-amber-500 min-h-[100px]">
            <div class="navbar-start flex items-center">
                <!-- Back Arrow -->
                <button onclick="window.location.href='Location_Profile.jsp'" class="text-white hover:text-red-500 transition duration-300">
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
<%

    String LocationUsername = request.getParameter("LocationUsernameFromLocationProfile");
%>
<div class="min-h-screen flex items-center justify-center">
    <div class="form-container flower-border">
        <div class="text-center mb-6">

            <h1 class="text-5xl font-extrabold text-amber-500 animate__animated animate__bounce">
                edms<span class="text-red-500">.</span>
            </h1>

            <h6 class="text-lg font-bold text-gray-800 mt-4">
                Don't Hesitate to Ask for Help
            </h6>

        </div>

        <!-- Form Section -->
        <form class="space-y-4" action="AddAskHelp" method="post" enctype="multipart/form-data">
            <label class="label">Write Description</label>
            <textarea
                    class="textarea textarea-bordered h-24 input-floral w-full"
                    placeholder="Bio"
                    name="Description"
                    required></textarea>

            <!-- First Image Upload -->
            <div class="form-control">
                <label for="ImageName1" class="label">
                    <span class="label-text text-gray-800 font-medium">Photo for visual confirmation (Photo 1)</span>
                </label>
                <input
                        class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-gradient-to-r file:from-yellow-300 file:to-white hover:file:bg-gradient-to-r hover:file:from-yellow-200 hover:file:to-white mb-4"
                        type="file"
                        id="ImageName1"
                        name="ImageName1"
                        required />
            </div>

            <!-- Second Image Upload -->
            <div class="form-control">
                <label for="ImageName2" class="label">
                    <span class="label-text text-gray-800 font-medium">Photo for visual confirmation (Photo 2)</span>
                </label>
                <input
                        class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-gradient-to-r file:from-yellow-300 file:to-white hover:file:bg-gradient-to-r hover:file:from-yellow-200 hover:file:to-white mb-4"
                        type="file"
                        id="ImageName2"
                        name="ImageName2"
                        required />
            </div>

            <!-- Other Inputs -->
            <div class="form-control">
                <label for="help-am" class="label">
                    <span class="label-text text-gray-800 font-medium">Affected Male</span>
                </label>
                <input type="number" class="input-floral w-full" name="help-am" id="help-am" required />
            </div>

            <div class="form-control">
                <label for="help-af" class="label">
                    <span class="label-text text-gray-800 font-medium">Affected Female</span>
                </label>
                <input type="number" class="input-floral w-full" name="help-af" id="help-af" required />
            </div>

            <div class="form-control">
                <label for="help-ac" class="label">
                    <span class="label-text text-gray-800 font-medium">Affected Children</span>
                </label>
                <input type="number" class="input-floral w-full" name="help-ac" id="help-ac" required />
            </div>

            <!-- Hidden Input -->
            <input type="hidden" name="LocationUsername" value="<%=LocationUsername %>">

            <!-- Submit Button -->
            <input class="btn btn-warning my-5 w-full" type="submit" value="Post">
            <p style="color:red;">${message}</p>
        </form>


    </div>
</div>
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
