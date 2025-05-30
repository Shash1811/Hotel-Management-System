package com.dao;

import java.sql.*;

public class RoomDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/hoteldb"; // unified port
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    private static final String CHECK_ROOM_EXISTS_SQL = "SELECT * FROM Rooms WHERE RoomNumber=?";
    private static final String INCREMENT_USAGE_SQL = "UPDATE Rooms SET UsageCount = UsageCount + 1 WHERE RoomNumber=?";
    private static final String CHECK_ROOM_AVAILABILITY_BY_DATE_SQL =
        "SELECT 1 FROM Reservations WHERE RoomNumber = ? AND CheckIn < ? AND CheckOut > ?";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public boolean roomExists(String roomNumber) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(CHECK_ROOM_EXISTS_SQL)) {
            stmt.setString(1, roomNumber);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }

    // Updated to check availability based on date range
    public boolean isRoomAvailable(String roomNumber) throws SQLException {
        String sql = "SELECT 1 FROM reservations WHERE RoomNumber = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, roomNumber);
            return !stmt.executeQuery().next(); // true if no reservation exists
        }
    }


    public void incrementRoomUsage(String roomNumber) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(INCREMENT_USAGE_SQL)) {
            stmt.setString(1, roomNumber);
            stmt.executeUpdate();
        }
    }
}
