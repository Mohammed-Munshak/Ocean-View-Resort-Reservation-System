package com.ovr.web;

import com.ovr.dao.RoomTypeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/reservation/new")
public class AddReservationPageServlet extends HttpServlet {

    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/login.jsp");
            return;
        }

        req.setAttribute("roomTypes", new com.ovr.dao.RoomTypeDAO().getActiveRoomTypes());
        req.getRequestDispatcher("/Views/addReservation.jsp").forward(req, resp);
    }
}
