package com.ovr.web;

import com.ovr.dao.ReservationDAO;
import com.ovr.dao.RoomDAO;
import com.ovr.dao.RoomTypeDAO;
import com.ovr.model.Reservation;
import com.ovr.model.ReservationView; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.util.UUID;

@WebServlet("/reservation/add")
public class ReservationServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        Integer userIdObj = (Integer) session.getAttribute("userId");
        int createdBy = (userIdObj != null) ? userIdObj : 0;

        String guestName = req.getParameter("guestName");
        String guestAddress = req.getParameter("guestAddress");
        String guestContact = req.getParameter("guestContact");
        String roomTypeIdStr = req.getParameter("roomTypeId");
        String checkInStr = req.getParameter("checkIn");
        String checkOutStr = req.getParameter("checkOut");
        
        if (guestName == null || guestName.isEmpty() || 
            guestContact == null || guestContact.isEmpty() ||
            roomTypeIdStr == null || checkInStr == null || checkOutStr == null) {
            
            req.setAttribute("error", "Required fields missing.");
            req.setAttribute("roomTypes", roomTypeDAO.getActiveRoomTypes());
            req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
            return;
        }

        int roomTypeId = Integer.parseInt(roomTypeIdStr);
        LocalDate checkIn = LocalDate.parse(checkInStr);
        LocalDate checkOut = LocalDate.parse(checkOutStr);

        if (!checkOut.isAfter(checkIn)) {
            req.setAttribute("error", "Check-out must be after check-in.");
            req.setAttribute("roomTypes", roomTypeDAO.getActiveRoomTypes());
            req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
            return;
        }
        
        String roomIdStr = req.getParameter("roomId");
        Integer roomId;

        if (roomIdStr != null && !roomIdStr.trim().isEmpty()) {
            roomId = Integer.parseInt(roomIdStr);
        } else {
            roomId = roomDAO.findAvailableRoom(roomTypeId, checkInStr, checkOutStr);
        }

        if (roomId == null) {
            req.setAttribute("error", "No rooms available for selected dates.");
            req.setAttribute("roomTypes", roomTypeDAO.getActiveRoomTypes());
            req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
            return;
        }

        Reservation r = new Reservation();
        String resNo = "RES-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase(); // Generate ID
        r.setReservationNo(resNo);
        r.setGuestName(guestName);
        r.setGuestAddress(guestAddress);
        r.setGuestContact(guestContact);
        r.setRoomId(roomId);
        r.setCheckIn(checkIn);
        r.setCheckOut(checkOut);
        r.setCreatedBy(createdBy);

        boolean saved = reservationDAO.saveReservation(r);

        if (saved) {
            ReservationView fullDetails = reservationDAO.findByReservationNo(resNo);

            if (fullDetails != null) {
                String smsMessage = "Ocean View Resort Reservation Confirmed! " +
                                    "Dear " + fullDetails.getGuestName() + ", " +
                                    "Ref: " + fullDetails.getReservationNo() + ". " +
                                    "Room: " + fullDetails.getRoomNumber() + " (" + fullDetails.getRoomTypeName() + "). " +
                                    "Contact: 091 58 96 789 / 091 62 36 894.";
                
                sendSMS(fullDetails.getGuestContact(), smsMessage);
            }
            
            req.setAttribute("success", "Reservation created successfully! SMS Sent to guest.");
        } else {
            req.setAttribute("error", "Failed to save reservation.");
        }

        req.setAttribute("roomTypes", roomTypeDAO.getActiveRoomTypes());
        req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
    }

    private void sendSMS(String mobile, String message) {
        try {
            if (mobile != null) {
                mobile = mobile.trim().replaceAll("\\s+", "");
                if (mobile.startsWith("0")) mobile = "94" + mobile.substring(1);
            }

            String apiToken = "3379|DgC3FO7zSxNcWyszhGAnK7sz0S0kpMrjrQp6Zp1Bc316e938"; 
            URL url = new URL("https://app.text.lk/api/v3/sms/send");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiToken);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String jsonInputString = "{"
                    + "\"recipient\": \"" + mobile + "\","
                    + "\"sender_id\": \"TextLKDemo\"," 
                    + "\"message\": \"" + message + "\""
                    + "}";

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            System.out.println("Reservation SMS sent to " + mobile + " | Status: " + conn.getResponseCode());
            conn.disconnect();
        } catch (Exception e) {
            System.out.println("SMS Failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}