package com.ovr.dao;

import com.ovr.model.Reservation;
import com.ovr.util.DB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.ovr.model.ReservationView;
import java.sql.ResultSet;
import java.time.LocalDate;


public class ReservationDAO {

	public boolean saveReservation(Reservation r) {

	    String sql = "INSERT INTO reservations " +
	            "(reservation_no, guest_name, guest_address, guest_contact, room_id, check_in, check_out, status, created_by) " +
	            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

	    try (Connection con = DB.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, r.getReservationNo());
	        ps.setString(2, r.getGuestName());
	        ps.setString(3, r.getGuestAddress());
	        ps.setString(4, r.getGuestContact());
	        ps.setInt(5, r.getRoomId());
	        ps.setDate(6, java.sql.Date.valueOf(r.getCheckIn()));
	        ps.setDate(7, java.sql.Date.valueOf(r.getCheckOut()));
	        ps.setString(8, "ACTIVE");

	        // if createdBy not available, allow null
	        if (r.getCreatedBy() <= 0) {
	            ps.setNull(9, java.sql.Types.INTEGER);
	        } else {
	            ps.setInt(9, r.getCreatedBy());
	        }

	        return ps.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}

public ReservationView findByReservationNo(String reservationNo) {

    String sql =
        "SELECT res.reservation_id, res.reservation_no, res.guest_name, res.guest_address, res.guest_contact, " +
        "res.check_in, res.check_out, res.status, res.room_id, " +
        "r.room_number, rt.room_type_id, rt.type_name, rt.rate_per_night " +
        "FROM reservations res " +
        "JOIN rooms r ON res.room_id = r.room_id " +
        "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
        "WHERE res.reservation_no = ?";

    try (Connection con = DB.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, reservationNo);

        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) return null;

            ReservationView v = new ReservationView();
            v.setReservationId(rs.getInt("reservation_id"));
            v.setReservationNo(rs.getString("reservation_no"));
            v.setGuestName(rs.getString("guest_name"));
            v.setGuestAddress(rs.getString("guest_address"));
            v.setGuestContact(rs.getString("guest_contact"));
            v.setCheckIn(LocalDate.parse(rs.getString("check_in")));
            v.setCheckOut(LocalDate.parse(rs.getString("check_out")));
            v.setStatus(rs.getString("status"));
            v.setRoomId(rs.getInt("room_id"));
            v.setRoomNumber(rs.getString("room_number"));
            v.setRoomTypeId(rs.getInt("room_type_id"));
            v.setRoomTypeName(rs.getString("type_name"));
            v.setRatePerNight(rs.getDouble("rate_per_night"));
            return v;
        }

    } catch (Exception e) {
        e.printStackTrace();
        return null;
    }
}
    public boolean cancelReservation(String reservationNo) {

        String sql = "UPDATE reservations SET status='CANCELLED' " +
                     "WHERE reservation_no = ? AND status='ACTIVE'";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, reservationNo);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateReservation(String reservationNo, String guestName, String guestAddress,
        String guestContact, String checkIn, String checkOut) {

    	String sql = "UPDATE reservations SET guest_name=?, guest_address=?, guest_contact=?, check_in=?, check_out=? " +
    			"WHERE reservation_no=? AND status='ACTIVE'";

    	try (Connection con = DB.getConnection();
    			PreparedStatement ps = con.prepareStatement(sql)) {

    			ps.setString(1, guestName);
    			ps.setString(2, guestAddress);
    			ps.setString(3, guestContact);
    			ps.setString(4, checkIn);
    			ps.setString(5, checkOut);
    			ps.setString(6, reservationNo);

    			return ps.executeUpdate() > 0;

    	} catch (Exception e) {
    		e.printStackTrace();
    		return false;
    	}
    }
    public java.util.List<com.ovr.model.ReservationView> getReservationsByDateRange(String from, String to) {

        java.util.List<com.ovr.model.ReservationView> list = new java.util.ArrayList<>();

        String sql =
            "SELECT res.reservation_id, res.reservation_no, res.guest_name, res.guest_contact, " +
            "res.check_in, res.check_out, res.status, r.room_number, rt.type_name, rt.rate_per_night " +
            "FROM reservations res " +
            "JOIN rooms r ON res.room_id = r.room_id " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "WHERE res.check_in BETWEEN ? AND ? " +
            "ORDER BY res.check_in DESC";

        try (java.sql.Connection con = com.ovr.util.DB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, from);
            ps.setString(2, to);

            try (java.sql.ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    com.ovr.model.ReservationView v = new com.ovr.model.ReservationView();

                    v.setReservationId(rs.getInt("reservation_id"));
                    v.setReservationNo(rs.getString("reservation_no"));
                    v.setGuestName(rs.getString("guest_name"));
                    v.setGuestContact(rs.getString("guest_contact"));
                    v.setCheckIn(java.time.LocalDate.parse(rs.getString("check_in")));
                    v.setCheckOut(java.time.LocalDate.parse(rs.getString("check_out")));
                    v.setStatus(rs.getString("status"));
                    v.setRoomNumber(rs.getString("room_number"));
                    v.setRoomTypeName(rs.getString("type_name"));
                    v.setRatePerNight(rs.getDouble("rate_per_night"));

                    list.add(v);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public java.util.List<com.ovr.model.ReservationView> getLatestReservations(int limit) {

        java.util.List<com.ovr.model.ReservationView> list = new java.util.ArrayList<>();

        String sql =
            "SELECT res.reservation_id, res.reservation_no, res.guest_name, res.guest_contact, " +
            "res.check_in, res.check_out, res.status, r.room_number, rt.type_name, rt.rate_per_night " +
            "FROM reservations res " +
            "JOIN rooms r ON res.room_id = r.room_id " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "ORDER BY res.reservation_id DESC LIMIT ?";

        try (java.sql.Connection con = com.ovr.util.DB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.ovr.model.ReservationView v = new com.ovr.model.ReservationView();
                    v.setReservationId(rs.getInt("reservation_id"));
                    v.setReservationNo(rs.getString("reservation_no"));
                    v.setGuestName(rs.getString("guest_name"));
                    v.setGuestContact(rs.getString("guest_contact"));
                    v.setCheckIn(java.time.LocalDate.parse(rs.getString("check_in")));
                    v.setCheckOut(java.time.LocalDate.parse(rs.getString("check_out")));
                    v.setStatus(rs.getString("status"));
                    v.setRoomNumber(rs.getString("room_number"));
                    v.setRoomTypeName(rs.getString("type_name"));
                    v.setRatePerNight(rs.getDouble("rate_per_night"));
                    list.add(v);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
