<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Reservation, com.dao.ReservationDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Update Reservation | Hotel Management System</title>

<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #e6f2e6;
        color: #2f4f2f;
        margin: 0;
        padding: 0;
    }

    .container {
        max-width: 500px;
        margin: 40px auto;
        background: #f9fff9;
        border: 1px solid #a3d9a5;
        border-radius: 8px;
        padding: 25px 30px;
        box-shadow: 0 4px 8px rgba(46, 125, 50, 0.15);
    }

    .header h1 {
        margin-bottom: 5px;
        color: #2a5d2a;
    }

    .header p {
        margin-top: 0;
        font-size: 0.9rem;
        color: #4a7f4a;
    }

    .form-group {
        margin-bottom: 18px;
    }

    label {
        display: block;
        margin-bottom: 6px;
        font-weight: 600;
    }

    input[type="text"],
    input[type="date"],
    input[type="number"] {
        width: 100%;
        padding: 10px 12px;
        border: 1.5px solid #74b474;
        border-radius: 5px;
        font-size: 1rem;
        color: #2f4f2f;
        transition: border-color 0.3s ease;
    }

    input[type="text"]:focus,
    input[type="date"]:focus,
    input[type="number"]:focus {
        border-color: #4caf50;
        outline: none;
        background-color: #e8f5e9;
    }

    .actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 25px;
    }

    button.update-btn {
        background-color: #4caf50;
        color: white;
        padding: 12px 22px;
        border: none;
        border-radius: 5px;
        font-weight: 700;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    button.update-btn:hover {
        background-color: #388e3c;
    }

    a.cancel-btn {
        color: #4caf50;
        text-decoration: none;
        font-weight: 600;
        border: 2px solid #4caf50;
        padding: 10px 18px;
        border-radius: 5px;
        transition: background-color 0.3s ease, color 0.3s ease;
    }

    a.cancel-btn:hover {
        background-color: #4caf50;
        color: white;
    }

    .error {
        background-color: #f8d7da;
        color: #842029;
        border: 1px solid #f5c2c7;
        padding: 12px 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        font-weight: 600;
    }

    .back-link {
        display: inline-block;
        margin-top: 25px;
        color: #4caf50;
        font-weight: 600;
        text-decoration: none;
        transition: text-decoration 0.3s ease;
    }

    .back-link:hover {
        text-decoration: underline;
    }
</style>

</head>
<body>

<div class="container">
    <div class="header">
        <h1>Update Reservation</h1>
        <p>Modify reservation details with ease</p>
    </div>
    <div class="content">
        <%
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect("reservationdisplay.jsp");
                return;
            }
            int id = -1;
            try {
                id = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                response.sendRedirect("reservationdisplay.jsp");
                return;
            }

            ReservationDAO reservationDAO = new ReservationDAO();
            Reservation reservation = reservationDAO.selectReservation(id);

            if (reservation == null) {
                response.sendRedirect("reservationdisplay.jsp");
                return;
            }

            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
            <div class="error"><%= errorMessage %></div>
        <% } %>

        <form action="UpdateReservationServlet" method="post" novalidate>
            <input type="hidden" name="reservationId" value="<%= reservation.getReservationId() %>" class="hidden-input">

            <div class="form-group">
                <label for="customerName">Customer Name</label>
                <input
                    type="text"
                    id="customerName"
                    name="customerName"
                    value="<%= reservation.getCustomerName() %>"
                    required
                    placeholder="Enter customer name"
                />
            </div>

            <div class="form-group">
                <label for="roomNumber">Room Number</label>
                <input
                    type="text"
                    id="roomNumber"
                    name="roomNumber"
                    value="<%= reservation.getRoomNumber() %>"
                    required
                    placeholder="Enter room number"
                />
            </div>

            <div class="form-group">
                <label for="checkIn">Check-In Date</label>
                <input
                    type="date"
                    id="checkIn"
                    name="checkIn"
                    required
                    value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(reservation.getCheckIn()) %>"
                />
            </div>

            <div class="form-group">
                <label for="checkOut">Check-Out Date</label>
                <input
                    type="date"
                    id="checkOut"
                    name="checkOut"
                    required
                    value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(reservation.getCheckOut()) %>"
                />
            </div>

            <div class="form-group">
                <label for="totalAmount">Total Amount ($)</label>
                <input
                    type="number"
                    id="totalAmount"
                    name="totalAmount"
                    step="0.01"
                    min="0"
                    required
                    value="<%= reservation.getTotalAmount() %>"
                    placeholder="0.00"
                />
            </div>

            <div class="actions">
                <button type="submit" class="update-btn">
                    <span>Update Reservation</span>
                </button>
                <a href="reservationdisplay" class="cancel-btn">Cancel</a>
            </div>
        </form>

        <div style="text-align: center;">
            <a href="reservationdisplay" class="back-link">Back to Reservations</a>
        </div>
    </div>
</div>

</body>
</html>
