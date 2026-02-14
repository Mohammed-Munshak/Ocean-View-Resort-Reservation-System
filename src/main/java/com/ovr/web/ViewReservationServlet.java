package com.ovr.web;

import com.ovr.dao.ReservationDAO;
import com.ovr.model.ReservationView;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/reservation/view")
public class ViewReservationServlet extends HttpServlet {

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

        req.getRequestDispatcher("/viewReservation.jsp").forward(req, resp);
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

        String action = req.getParameter("action");

        if ("search".equals(action)) {
            String reservationNo = req.getParameter("reservationNo");
            if (reservationNo == null || reservationNo.trim().isEmpty()) {
                req.setAttribute("error", "Please enter reservation number.");
            } else {
                ReservationView r = reservationDAO.findByReservationNo(reservationNo.trim());
                if (r == null) {
                    req.setAttribute("error", "Reservation not found.");
                } else {
                    req.setAttribute("reservation", r);
                }
            }
            req.getRequestDispatcher("/viewReservation.jsp").forward(req, resp);
            return;
        }

        if ("cancel".equals(action)) {
            String reservationNo = req.getParameter("reservationNo");
            boolean ok = reservationDAO.cancelReservation(reservationNo);

            if (ok) {
                req.setAttribute("success", "Reservation cancelled successfully.");
                ReservationView r = reservationDAO.findByReservationNo(reservationNo);
                req.setAttribute("reservation", r);
            } else {
                req.setAttribute("error", "Cannot cancel. Reservation may not exist or already cancelled.");
            }

            req.getRequestDispatcher("/viewReservation.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/reservation/view");
    }
}
