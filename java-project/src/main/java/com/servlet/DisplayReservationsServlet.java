package com.servlet;

import com.dao.ReservationDAO;
import com.model.Reservation;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/reservationdisplay")
public class DisplayReservationsServlet extends HttpServlet {
    private ReservationDAO reservationDAO;

    @Override
    public void init() {
        reservationDAO = new ReservationDAO(); // Adjust constructor if needed
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Reservation> reservations = reservationDAO.selectAllReservations();
            request.setAttribute("reservations", reservations);
            request.getRequestDispatcher("reservationdisplay.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to retrieve reservations.");
        }
    }
}
