package com.ovr.web;

import com.ovr.model.ReservationView;
import com.ovr.util.DB;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/reports")
public class ReportsServlet extends HttpServlet {

    private boolean adminOnly(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!adminOnly(req, resp)) return;

        // Just open page (no results yet)
        req.getRequestDispatcher("/reports.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!adminOnly(req, resp)) return;

        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");

        if (fromDate == null || toDate == null || fromDate.isEmpty() || toDate.isEmpty()) {
            req.setAttribute("error", "Please select both From and To dates.");
            req.getRequestDispatcher("/reports.jsp").forward(req, resp);
            return;
        }

        // 1) Reservation list for the period (by check_in)
        List<ReservationView> reservations = new ArrayList<>();

        String sqlReservations =
                "SELECT res.reservation_id, res.reservation_no, res.guest_name, res.guest_contact, " +
                "res.check_in, res.status, r.room_number, rt.type_name " +
                "FROM reservations res " +
                "JOIN rooms r ON res.room_id = r.room_id " +
                "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                "WHERE res.check_in BETWEEN ? AND ? " +
                "ORDER BY res.check_in DESC";

        // 2) Revenue for the period (by bill generated_at date)
        String sqlRevenue =
                "SELECT COALESCE(SUM(total_amount),0) AS revenue " +
                "FROM bills " +
                "WHERE DATE(generated_at) BETWEEN ? AND ?";

        try (Connection con = DB.getConnection()) {

            // reservations
            try (PreparedStatement ps = con.prepareStatement(sqlReservations)) {
                ps.setString(1, fromDate);
                ps.setString(2, toDate);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        ReservationView v = new ReservationView();
                        v.setReservationId(rs.getInt("reservation_id"));
                        v.setReservationNo(rs.getString("reservation_no"));
                        v.setGuestName(rs.getString("guest_name"));
                        v.setGuestContact(rs.getString("guest_contact"));
                        v.setCheckIn(java.time.LocalDate.parse(rs.getString("check_in")));
                        v.setStatus(rs.getString("status"));
                        v.setRoomNumber(rs.getString("room_number"));
                        v.setRoomTypeName(rs.getString("type_name"));
                        reservations.add(v);
                    }
                }
            }

            // revenue
            double revenue = 0.0;
            try (PreparedStatement ps = con.prepareStatement(sqlRevenue)) {
                ps.setString(1, fromDate);
                ps.setString(2, toDate);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) revenue = rs.getDouble("revenue");
                }
            }

            req.setAttribute("reservations", reservations);
            req.setAttribute("revenue", revenue);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to generate report. Check server console for details.");
        }

        req.getRequestDispatcher("/reports.jsp").forward(req, resp);
    }
}