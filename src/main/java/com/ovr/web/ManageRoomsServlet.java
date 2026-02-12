package com.ovr.web;

import com.ovr.dao.RoomDAO;
import com.ovr.dao.RoomTypeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/rooms")
public class ManageRoomsServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        req.setAttribute("rooms", roomDAO.getAllRooms());
        req.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
        req.getRequestDispatcher("/manageRooms.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            String roomNumber = req.getParameter("roomNumber");
            String roomTypeIdStr = req.getParameter("roomTypeId");

            try {
                int roomTypeId = Integer.parseInt(roomTypeIdStr);
                boolean ok = roomDAO.addRoom(roomNumber.trim(), roomTypeId);
                req.setAttribute(ok ? "success" : "error", ok ? "Room added." : "Failed to add room.");
            } catch (Exception e) {
                req.setAttribute("error", "Invalid room data.");
            }
        }

        if ("toggle".equals(action)) {
            try {
                int roomId = Integer.parseInt(req.getParameter("roomId"));
                int newActive = Integer.parseInt(req.getParameter("newActive"));
                boolean ok = roomDAO.setRoomActive(roomId, newActive);
                req.setAttribute(ok ? "success" : "error", ok ? "Room active status updated." : "Failed to update status.");
            } catch (Exception e) {
                req.setAttribute("error", "Invalid toggle data.");
            }
        }

        if ("status".equals(action)) {
            try {
                int roomId = Integer.parseInt(req.getParameter("roomId"));
                String status = req.getParameter("status");
                boolean ok = roomDAO.updateRoomStatus(roomId, status);
                req.setAttribute(ok ? "success" : "error", ok ? "Room status updated." : "Failed to update room status.");
            } catch (Exception e) {
                req.setAttribute("error", "Invalid status update.");
            }
        }

        // reload page data
        req.setAttribute("rooms", roomDAO.getAllRooms());
        req.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
        req.getRequestDispatcher("/manageRooms.jsp").forward(req, resp);
    }
}