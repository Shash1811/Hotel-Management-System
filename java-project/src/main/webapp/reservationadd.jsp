<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Reservation | Hotel Management System</title>

<style>
    body {
        margin: 0;
        padding: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #e8f5e9;
        color: #2e7d32;
    }

    .container {
        max-width: 600px;
        margin: 40px auto;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 0 15px rgba(46, 125, 50, 0.3);
    }

    .header {
        text-align: center;
        margin-bottom: 30px;
    }

    .header h1 {
        margin-bottom: 8px;
        color: #2e7d32;
    }

    .header p {
        color: #4caf50;
        font-size: 16px;
    }

    .form-section form {
        display: flex;
        flex-direction: column;
        gap: 18px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
    }

    label {
        margin-bottom: 6px;
        font-weight: 600;
        color: #2e7d32;
    }

    input[type="text"],
    input[type="date"],
    input[type="number"] {
        padding: 10px 12px;
        border: 2px solid #a5d6a7;
        border-radius: 6px;
        font-size: 16px;
        transition: border-color 0.3s ease;
    }

    input[type="text"]:focus,
    input[type="date"]:focus,
    input[type="number"]:focus {
        border-color: #388e3c;
        outline: none;
        background: #e8f5e9;
    }

    .submit-btn {
        background-color: #4caf50;
        border: none;
        padding: 12px 0;
        border-radius: 8px;
        color: white;
        font-weight: 700;
        font-size: 18px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .submit-btn:hover {
        background-color: #388e3c;
    }

    .back-link {
        display: block;
        margin-top: 25px;
        text-align: center;
        color: #2e7d32;
        font-weight: bold;
        text-decoration: none;
        font-size: 15px;
    }

    .back-link:hover {
        text-decoration: underline;
    }

    /* Toast styles */
    #toast {
        position: fixed;
        top: 20px;
        right: 20px;
        width: 320px;
        background-color: #a5d6a7;
        border-left: 6px solid #388e3c;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(46, 125, 50, 0.4);
        z-index: 9999;
        animation: slideIn 0.3s forwards;
    }

    .toast-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 15px;
        background-color: #4caf50;
        border-radius: 8px 8px 0 0;
        color: white;
        font-weight: 700;
        font-size: 16px;
    }

    .toast-close {
        background: none;
        border: none;
        color: white;
        font-size: 20px;
        cursor: pointer;
        font-weight: 900;
        line-height: 1;
    }

    .toast-message {
        padding: 12px 15px;
        color: #2e7d32;
        font-size: 14px;
    }

    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(100%);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    .slide-out {
        animation: slideOut 0.5s forwards;
    }

    @keyframes slideOut {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100%);
        }
    }

    /* Focus animation on input container */
    .focused input {
        border-color: #388e3c;
        background: #e8f5e9;
        box-shadow: 0 0 8px #81c784;
    }
</style>

</head>
<body>

<div class="bg-pattern"></div>

<%
String status = request.getParameter("status");
String errorMessage = (String) request.getAttribute("error");
if ("fail".equals(status) && errorMessage != null) {
%>
<div id="toast" class="toast">
    <div class="toast-header">
        <span class="toast-title">Error!</span>
        <button class="toast-close" onclick="closeToast()">×</button>
    </div>
    <div class="toast-message">Reservation failed: <%= errorMessage.replace("\"", "\\\"") %></div>
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
<%
}
%>

<div class="container">
    <div class="header">
        <h1>Add New Reservation</h1>
        <p>Fill in the details below to create your booking</p>
    </div>

    <div class="form-section">
        <form action="AddReservationServlet" method="post">
            <div class="form-group">
                <label for="customerName">Customer Name:</label>
                <input type="text" id="customerName" name="customerName" placeholder="Enter customer name" required>
            </div>

            <div class="form-group">
                <label for="roomNumber">Room Number:</label>
                <input type="text" id="roomNumber" name="roomNumber" placeholder="Enter room number" required>
            </div>

            <div class="form-group">
                <label for="checkIn">Check-In Date:</label>
                <input type="date" id="checkIn" name="checkIn" required>
            </div>

            <div class="form-group">
                <label for="checkOut">Check-Out Date:</label>
                <input type="date" id="checkOut" name="checkOut" required>
            </div>

            <div class="form-group">
                <label for="totalAmount">Total Amount:</label>
                <input type="number" id="totalAmount" name="totalAmount" step="0.01" placeholder="Enter total amount" required>
            </div>

            <button type="submit" class="submit-btn"><span>Add Reservation</span></button>
        </form>

        <a href="index.jsp" class="back-link">Back to Home</a>
    </div>
</div>

<script>
// Form validation and animations
document.addEventListener('DOMContentLoaded', function() {
    const inputs = document.querySelectorAll('input');
    
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.classList.add('focused');
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.classList.remove('focused');
        });
    });

    // Date validation
    const checkInInput = document.getElementById('checkIn');
    const checkOutInput = document.getElementById('checkOut');
    
    checkInInput.addEventListener('change', function() {
        checkOutInput.min = this.value;
        if (checkOutInput.value && checkOutInput.value <= this.value) {
            checkOutInput.value = '';
        }
    });

    // Set minimum date to today
    const today = new Date().toISOString().split('T')[0];
    checkInInput.min = today;
    checkOutInput.min = today;
});
</script>

</body>
</html>
