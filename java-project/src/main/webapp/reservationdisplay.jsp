<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Reservation, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>View Reservations | Hotel Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #e8f5e9; /* light green background */
            color: #2e7d32; /* dark green text */
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(46,125,50,0.15);
            padding: 20px 30px;
        }
        header h1 {
            margin-bottom: 5px;
            font-weight: 700;
        }
        header p {
            margin-top: 0;
            color: #388e3c;
        }
        .stats {
            font-weight: 600;
            margin: 15px 0;
        }
        .action-bar {
            margin: 20px 0;
        }
        .btn {
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            font-weight: 600;
            color: white;
            margin-right: 10px;
            display: inline-block;
        }
        .btn-primary {
            background-color: #43a047; /* medium green */
        }
        .btn-primary:hover {
            background-color: #388e3c;
        }
        .btn-secondary {
            background-color: #81c784; /* lighter green */
            color: #2e7d32;
        }
        .btn-secondary:hover {
            background-color: #66bb6a;
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #c8e6c9;
        }
        th {
            background-color: #a5d6a7;
            color: #1b5e20;
        }
        tbody tr:hover {
            background-color: #c8e6c9;
        }
        .actions a {
            margin-right: 8px;
            color: #2e7d32;
            text-decoration: none;
            font-weight: 600;
        }
        .actions a:hover {
            text-decoration: underline;
        }
        .no-data {
            text-align: center;
            padding: 20px;
            color: #4caf50;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Current Reservations</h1>
            <p>Manage all your hotel bookings in one place</p>
        </header>

        <%
        List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
        int totalReservations = (reservations != null) ? reservations.size() : 0;
        %>

        <div class="stats">🎯 Total Reservations: <%= totalReservations %></div>

        <div class="action-bar">
            <a href="reservationadd.jsp" class="btn btn-primary">+ Add New Reservation</a>
            <a href="index.jsp" class="btn btn-secondary">← Back to Home</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Reservation ID</th>
                    <th>Customer Name</th>
                    <th>Room Number</th>
                    <th>Check-In Date</th>
                    <th>Check-Out Date</th>
                    <th>Total Amount</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
            if (reservations != null && !reservations.isEmpty()) {
                for (Reservation reservation : reservations) {
            %>
                <tr>
                    <td>#<%= reservation.getReservationId() %></td>
                    <td><%= reservation.getCustomerName() %></td>
                    <td><%= reservation.getRoomNumber() %></td>
                    <td><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(reservation.getCheckIn()) %></td>
                    <td><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(reservation.getCheckOut()) %></td>
                    <td>$<%= String.format("%.2f", reservation.getTotalAmount()) %></td>
                    <td class="actions">
                        <a href="reservationupdate.jsp?id=<%= reservation.getReservationId() %>">✏️ Update</a>
                        <a href="reservationdelete.jsp?id=<%= reservation.getReservationId() %>">🗑️ Delete</a>
                    </td>
                </tr>
            <%
                }
            } else {
            %>
                <tr>
                    <td colspan="7" class="no-data">
                        🏨 No reservations found yet.<br>
                        <a href="reservationadd.jsp">Create your first reservation</a> to get started!
                    </td>
                </tr>
            <%
            }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>
