package com.ovr.web;

import com.ovr.dao.RoomDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/rooms")
public class ApiRoomsServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String roomTypeStr = req.getParameter("roomTypeId");
        String checkIn = req.getParameter("checkIn");
        String checkOut = req.getParameter("checkOut");

        PrintWriter out = resp.getWriter();

        if (roomTypeStr == null || checkIn == null || checkOut == null) {
            out.print("{\"error\":\"Missing parameters\"}");
            return;
        }

        try {
            int roomTypeId = Integer.parseInt(roomTypeStr);

            List<Integer> rooms =
                    roomDAO.getAvailableRoomIds(roomTypeId, checkIn, checkOut);

            StringBuilder json = new StringBuilder();
            json.append("{\"availableRooms\":[");

            for (int i = 0; i < rooms.size(); i++) {
                json.append(rooms.get(i));
                if (i < rooms.size() - 1) json.append(",");
            }

            json.append("]}");

            out.print(json.toString());

        } catch (Exception e) {
            out.print("{\"error\":\"Invalid parameters\"}");
        }
    }
}