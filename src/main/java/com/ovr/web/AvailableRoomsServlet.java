package com.ovr.web;

import com.ovr.dao.RoomDAO;
import com.ovr.dao.RoomTypeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/reservation/available")
public class AvailableRoomsServlet extends HttpServlet {

    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String roomTypeIdStr = req.getParameter("roomTypeId");
        String checkIn = req.getParameter("checkIn");
        String checkOut = req.getParameter("checkOut");

        req.setAttribute("roomTypes", roomTypeDAO.getActiveRoomTypes());

        if (roomTypeIdStr != null && checkIn != null && checkOut != null &&
                !roomTypeIdStr.isEmpty() && !checkIn.isEmpty() && !checkOut.isEmpty()) {

            try {
                int roomTypeId = Integer.parseInt(roomTypeIdStr);
                req.setAttribute("availableRooms", roomDAO.getAvailableRooms(roomTypeId, checkIn, checkOut));
                req.setAttribute("selectedRoomTypeId", roomTypeId);
                req.setAttribute("selectedCheckIn", checkIn);
                req.setAttribute("selectedCheckOut", checkOut);
            } catch (Exception e) {
                req.setAttribute("error", "Invalid room type or dates.");
            }
        } else {
            req.setAttribute("error", "Please select room type and dates to see available rooms.");
        }

        req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
    }
}