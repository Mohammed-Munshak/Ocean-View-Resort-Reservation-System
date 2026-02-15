package com.ovr.web;

import com.ovr.dao.RoomTypeDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/roomtypes")
public class ManageRoomTypesServlet extends HttpServlet {

    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/login.jsp");
            return;
        }

        req.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
        req.getRequestDispatcher("/Views/manageRoomTypes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            String typeName = req.getParameter("typeName");
            String description = req.getParameter("description");
            String rateStr = req.getParameter("ratePerNight");

            try {
                double rate = Double.parseDouble(rateStr);
                boolean ok = roomTypeDAO.addRoomType(typeName.trim(), rate, description == null ? "" : description.trim());
                req.setAttribute(ok ? "success" : "error", ok ? "Room type added." : "Failed to add room type.");
            } catch (Exception e) {
                req.setAttribute("error", "Invalid rate value.");
            }
        }

        if ("updateRate".equals(action)) {
            try {
                int roomTypeId = Integer.parseInt(req.getParameter("roomTypeId"));
                double newRate = Double.parseDouble(req.getParameter("newRate"));
                boolean ok = roomTypeDAO.updateRate(roomTypeId, newRate);
                req.setAttribute(ok ? "success" : "error", ok ? "Rate updated." : "Failed to update rate.");
            } catch (Exception e) {
                req.setAttribute("error", "Invalid input for rate update.");
            }
        }

        if ("toggle".equals(action)) {
            try {
                int roomTypeId = Integer.parseInt(req.getParameter("roomTypeId"));
                int newActive = Integer.parseInt(req.getParameter("newActive")); // 1 or 0
                boolean ok = roomTypeDAO.setActive(roomTypeId, newActive);
                req.setAttribute(ok ? "success" : "error", ok ? "Status updated." : "Failed to update status.");
            } catch (Exception e) {
                req.setAttribute("error", "Invalid input for status update.");
            }
        }

        req.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
        req.getRequestDispatcher("/Views/manageRoomTypes.jsp").forward(req, resp);
    }
}