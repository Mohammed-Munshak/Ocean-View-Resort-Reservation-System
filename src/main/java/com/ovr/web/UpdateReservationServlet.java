package com.ovr.web;

import com.ovr.dao.ReservationDAO;
import com.ovr.model.ReservationView;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/reservation/update")
public class UpdateReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String reservationNo = req.getParameter("reservationNo");
        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/reservation/view");
            return;
        }

        ReservationView r = reservationDAO.findByReservationNo(reservationNo.trim());
        if (r == null) {
            req.setAttribute("error", "Reservation not found.");
            req.getRequestDispatcher("/viewReservation.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("reservation", r);
        req.getRequestDispatcher("/updateReservation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String reservationNo = req.getParameter("reservationNo");
        String guestName = req.getParameter("guestName");
        String guestAddress = req.getParameter("guestAddress");
        String guestContact = req.getParameter("guestContact");
        String checkIn = req.getParameter("checkIn");
        String checkOut = req.getParameter("checkOut");

        if (reservationNo == null || reservationNo.trim().isEmpty() ||
            guestName == null || guestName.trim().isEmpty() ||
            guestContact == null || guestContact.trim().isEmpty() ||
            checkIn == null || checkOut == null) {

            req.setAttribute("error", "Please fill required fields.");
            req.getRequestDispatcher("/updateReservation.jsp").forward(req, resp);
            return;
        }

        LocalDate in = LocalDate.parse(checkIn);
        LocalDate out = LocalDate.parse(checkOut);
        if (!out.isAfter(in)) {
            req.setAttribute("error", "Check-out must be after check-in.");
            req.getRequestDispatcher("/updateReservation.jsp").forward(req, resp);
            return;
        }

        boolean ok = reservationDAO.updateReservation(
                reservationNo.trim(),
                guestName.trim(),
                guestAddress == null ? "" : guestAddress.trim(),
                guestContact.trim(),
                checkIn,
                checkOut
        );

        ReservationView updated = reservationDAO.findByReservationNo(reservationNo.trim());
        req.setAttribute("reservation", updated);

        if (ok) {
            req.setAttribute("success", "Reservation updated successfully.");
        } else {
            req.setAttribute("error", "Update failed (maybe reservation is not ACTIVE).");
        }

        req.getRequestDispatcher("/updateReservation.jsp").forward(req, resp);
    }
}