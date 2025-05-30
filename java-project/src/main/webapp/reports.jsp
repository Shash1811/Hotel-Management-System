<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Reports | Hotel Management System</title>

<style>
    body {
        margin: 0;
        padding: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #eafaf1;
    }

    .container {
        max-width: 900px;
        margin: 40px auto;
        padding: 30px;
        background-color: #ffffff;
        border-radius: 12px;
        box-shadow: 0 0 12px rgba(0, 128, 0, 0.2);
    }

    .header {
        text-align: center;
        margin-bottom: 40px;
    }

    .header h1 {
        color: #2e7d32;
        margin-bottom: 8px;
    }

    .header p {
        color: #4caf50;
        font-size: 16px;
    }

    .report-options {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .report-option {
        border: 2px solid #81c784;
        border-radius: 10px;
        padding: 20px;
        background-color: #f1f8e9;
        transition: all 0.3s ease-in-out;
    }

    .report-option:hover {
        background-color: #dcedc8;
        border-color: #4caf50;
        box-shadow: 0 4px 12px rgba(76, 175, 80, 0.2);
    }

    .report-option h3 {
        margin: 0 0 10px;
        color: #2e7d32;
    }

    .report-option p {
        margin: 0 0 15px;
        color: #388e3c;
    }

    .report-option a {
        text-decoration: none;
        background-color: #4caf50;
        color: white;
        padding: 10px 20px;
        border-radius: 6px;
        font-weight: bold;
        transition: background-color 0.3s;
        display: inline-block;
    }

    .report-option a:hover {
        background-color: #388e3c;
    }

    .back-link {
        display: block;
        margin-top: 30px;
        text-align: center;
        color: #2e7d32;
        font-weight: bold;
        text-decoration: none;
    }

    .back-link:hover {
        text-decoration: underline;
    }
</style>

</head>
<body>

<div class="container">
    <div class="header">
        <h1>Reports Dashboard</h1>
        <p>Generate reports and gain hotel insights</p>
    </div>

    <div class="report-options">
        <div class="report-option">
            <h3>Reservations by Date Range</h3>
            <p>View all bookings between specific dates with guest details.</p>
            <a href="report_form.jsp?reportType=dateRange"><span>Generate Report</span></a>
        </div>

        <div class="report-option">
            <h3>Total Revenue</h3>
            <p>Calculate revenue over a time period with financial breakdown.</p>
            <a href="report_form.jsp?reportType=revenue"><span>Generate Report</span></a>
        </div>

        <div class="report-option">
            <h3>Most Popular Rooms</h3>
            <p>See the most frequently booked rooms and their occupancy trends.</p>
            <a href="report_form.jsp?reportType=popularRooms"><span>Generate Report</span></a>
        </div>
    </div>

    <a href="index.jsp" class="back-link">Back to Home</a>
</div>

</body>
</html>
