package com.ovr.web;

import com.ovr.dao.ReservationDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;

@WebServlet("/reservation/list")
public class ListReservationsServlet extends HttpServlet {

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

        req.setAttribute("reservations", reservationDAO.getLatestReservations(100));
        req.getRequestDispatcher("/listReservations.jsp").forward(req, resp);
    }
}