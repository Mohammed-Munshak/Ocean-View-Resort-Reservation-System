package com.ovr.web;

import com.ovr.dao.ReservationDAO;
import com.ovr.model.ReservationView;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet("/reservation/view")
public class ViewReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/login.jsp");
            return;
        }

        req.getRequestDispatcher("/Views/viewReservation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        // ---------------------------------------------------------
        // ACTION 1: SEARCH RESERVATION
        // ---------------------------------------------------------
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
            req.getRequestDispatcher("/Views/viewReservation.jsp").forward(req, resp);
            return;
        }


        if ("cancel".equals(action)) {
            String reservationNo = req.getParameter("reservationNo");
            boolean ok = reservationDAO.cancelReservation(reservationNo);

            if (ok) {
                req.setAttribute("success", "Reservation cancelled successfully.");
               
                ReservationView r = reservationDAO.findByReservationNo(reservationNo);
                req.setAttribute("reservation", r);

                if (r != null) {
                    String cancelMsg = "Ocean View Resort Alert: Dear " + r.getGuestName() + 
                                       ", your reservation " + r.getReservationNo() + 
                                       " for Room " + r.getRoomNumber() + " (" + r.getRoomTypeName() + ")" +
                                       " has been CANCELLED successfully. We hope to see you again. Contact: 091 58 96 789.";
                    
                    sendSMS(r.getGuestContact(), cancelMsg);
                }

            } else {
                req.setAttribute("error", "Cannot cancel. Reservation may not exist or already cancelled.");
            }

            req.getRequestDispatcher("/Views/viewReservation.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/reservation/view");
    }

    // ---------------------------------------------------------
    // HELPER METHOD: SEND SMS (Text.lk v3 API)
    // ---------------------------------------------------------
    private void sendSMS(String mobile, String message) {
        try {
            // Clean phone number format
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

            int responseCode = conn.getResponseCode();
            System.out.println("Cancellation SMS Sent to " + mobile + " | Status: " + responseCode);
            
            conn.disconnect();
        } catch (Exception e) {
            System.out.println("SMS Failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}