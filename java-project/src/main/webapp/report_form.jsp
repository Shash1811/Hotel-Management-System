<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Report | Hotel Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #eafaf1;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 20px 40px;
            background: #ffffff;
            box-shadow: 0 0 12px rgba(0, 128, 0, 0.2);
            border-radius: 12px;
        }

        .header h1 {
            color: #2e7d32;
            margin-bottom: 5px;
        }

        .header p {
            color: #4caf50;
        }

        .error-alert {
            background-color: #f8d7da;
            color: #842029;
            padding: 12px;
            border-left: 6px solid #f44336;
            margin-bottom: 20px;
            border-radius: 6px;
        }

        .report-type-info h2 {
            color: #388e3c;
        }

        .report-type-info p {
            color: #2e7d32;
        }

        .form-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-top: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            margin-bottom: 8px;
            color: #2e7d32;
            font-weight: bold;
        }

        .form-input {
            padding: 10px;
            border: 2px solid #81c784;
            border-radius: 6px;
            outline: none;
        }

        .form-input:focus {
            border-color: #388e3c;
            box-shadow: 0 0 6px #a5d6a7;
        }

        .btn {
            background-color: #4caf50;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
            transition: background 0.3s;
        }

        .btn:hover {
            background-color: #388e3c;
        }

        .btn.loading {
            background-color: #81c784;
        }

        .back-link {
            margin-top: 25px;
        }

        .back-link a {
            text-decoration: none;
            color: #2e7d32;
            font-weight: bold;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>Generate Report</h1>
        <p>Create detailed analytics and insights</p>
    </div>

    <div class="content">
        <%
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
        %>
        <div class="error-alert">
            <%= error.replaceAll("\"", "&quot;") %>
        </div>
        <%
        }
        %>

        <%
        String reportType = request.getParameter("reportType");
        if (reportType == null) {
        %>
        <div class="error-alert">
            No report type selected. Please select a report type from the main menu.
        </div>
        <div class="back-link">
            <a href="dashboard.jsp">Back to Dashboard</a>
        </div>
        <%
        } else {
        %>
        <div class="report-type-info">
            <h2>
                <%= reportType.equals("dateRange") ? "Reservations by Date Range" :
                    reportType.equals("revenue") ? "Revenue Report" :
                    reportType.equals("popularRooms") ? "Popular Rooms Report" : "Unknown Report" %>
            </h2>
            <p>
                <%= reportType.equals("dateRange") ? "Generate a comprehensive list of all reservations within your specified date range." :
                    reportType.equals("revenue") ? "Analyze your revenue performance and financial metrics for the selected period." :
                    reportType.equals("popularRooms") ? "Discover which rooms are most frequently booked and generate insights." : "Report description not available." %>
            </p>
        </div>

        <form action="ReportServlet" method="post" class="report-form">
            <div class="form-container">
                <input type="hidden" name="reportType" value="<%= reportType %>" class="hidden-input">

                <% if ("dateRange".equals(reportType) || "revenue".equals(reportType)) { %>
                <div class="form-group">
                    <label for="startDate" class="form-label">
                        <i class="fas fa-calendar-alt"></i> Start Date
                    </label>
                    <input type="date" id="startDate" name="startDate" class="form-input" required>
                </div>

                <div class="form-group">
                    <label for="endDate" class="form-label">
                        <i class="fas fa-calendar-check"></i> End Date
                    </label>
                    <input type="date" id="endDate" name="endDate" class="form-input" required>
                </div>
                <% } %>
            </div>

            <button type="submit" class="btn">
                <span>Generate Report</span>
            </button>
        </form>

        <div class="back-link">
            <a href="index.jsp">Back to Home</a>
        </div>
        <%
        }
        %>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('.report-form');
    const submitBtn = document.querySelector('.btn');
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');

    function validateDates() {
        if (startDateInput && endDateInput) {
            const startDate = new Date(startDateInput.value);
            const endDate = new Date(endDateInput.value);
            const today = new Date();
            today.setHours(23, 59, 59, 999);

            if (startDate > today) {
                startDateInput.setCustomValidity('Start date cannot be in the future');
                return false;
            } else if (endDate < startDate) {
                endDateInput.setCustomValidity('End date must be after start date');
                return false;
            } else {
                startDateInput.setCustomValidity('');
                endDateInput.setCustomValidity('');
                return true;
            }
        }
        return true;
    }

    if (startDateInput && endDateInput) {
        startDateInput.addEventListener('change', validateDates);
        endDateInput.addEventListener('change', validateDates);

        const today = new Date().toISOString().split('T')[0];
        startDateInput.setAttribute('max', today);
        endDateInput.setAttribute('max', today);
    }

    if (form) {
        form.addEventListener('submit', function(e) {
            if (!validateDates()) {
                e.preventDefault();
                return;
            }
            submitBtn.disabled = true;
            submitBtn.classList.add('loading');
            submitBtn.innerHTML = '<span>Generating...</span>';
        });
    }
});
</script>

</body>
</html>
