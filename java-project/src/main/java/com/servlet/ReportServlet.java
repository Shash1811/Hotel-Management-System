package com.servlet;

import com.dao.ReservationDAO;
import com.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.sql.Date;

public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservationDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new ReservationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String reportType = request.getParameter("reportType");

        try {
            if (reportType == null || reportType.trim().isEmpty()) {
                throw new IllegalArgumentException("Report type is missing.");
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);

            switch (reportType) {
                case "dateRange": {
                    String start = request.getParameter("startDate");
                    String end = request.getParameter("endDate");

                    if (start == null || end == null || start.isEmpty() || end.isEmpty()) {
                        throw new IllegalArgumentException("Start date or end date is missing.");
                    }

                    java.util.Date parsedStart = sdf.parse(start.trim());
                    java.util.Date parsedEnd = sdf.parse(end.trim());

                    if (parsedStart.after(parsedEnd)) {
                        throw new IllegalArgumentException("Start date cannot be after end date.");
                    }

                    java.util.Date today = new java.util.Date();
                    if (parsedStart.after(today) || parsedEnd.after(today)) {
                        // Allow current and past dates
                        throw new IllegalArgumentException("Dates cannot be in the future.");
                    }

                    // To include the full end date (up to 23:59:59), we can add 1 day
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(parsedEnd);
                    cal.add(Calendar.DATE, 1);  // Move to next day to make query <= endDate inclusive
                    java.util.Date inclusiveEnd = cal.getTime();

                    Date startDate = new Date(parsedStart.getTime());
                    Date endDate = new Date(inclusiveEnd.getTime()); // send as inclusive

                    List<Reservation> reservations = reportDAO.getReservationsByDateRange(startDate, endDate);
                    request.setAttribute("reservations", reservations);
                    break;
                }

                case "revenue": {
                    String start = request.getParameter("startDate");
                    String end = request.getParameter("endDate");

                    if (start == null || end == null || start.isEmpty() || end.isEmpty()) {
                        throw new IllegalArgumentException("Start date or end date is missing.");
                    }

                    java.util.Date parsedStart = sdf.parse(start.trim());
                    java.util.Date parsedEnd = sdf.parse(end.trim());

                    if (parsedStart.after(parsedEnd)) {
                        throw new IllegalArgumentException("Start date cannot be after end date.");
                    }

                    java.util.Date today = new java.util.Date();
                    if (parsedStart.after(today) || parsedEnd.after(today)) {
                        throw new IllegalArgumentException("Dates cannot be in the future.");
                    }

                    Calendar cal = Calendar.getInstance();
                    cal.setTime(parsedEnd);
                    cal.add(Calendar.DATE, 1);  // make endDate inclusive
                    java.util.Date inclusiveEnd = cal.getTime();

                    Date startDate = new Date(parsedStart.getTime());
                    Date endDate = new Date(inclusiveEnd.getTime());

                    double totalRevenue = reportDAO.getTotalRevenue(startDate, endDate);
                    request.setAttribute("totalRevenue", totalRevenue);
                    break;
                }

                case "popularRooms": {
                    Map<String, Integer> roomMap = reportDAO.getMostPopularRooms();
                    List<String[]> popularRooms = new ArrayList<>();

                    for (Map.Entry<String, Integer> entry : roomMap.entrySet()) {
                        popularRooms.add(new String[]{entry.getKey(), String.valueOf(entry.getValue())});
                    }

                    request.setAttribute("popularRooms", popularRooms);
                    request.setAttribute("reportType", "popularRooms");
                    break;
                }

                default:
                    throw new IllegalArgumentException("Invalid report type.");
            }

            request.setAttribute("reportType", reportType);
            request.getRequestDispatcher("report_result.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = "Error generating report: " + e.getMessage();
            response.sendRedirect("report_form.jsp?error=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        }
    }
}
