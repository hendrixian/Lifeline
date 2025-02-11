<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - Emergency Disaster Management System</title>
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
    <script>
        function toggleForm() {
            document.getElementById('emailForm').classList.toggle('hidden');
            document.getElementById('phoneForm').classList.toggle('hidden');
        }
    </script>
</head>

<body>
<div class="bg-white">
    <div class="lg:min-h-screen">
        <div class="flex items-center justify-center px-5 py-5">
            <div class="w-full mx-auto">
                <div class="relative mt-1 block text-center">
                    <a href="Login.jsp">
                        <h1 class="font-extrabold text-5xl text-amber-500">
                            edms<span class="text-red-500">.</span>
                        </h1>
                    </a>
                </div>

                <!-- Email Form -->
                <form id="emailForm" class="my-5 max-w-[400px] mx-auto" action="Forgot" method="post" enctype="multipart/form-data">
                    <label class="label">
                        <span class="label-text">Enter your email to receive a password reset link.</span>
                    </label>
                    <input name="email" type="email" class="input input-bordered w-full" placeholder="Email" required />
                    <input class="btn btn-warning my-5 w-full" type="submit" value="Submit">
                    <h3 class="max-w-[400px] mx-auto">
                        <a class="text-amber-500 hover:underline cursor-pointer" onclick="toggleForm()">Try with Phone Number?</a>
                    </h3>
                </form>

                <!-- Phone Form -->
                <form id="phoneForm" class="my-5 max-w-[400px] mx-auto hidden" action="Forgot" method="post" enctype="multipart/form-data">
                    <label class="label">
                        <span class="label-text">Enter your phone number to receive a password reset link.</span>
                    </label>
                    <input name="phone" type="text" class="input input-bordered w-full" placeholder="Phone Number" required />
                    <input class="btn btn-warning my-5 w-full" type="submit" value="Submit">
                    <h3 class="max-w-[400px] mx-auto">
                        <a class="text-amber-500 hover:underline cursor-pointer" onclick="toggleForm()">Try with Email?</a>
                    </h3>
                </form>

                <!-- Success/Error Messages -->
                <% String message = (String) request.getAttribute("message");
                    if (message != null) { %>
                <div class="text-center text-red-500">
                    <p><%= message %></p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>
