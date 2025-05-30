package com.servlet;

import com.dao.ReservationDAO;
import com.model.Reservation;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

public class AddReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservationDAO reservationDAO;

    public void init() {
        reservationDAO = new ReservationDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String customerName = request.getParameter("customerName");
            String roomNumber = request.getParameter("roomNumber");
            Date checkIn = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("checkIn"));
            Date checkOut = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("checkOut"));
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

            Reservation newReservation = new Reservation(customerName, roomNumber, checkIn, checkOut, totalAmount);
            reservationDAO.addReservation(newReservation);

            // Redirect with status parameter
            response.sendRedirect("index.jsp?status=success");

        } catch (ParseException | SQLException e) {
            e.printStackTrace();
            // Pass error status via request attribute
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("reservationadd.jsp?status=fail").forward(request, response);
        }
    }
}
