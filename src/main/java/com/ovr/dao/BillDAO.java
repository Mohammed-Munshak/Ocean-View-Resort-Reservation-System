package com.ovr.dao;

import com.ovr.model.Bill;
import com.ovr.util.DB;

import java.sql.*;

public class BillDAO {

    public boolean billExistsForReservation(int reservationId) {
        String sql = "SELECT bill_id FROM bills WHERE reservation_id = ? LIMIT 1";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveBill(Bill b) {

        String sql = "INSERT INTO bills (reservation_id, nights, rate_per_night, total_amount) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, b.getReservationId());
            ps.setInt(2, b.getNights());
            ps.setDouble(3, b.getRatePerNight());
            ps.setDouble(4, b.getTotalAmount());

            int rows = ps.executeUpdate();
            if (rows == 0) return false;

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    b.setBillId(keys.getInt(1));
                }
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public double getRevenueByDateRange(String from, String to) {

        String sql = "SELECT SUM(total_amount) AS total FROM bills " +
                     "WHERE generated_date BETWEEN ? AND ?";

        try (java.sql.Connection con = com.ovr.util.DB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, from + " 00:00:00");
            ps.setString(2, to + " 23:59:59");

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0.0;
    }
    public com.ovr.model.Bill findLatestBillByReservationId(int reservationId) {

        String sql = "SELECT bill_id, reservation_id, nights, rate_per_night, total_amount, generated_at " +
                     "FROM bills WHERE reservation_id=? ORDER BY bill_id DESC LIMIT 1";

        try (java.sql.Connection con = com.ovr.util.DB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationId);

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                com.ovr.model.Bill b = new com.ovr.model.Bill();
                b.setBillId(rs.getInt("bill_id"));
                b.setReservationId(rs.getInt("reservation_id"));
                b.setNights(rs.getInt("nights"));
                b.setRatePerNight(rs.getDouble("rate_per_night"));
                b.setTotalAmount(rs.getDouble("total_amount"));
                b.setGeneratedAt(rs.getTimestamp("generated_at"));
                return b;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
