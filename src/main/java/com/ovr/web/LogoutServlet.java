package com.ovr.web;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);

        if (session != null) {
            String username = (String) session.getAttribute("username");
            String contactNo = (String) session.getAttribute("contactNo");
            String managerPhone = "94743729022";

            SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
            String logoutTime = timeFormat.format(new Date());

            String userMsg = "Ocean View Resort: You have successfully logged out at " + logoutTime + ".";
            String adminMsg = "Ocean View Resort Alert: User " + username + " logged out at " + logoutTime + ".";

            if (contactNo != null && contactNo.startsWith("0")) {
                contactNo = "94" + contactNo.substring(1);
            }

            if (contactNo != null && !contactNo.isEmpty()) {
                sendSMS(contactNo, userMsg);
            }
            sendSMS(managerPhone, adminMsg);

            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/Views/login.jsp");
    }

    private void sendSMS(String mobile, String message) {
        try {
            String apiToken = "3379|DgC3FO7zSxNcWyszhGAnK7sz0S0kpMrjrQp6Zp1Bc316e938";
            URL url = new URL("https://app.text.lk/api/v3/sms/send");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiToken);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String jsonInputString = "{"
                    + "\"recipient\": \"" + mobile + "\","
                    + "\"sender_id\": \"OceanViewLK\","
                    + "\"message\": \"" + message + "\""
                    + "}";

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonInputString.getBytes("utf-8"));
            }

            System.out.println("Logout SMS for " + mobile + ": " + conn.getResponseCode());
            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}