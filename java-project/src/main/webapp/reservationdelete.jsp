<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Reservation, com.dao.ReservationDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Delete Reservation | Hotel Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #e6f4ea;
            color: #2e5939;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 500px;
            margin: auto;
            background: #ffffff;
            border: 2px solid #2e5939;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 0 10px #a6d08c;
        }
        h1 {
            text-align: center;
            margin-bottom: 10px;
        }
        .details {
            margin: 20px 0;
        }
        .detail-item {
            margin-bottom: 10px;
        }
        .detail-label {
            font-weight: bold;
            display: inline-block;
            width: 140px;
        }
        .highlight {
            color: #2e7d32;
            font-weight: bold;
        }
        .buttons {
            text-align: center;
            margin-top: 20px;
        }
        button, a.btn {
            background-color: #4caf50;
            color: white;
            border: none;
            padding: 10px 18px;
            margin: 5px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
        }
        button.btn-cancel, a.btn-cancel {
            background-color: #a5d6a7;
            color: #2e5939;
        }
        button:hover, a.btn:hover {
            background-color: #388e3c;
        }
        /* Modal styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(46, 89, 57, 0.7);
            justify-content: center;
            align-items: center;
            z-index: 999;
        }
        .modal-overlay.show {
            display: flex;
        }
        .modal-content {
            background: white;
            padding: 20px;
            border-radius: 8px;
            max-width: 400px;
            text-align: center;
            box-shadow: 0 0 15px #2e5939;
        }
        .modal-buttons {
            margin-top: 20px;
        }
        .modal-buttons button {
            min-width: 100px;
        }
        .modal-close {
            background: transparent;
            border: none;
            font-size: 24px;
            position: absolute;
            right: 20px;
            top: 20px;
            cursor: pointer;
            color: #2e5939;
        }
    </style>
</head>
<body>

<%
    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect("reservationdisplay.jsp");
        return;
    }
    int id = Integer.parseInt(idParam);
    ReservationDAO reservationDAO = new ReservationDAO();
    Reservation reservation = reservationDAO.selectReservation(id);
    if (reservation == null) {
        response.sendRedirect("reservationdisplay.jsp");
        return;
    }
%>

<div class="container">
    <h1>Delete Reservation</h1>
    <p style="text-align:center;">Please confirm the reservation details before deletion</p>

    <div class="details">
        <div class="detail-item">
            <span class="detail-label">Reservation ID:</span>
            <span class="highlight">#<%= reservation.getReservationId() %></span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Customer Name:</span>
            <span><%= reservation.getCustomerName() %></span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Room Number:</span>
            <span><%= reservation.getRoomNumber() %></span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Check-In Date:</span>
            <span><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(reservation.getCheckIn()) %></span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Check-Out Date:</span>
            <span><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(reservation.getCheckOut()) %></span>
        </div>
        <div class="detail-item">
            <span class="detail-label">Total Amount:</span>
            <span class="highlight">$<%= String.format("%.2f", reservation.getTotalAmount()) %></span>
        </div>
    </div>

    <div class="buttons">
        <button onclick="showModal()">Delete Reservation</button>
        <a href="reservationdisplay.jsp" class="btn-cancel btn">Cancel</a>
    </div>
</div>

<!-- Modal -->
<div id="confirmModal" class="modal-overlay">
    <div class="modal-content">
        <button class="modal-close" onclick="hideModal()">&times;</button>
        <h2>Confirm Deletion</h2>
        <p>Are you sure you want to permanently delete this reservation? This action cannot be undone.</p>
        <div class="modal-buttons">
            <form action="DeleteReservationServlet" method="post" style="display:inline;">
                <input type="hidden" name="reservationId" value="<%= reservation.getReservationId() %>">
                <button type="submit">Yes, Delete</button>
            </form>
            <button onclick="hideModal()" class="btn-cancel">Cancel</button>
        </div>
    </div>
</div>

<script>
function showModal() {
    document.getElementById('confirmModal').classList.add('show');
}
function hideModal() {
    document.getElementById('confirmModal').classList.remove('show');
}
document.getElementById('confirmModal').addEventListener('click', function(e) {
    if (e.target === this) hideModal();
});
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') hideModal();
});
</script>

</body>
</html>
