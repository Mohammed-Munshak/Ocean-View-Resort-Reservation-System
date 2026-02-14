package com.ovr.dao;

import com.ovr.model.RoomType;
import com.ovr.util.DB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDAO {

    public List<RoomType> getActiveRoomTypes() {
        List<RoomType> list = new ArrayList<>();

        String sql = "SELECT room_type_id, type_name, rate_per_night, description, is_active " +
                "FROM room_types WHERE is_active = 1 ORDER BY type_name";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setRoomTypeId(rs.getInt("room_type_id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setRatePerNight(rs.getDouble("rate_per_night"));
                rt.setDescription(rs.getString("description"));
                rt.setIsActive(rs.getInt("is_active"));
                list.add(rt);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public boolean addRoomType(String typeName, double ratePerNight, String description) {
        String sql = "INSERT INTO room_types (type_name, rate_per_night, description, is_active) VALUES (?, ?, ?, 1)";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, typeName);
            ps.setDouble(2, ratePerNight);
            ps.setString(3, description);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateRate(int roomTypeId, double newRate) {
        String sql = "UPDATE room_types SET rate_per_night=? WHERE room_type_id=?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDouble(1, newRate);
            ps.setInt(2, roomTypeId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setActive(int roomTypeId, int isActive) {
        String sql = "UPDATE room_types SET is_active=? WHERE room_type_id=?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, isActive);
            ps.setInt(2, roomTypeId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public java.util.List<com.ovr.model.RoomType> getAllRoomTypes() {
        java.util.List<com.ovr.model.RoomType> list = new java.util.ArrayList<>();

        String sql = "SELECT room_type_id, type_name, rate_per_night, description, is_active " +
                     "FROM room_types ORDER BY room_type_id DESC";

        try (java.sql.Connection con = com.ovr.util.DB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql);
             java.sql.ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                com.ovr.model.RoomType rt = new com.ovr.model.RoomType();
                rt.setRoomTypeId(rs.getInt("room_type_id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setRatePerNight(rs.getDouble("rate_per_night"));
                rt.setDescription(rs.getString("description"));
                rt.setIsActive(rs.getInt("is_active"));    
                list.add(rt);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
