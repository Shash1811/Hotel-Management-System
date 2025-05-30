<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: #f4fdf4;
            color: #1f3329;
        }

        .main-container {
            max-width: 1200px;
            margin: auto;
            padding: 20px;
        }

        .hero-section {
            background: linear-gradient(135deg, #1abc9c, #16a085);
            color: #fff;
            padding: 80px 20px;
            text-align: center;
            border-radius: 0 0 30px 30px;
        }

        .hero-section h1 {
            font-size: 3em;
            font-weight: 600;
        }

        .section-title {
            text-align: center;
            margin: 60px 0 20px;
            font-size: 2.5em;
            color: #1abc9c;
        }

        .services-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
            margin-top: 30px;
        }

        .service-card {
            background-color: #ffffff;
            border-radius: 20px;
            padding: 30px;
            width: 300px;
            box-shadow: 0 6px 20px rgba(0, 128, 0, 0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-align: center;
        }

        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 24px rgba(0, 128, 0, 0.25);
        }

        .service-icon {
            font-size: 3rem;
            color: #1abc9c;
            margin-bottom: 15px;
        }

        .service-card h3 {
            color: #16a085;
            margin-bottom: 10px;
        }

        .service-button {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #1abc9c;
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }

        .service-button:hover {
            background-color: #149174;
        }

        footer {
            margin-top: 60px;
            text-align: center;
            padding: 20px;
            background-color: #eafaf1;
            border-top: 1px solid #ccebdc;
        }

        .toast {
            position: fixed;
            top: 30px;
            right: 30px;
            background-color: #2ecc71;
            color: white;
            padding: 20px;
            border-radius: 10px;
            z-index: 9999;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            animation: fadeIn 0.5s ease;
        }

        .toast-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .toast-close {
            background: transparent;
            border: none;
            color: white;
            font-size: 18px;
            cursor: pointer;
        }

        .slide-out {
            animation: fadeOut 0.5s ease forwards;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeOut {
            from { opacity: 1; }
            to { opacity: 0; transform: translateY(-20px); }
        }

        @media (max-width: 768px) {
            .services-grid {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>

<%
    String status = request.getParameter("status");
    String toastMessage = "";
    String toastTitle = "";

    if ("success".equals(status)) {
        toastTitle = "Success!";
        toastMessage = "Your reservation has been successfully created.";
    } else if ("deleted".equals(status)) {
        toastTitle = "Success!";
        toastMessage = "Your reservation has been successfully deleted.";
    } else if ("done".equals(status)) {
        toastTitle = "Success!";
        toastMessage = "Your reservation has been successfully updated.";
    }

    if (!toastMessage.isEmpty()) {
%>
    <div id="toast" class="toast">
        <div class="toast-header">
            <span class="toast-title"><%= toastTitle %></span>
            <button class="toast-close" onclick="closeToast()">×</button>
        </div>
        <div class="toast-message"><%= toastMessage %></div>
    </div>
    <script>
        function closeToast() {
            const toast = document.getElementById('toast');
            toast.classList.add('slide-out');
            setTimeout(() => toast.style.display = 'none', 500);
        }

        window.onload = function () {
            setTimeout(() => closeToast(), 5000);
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.pathname);
            }
        };
    </script>
<% } %>

<section class="hero-section" id="home">
    <div class="main-container">
        <div class="hero-content">
            <h1>Hotel Management System</h1>
        </div>
    </div>
</section>

<section class="services-section" id="services">
    <div class="main-container">
        <h2 class="section-title">Management Hub</h2>
        <div class="services-grid">
            <div class="service-card">
                <span class="service-icon">🎯</span>
                <h3>New Reservation</h3>
                <p>Create new bookings with real-time availability and instant confirmation.</p>
                <a href="reservationadd.jsp" class="service-button">Start Booking</a>
            </div>
            <div class="service-card">
                <span class="service-icon">⚡</span>
                <h3>Booking Control</h3>
                <p>Manage all your reservations from a centralized dashboard.</p>
                <a href="reservationdisplay" class="service-button">Access Panel</a>
            </div>
            <div class="service-card">
                <span class="service-icon">📈</span>
                <h3>Analytics Hub</h3>
                <p>Generate reports and insights into your booking and business trends.</p>
                <a href="reports.jsp" class="service-button">View Analytics</a>
            </div>
        </div>
    </div>
</section>

<footer>
    <p>&copy; 2025 - Advanced Hotel Management Solutions</p>
</footer>

</body>
</html>
