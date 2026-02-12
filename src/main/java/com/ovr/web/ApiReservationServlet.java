package com.ovr.web;

import com.ovr.dao.ReservationDAO;
import com.ovr.model.ReservationView;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/reservation")
public class ApiReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String reservationNo = req.getParameter("no");

        PrintWriter out = resp.getWriter();

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            out.print("{\"error\":\"Reservation number required\"}");
            return;
        }

        ReservationView r = reservationDAO.findByReservationNo(reservationNo.trim());

        if (r == null) {
            out.print("{\"error\":\"Reservation not found\"}");
            return;
        }

        String json = "{"
                + "\"reservationNo\":\"" + r.getReservationNo() + "\","
                + "\"guestName\":\"" + r.getGuestName() + "\","
                + "\"guestContact\":\"" + r.getGuestContact() + "\","
                + "\"roomNumber\":\"" + r.getRoomNumber() + "\","
                + "\"roomType\":\"" + r.getRoomTypeName() + "\","
                + "\"checkIn\":\"" + r.getCheckIn() + "\","
                + "\"checkOut\":\"" + r.getCheckOut() + "\","
                + "\"status\":\"" + r.getStatus() + "\""
                + "}";

        out.print(json);
    }
}