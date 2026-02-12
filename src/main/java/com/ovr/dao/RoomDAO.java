package com.ovr.dao;

import com.ovr.model.Room;
import com.ovr.util.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public Integer findAvailableRoom(int roomTypeId, String checkIn, String checkOut) {

        String sql =
                "SELECT r.room_id FROM rooms r " +
                "WHERE r.room_type_id = ? " +
                "AND r.status = 'AVAILABLE' " +
                "AND r.is_active = 1 " +
                "AND r.room_id NOT IN (" +
                "   SELECT room_id FROM reservations " +
                "   WHERE status = 'ACTIVE' " +
                "   AND (check_in < ? AND check_out > ?)" +
                ") LIMIT 1";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);
            ps.setString(2, checkOut);
            ps.setString(3, checkIn);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("room_id");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- Admin methods below ---

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();

        String sql =
                "SELECT r.room_id, r.room_number, r.status, r.is_active, r.room_type_id, rt.type_name " +
                "FROM rooms r JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "ORDER BY r.room_id DESC";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setStatus(rs.getString("status"));
                room.setIsActive(rs.getInt("is_active"));
                room.setRoomTypeId(rs.getInt("room_type_id"));
                room.setRoomTypeName(rs.getString("type_name"));
                list.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addRoom(String roomNumber, int roomTypeId) {
        String sql = "INSERT INTO rooms (room_number, status, room_type_id, is_active) VALUES (?, 'AVAILABLE', ?, 1)";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomNumber);
            ps.setInt(2, roomTypeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setRoomActive(int roomId, int isActive) {
        String sql = "UPDATE rooms SET is_active = ? WHERE room_id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, isActive);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public java.util.List<Integer> getAvailableRoomIds(int roomTypeId, String checkIn, String checkOut) {

        java.util.List<Integer> list = new java.util.ArrayList<>();

        String sql =
                "SELECT r.room_id FROM rooms r " +
                "WHERE r.room_type_id = ? " +
                "AND r.status = 'AVAILABLE' " +
                "AND r.is_active = 1 " +
                "AND r.room_id NOT IN (" +
                "   SELECT room_id FROM reservations " +
                "   WHERE status = 'ACTIVE' " +
                "   AND (check_in < ? AND check_out > ?)" +
                ")";

        try (java.sql.Connection con = com.ovr.util.DB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);
            ps.setString(2, checkOut);
            ps.setString(3, checkIn);

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("room_id"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public java.util.List<com.ovr.model.Room> getAvailableRooms(int roomTypeId, String checkIn, String checkOut) {

        java.util.List<com.ovr.model.Room> list = new java.util.ArrayList<>();

        String sql =
                "SELECT r.room_id, r.room_number, r.status, r.is_active, r.room_type_id, rt.type_name " +
                "FROM rooms r " +
                "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "WHERE r.room_type_id = ? " +
                "AND r.status = 'AVAILABLE' " +
                "AND r.is_active = 1 " +
                "AND r.room_id NOT IN (" +
                "   SELECT room_id FROM reservations " +
                "   WHERE status = 'ACTIVE' " +
                "   AND (check_in < ? AND check_out > ?)" +
                ") " +
                "ORDER BY r.room_number";

        try (java.sql.Connection con = com.ovr.util.DB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);
            ps.setString(2, checkOut);
            ps.setString(3, checkIn);

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.ovr.model.Room room = new com.ovr.model.Room();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setRoomNumber(rs.getString("room_number"));
                    room.setStatus(rs.getString("status"));
                    room.setIsActive(rs.getInt("is_active"));
                    room.setRoomTypeId(rs.getInt("room_type_id"));
                    room.setRoomTypeName(rs.getString("type_name"));
                    list.add(room);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}