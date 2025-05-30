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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdateReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservationDAO reservationDAO;

    public void init() {
        reservationDAO = new ReservationDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            String customerName = request.getParameter("customerName");
            String roomNumber = request.getParameter("roomNumber");
            Date checkIn = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("checkIn"));
            Date checkOut = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("checkOut"));
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

            Reservation reservation = new Reservation(customerName, roomNumber, checkIn, checkOut, totalAmount);
            reservation.setReservationId(reservationId);
            reservationDAO.updateReservation(reservation);
            response.sendRedirect("index.jsp?status=done");
        } catch (ParseException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating reservation: " + e.getMessage());
            request.getRequestDispatcher("reservationupdate.jsp").forward(request, response);
        }
    }
}