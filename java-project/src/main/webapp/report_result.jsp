<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Reservation, java.util.List, java.util.Arrays" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Report Results | Hotel Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #0a0e27;
            color: #e1e5e9;
            line-height: 1.6;
            overflow-x: hidden;
            min-height: 100vh;
            padding: 2rem 1rem;
        }

        .container {
            max-width: 850px;
            margin: 0 auto;
            background: rgba(26, 32, 56, 0.9);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1);
            animation: formSlideIn 0.8s ease-out;
        }

        .header {
            background: linear-gradient(135deg, #ff6b6b, #4ecdc4);
            color: white;
            padding: 3rem 2.5rem;
            text-align: center;
            position: relative;
        }

        .header h1 {
            margin: 0;
            font-size: 2rem;
        }

        .header p {
            margin-top: 0.5rem;
            font-size: 1rem;
        }

        .content {
            padding: 2rem;
        }

        .badge {
            display: inline-block;
            background-color: #0f1035;
            color: #fff;
            padding: 0.6rem 1.2rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
        }

        th, td {
            text-align: left;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #334155;
        }

        th {
            background-color: #7fc7d9;
            color: #0f1035;
            font-size: 0.95rem;
            text-transform: uppercase;
        }

        td {
            color: #e2e8f0;
        }

        .no-data {
            text-align: center;
            padding: 2rem;
            color: #94a3b8;
            font-style: italic;
        }

        .revenue {
            text-align: center;
            background-color: #10b981;
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            font-size: 2rem;
            font-weight: bold;
        }

        .back-links {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }

        .back-links a {
            background-color: #365486;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-links a:hover {
            background-color: #0f1035;
        }

        @media print {
            .back-links {
                display: none;
            }
            body {
                background-color: white;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Report Results</h1>
            <p>View your generated report data below</p>
        </div>
        <div class="content">
            <%
                String reportType = (String) request.getAttribute("reportType");
                if (reportType != null) {
            %>
                <div class="badge">
                    <%= reportType.equals("dateRange") ? "📅 Date Range Report" :
                        reportType.equals("revenue") ? "💰 Revenue Report" :
                        reportType.equals("popularRooms") ? "🏆 Popular Rooms" : "📊 Report" %>
                </div>
            <%
                }

                if ("dateRange".equals(reportType)) {
                    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Reservation ID</th>
                            <th>Customer Name</th>
                            <th>Room No.</th>
                            <th>Check-In</th>
                            <th>Check-Out</th>
                            <th>Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (reservations != null && !reservations.isEmpty()) {
                                for (Reservation res : reservations) {
                        %>
                            <tr>
                                <td><%= res.getReservationId() %></td>
                                <td><%= res.getCustomerName() %></td>
                                <td><%= res.getRoomNumber() %></td>
                                <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(res.getCheckIn()) %></td>
                                <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(res.getCheckOut()) %></td>
                                <td>$<%= String.format("%.2f", res.getTotalAmount()) %></td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="6" class="no-data">No reservations found in this date range.</td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            <%
                } else if ("revenue".equals(reportType)) {
                    Double totalRevenue = (Double) request.getAttribute("totalRevenue");
            %>
                <div class="revenue">
                    💰 Total Revenue: $<%= String.format("%.2f", totalRevenue != null ? totalRevenue : 0.0) %>
                </div>
            <%
                } else if ("popularRooms".equals(reportType)) {
                    List<String[]> popularRooms = (List<String[]>) request.getAttribute("popularRooms");
            %>
                <table>
                    <thead>
                        <tr>
                            <th style="text-align:center;">Room No.</th>
                            <th style="text-align:center;">Bookings</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (popularRooms != null && !popularRooms.isEmpty()) {
                                for (String[] room : popularRooms) {
                                    if (room.length >= 2) {
                        %>
                            <tr>
                                <td style="text-align:center;"><%= room[0] %></td>
                                <td style="text-align:center;"><%= room[1] %></td>
                            </tr>
                        <%
                                    }
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="2" class="no-data">No booking data available.</td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            <%
                }
            %>

            <div class="back-links">
                <a href="index.jsp">🏠 Home</a>
                <a href="reports.jsp">📄 Generate Another Report</a>
            </div>
        </div>
    </div>
</body>
</html>
