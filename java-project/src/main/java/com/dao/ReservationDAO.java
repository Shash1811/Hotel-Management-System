package com.dao;

import com.model.Reservation;
import java.sql.*;
import java.sql.Date;
import java.util.*;

public class ReservationDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/hoteldb"; // unified port
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    private static final String INSERT_RESERVATION_SQL = 
        "INSERT INTO Reservations (CustomerName, RoomNumber, CheckIn, CheckOut, TotalAmount) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_RESERVATION_BY_ID = 
        "SELECT * FROM Reservations WHERE ReservationID=?";
    private static final String SELECT_ALL_RESERVATIONS = 
        "SELECT * FROM Reservations";
    private static final String DELETE_RESERVATION_SQL = 
        "DELETE FROM Reservations WHERE ReservationID=?";
    private static final String UPDATE_RESERVATION_SQL = 
        "UPDATE Reservations SET CustomerName=?, RoomNumber=?, CheckIn=?, CheckOut=?, TotalAmount=? WHERE ReservationID=?";
    private static final String SELECT_RESERVATIONS_BY_DATE = 
        "SELECT * FROM Reservations WHERE CheckIn >= ? AND CheckOut <= ?";
    private static final String SELECT_TOTAL_REVENUE = 
        "SELECT SUM(TotalAmount) AS total FROM Reservations WHERE CheckIn >= ? AND CheckOut <= ?";
    private static final String SELECT_POPULAR_ROOMS = 
    	    "SELECT RoomNumber, UsageCount AS count FROM Rooms ORDER BY UsageCount DESC";


    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    // Add a new reservation
    public void addReservation(Reservation reservation) throws SQLException {
        RoomDAO roomDAO = new RoomDAO();
        String roomNumber = reservation.getRoomNumber();

        // Check if room exists
        if (!roomDAO.roomExists(roomNumber)) {
            throw new SQLException("Room " + roomNumber + " does not exist.");
        }

        // Check date-based availability
        if (!roomDAO.isRoomAvailable(roomNumber)) {
            throw new SQLException("Room " + roomNumber + " is already booked.");
        }


        // Proceed with reservation
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(INSERT_RESERVATION_SQL)) {
            stmt.setString(1, reservation.getCustomerName());
            stmt.setString(2, roomNumber);
            stmt.setDate(3, new java.sql.Date(reservation.getCheckIn().getTime()));
            stmt.setDate(4, new java.sql.Date(reservation.getCheckOut().getTime()));
            stmt.setDouble(5, reservation.getTotalAmount());
            stmt.executeUpdate();
        }

        // Update usage count
        roomDAO.incrementRoomUsage(roomNumber);
    }

    public boolean updateReservation(Reservation reservation) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(UPDATE_RESERVATION_SQL)) {
            stmt.setString(1, reservation.getCustomerName());
            stmt.setString(2, reservation.getRoomNumber());
            stmt.setDate(3, new java.sql.Date(reservation.getCheckIn().getTime()));
            stmt.setDate(4, new java.sql.Date(reservation.getCheckOut().getTime()));
            stmt.setDouble(5, reservation.getTotalAmount());
            stmt.setInt(6, reservation.getReservationId());
            return stmt.executeUpdate() > 0;
        }
    }

    public Reservation selectReservation(int id) throws SQLException {
        Reservation reservation = null;
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SELECT_RESERVATION_BY_ID)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                reservation = new Reservation(
                    rs.getString("CustomerName"),
                    rs.getString("RoomNumber"),
                    rs.getDate("CheckIn"),
                    rs.getDate("CheckOut"),
                    rs.getDouble("TotalAmount")
                );
                reservation.setReservationId(id);
            }
        }
        return reservation;
    }

    public List<Reservation> selectAllReservations() throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SELECT_ALL_RESERVATIONS)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Reservation reservation = new Reservation(
                    rs.getString("CustomerName"),
                    rs.getString("RoomNumber"),
                    rs.getDate("CheckIn"),
                    rs.getDate("CheckOut"),
                    rs.getDouble("TotalAmount")
                );
                reservation.setReservationId(rs.getInt("ReservationID"));
                reservations.add(reservation);
            }
        }
        return reservations;
    }

    public boolean deleteReservation(int id) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(DELETE_RESERVATION_SQL)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Reservation> getReservationsByDateRange(Date startDate, Date endDate) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_RESERVATIONS_BY_DATE)) {
            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Reservation reservation = new Reservation(
                    rs.getString("CustomerName"),
                    rs.getString("RoomNumber"),
                    rs.getDate("CheckIn"),
                    rs.getDate("CheckOut"),
                    rs.getDouble("TotalAmount")
                );
                reservation.setReservationId(rs.getInt("ReservationID"));
                reservations.add(reservation);
            }
        }
        return reservations;
    }

    public double getTotalRevenue(Date startDate, Date endDate) throws SQLException {
        double revenue = 0;
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_TOTAL_REVENUE)) {
            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                revenue = rs.getDouble("total");
            }
        }
        return revenue;
    }

    public Map<String, Integer> getMostPopularRooms() throws SQLException {
        Map<String, Integer> popularRooms = new LinkedHashMap<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_POPULAR_ROOMS)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                popularRooms.put(rs.getString("RoomNumber"), rs.getInt("count"));
            }
        }
        return popularRooms;
    }
}
