package com.ovr.web;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);

        if (session != null) {

            String username = (String) session.getAttribute("username");
            String contactNo = (String) session.getAttribute("contactNo"); 
            String managerPhone = "94743729022";

            if (username != null) {
                String time = new java.util.Date().toString();
                String msg = "Logout Alert: User " + username + " logged out from OVR System at " + time;
                
                if (contactNo != null && !contactNo.isEmpty()) {
                    sendSMS(contactNo, "You have successfully logged out. Thank you!");
                }
                sendSMS(managerPhone, msg);
            }

            session.invalidate();
        }
        
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    private void sendSMS(String mobile, String message) {
        try {
            String apiToken = "3379|DgC3FO7zSxNcWyszhGAnK7sz0S0kpMrjrQp6Zp1Bc316e938";
            String senderId = "TextLKDemo"; 

            String urlString = "https://app.text.lk/api/v3/sms/send?recipient=" + mobile 
                             + "&sender_id=" + senderId
                             + "&body=" + URLEncoder.encode(message, "UTF-8")
                             + "&api_token=" + apiToken;

            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            System.out.println("Logout SMS sent to " + mobile + ". Status: " + conn.getResponseCode());
            conn.disconnect();
        } catch (Exception e) {
            System.out.println("Logout SMS failed: " + e.getMessage());
        }
    }
}