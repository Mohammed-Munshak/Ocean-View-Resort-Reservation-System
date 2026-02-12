package com.ovr.dao;

import com.ovr.model.User;
import java.util.ArrayList;
import java.util.List;
import com.ovr.util.DB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    // ✅ matches your sequence diagram: SELECT user by username and active=1
    public User findActiveByUsername(String username) {
        String sql = "SELECT user_id, username, password_hash, role, full_name, contact_no, is_active " +
                     "FROM users WHERE username = ? AND is_active = 1";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setRole(rs.getString("role"));
                u.setFullName(rs.getString("full_name"));
                u.setContactNo(rs.getString("contact_no"));
                u.setActive(rs.getInt("is_active") == 1);
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<User> getReceptionists() {
        List<User> list = new ArrayList<>();

        String sql = "SELECT user_id, username, role, full_name, contact_no, is_active " +
                     "FROM users WHERE role='RECEPTIONIST' ORDER BY user_id DESC";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setRole(rs.getString("role"));
                u.setFullName(rs.getString("full_name"));
                u.setContactNo(rs.getString("contact_no"));
                u.setActive(rs.getInt("is_active") == 1);
                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean usernameExists(String username) {
        String sql = "SELECT user_id FROM users WHERE username=? LIMIT 1";
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return true; // safe default
        }
    }

    public boolean addReceptionist(String username, String passwordPlain, String fullName, String contactNo) {
        String sql = "INSERT INTO users (username, password_hash, role, full_name, contact_no, is_active) " +
                     "VALUES (?, ?, 'RECEPTIONIST', ?, ?, 1)";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, passwordPlain); // plain text for now (same as your existing users)
            ps.setString(3, fullName);
            ps.setString(4, contactNo);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setUserActive(int userId, int isActive) {
        String sql = "UPDATE users SET is_active=? WHERE user_id=? AND role='RECEPTIONIST'";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, isActive);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
