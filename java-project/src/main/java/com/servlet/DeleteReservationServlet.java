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

public class DeleteReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservationDAO reservationDAO;

    public void init() {
        reservationDAO = new ReservationDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            reservationDAO.deleteReservation(reservationId);
            response.sendRedirect("index.jsp?status=deleted");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error deleting reservation: " + e.getMessage());
            request.getRequestDispatcher("reservationdelete.jsp?status=fail").forward(request, response);
        }
    }
}