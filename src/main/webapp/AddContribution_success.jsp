<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="ISO-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submission Success</title>
    <link rel="stylesheet" href="CSS/Profile.css" />
    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- DaisyUI CDN -->
    <link href="https://cdn.jsdelivr.net/npm/daisyui@3.7.3/dist/full.css" rel="stylesheet" type="text/css" />
    <script src="https://kit.fontawesome.com/f13afb77f1.js" crossorigin="anonymous"></script>
    <style>
        /* Custom styles for border animation */
        @keyframes borderAnimation {
            0% {
                border-color: transparent;
                border-width: 0;
            }
            50% {
                border-color: #FB923C; /* Tailwind orange color */
                border-width: 6px;
            }
            100% {
                border-color: #FB923C;
                border-width: 2px;
            }
        }

        @keyframes fadeInScale {
            0% {
                opacity: 0;
                transform: scale(0.8);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        .success-container {
            max-width: 500px;
            background-color: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            animation: borderAnimation 2s ease-in-out forwards; /* Border animation */
            padding: 2rem;
        }

        .success-message {
            color: #FB923C; /* Tailwind orange-400 */
            animation: fadeInScale 1s ease-out forwards; /* Animation for text */
            animation-delay: 0.5s; /* Delay the animation to make it more fluid */
        }

        .btn-primary {
            background-color: #FB923C; /* Tailwind orange-400 */
            color: #fff;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: bold;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #2bb473; /* Darker green */
            transform: scale(1.05); /* Slightly enlarge the button on hover */
        }

        .icon {
            font-size: 40px;
            color: #FB923C;
            animation: bounceIn 1s; /* Animation effect for icon */
        }

        @keyframes bounceIn {
            0% {
                transform: scale(0);
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
            }
        }

    </style>
</head>

<body class="bg-gray-100 flex items-center justify-center h-screen">
<div class="success-container p-8">
    <!-- Success Icon -->
    <div class="text-center mb-6">
        <i class="fa fa-check-circle icon animate__animated animate__bounceIn"></i>
    </div>

    <!-- Success Message -->
    <div class="text-center">
        <h1 class="text-3xl font-extrabold success-message mb-4">Submission Successful!</h1>
        <p class="text-lg text-gray-700 mb-6">
            Your contribution has been recorded successfully. Thank you for your support in making a positive impact!
        </p>

        <!-- Redirect Button -->
        <a href="Home.jsp" class="btn-primary w-full">
            Go to Home
        </a>
    </div>
</div>
</body>

</html>
