package com.ovr.web;

import com.ovr.dao.UserDAO;
import com.ovr.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.findActiveByUsername(username.trim());
        if (user == null || !password.equals(user.getPasswordHash())) {
            req.setAttribute("error", "Invalid username or password.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        
        HttpSession session = req.getSession(true);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("role", user.getRole());
        session.setAttribute("fullName", user.getFullName());
        session.setAttribute("contactNo", user.getContactNo());

        String userPhone = user.getContactNo(); 
        String managerPhone = "94743729022";

        if (userPhone != null && userPhone.startsWith("0")) {
            userPhone = "94" + userPhone.substring(1);
        }

        if (userPhone != null && !userPhone.isEmpty()) {
            String time = new java.util.Date().toString();
            sendSMS(userPhone, "Login Alert: You logged in to Ocean View Resort System at " + time);
            sendSMS(managerPhone, "Admin Alert: " + user.getUsername() + " logged in to Ocean View Resort System at " + time);
        }

        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/adminDashboard.jsp");
        } else if ("RECEPTIONIST".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/receptionistDashboard.jsp");
        } else {
            session.invalidate();
            req.setAttribute("error", "User role not recognized.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private void sendSMS(String mobile, String message) {
        try {
            String apiToken = "3379|DgC3FO7zSxNcWyszhGAnK7sz0S0kpMrjrQp6Zp1Bc316e938";
            
            URL url = new URL("https://app.text.lk/api/v3/sms/send");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiToken);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            String jsonInputString = "{"
                    + "\"recipient\": \"" + mobile + "\","
                    + "\"sender_id\": \"TextLKDemo\","
                    + "\"message\": \"" + message + "\""
                    + "}";

            try(java.io.OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);           
            }

            int responseCode = conn.getResponseCode();
            System.out.println("Text.lk Response Code: " + responseCode);
            
            if (responseCode != 200) {
                java.io.BufferedReader br = new java.io.BufferedReader(
                    new java.io.InputStreamReader(conn.getErrorStream(), "utf-8"));
                StringBuilder response = new StringBuilder();
                String responseLine = null;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
                System.out.println("Error Detail: " + response.toString());
            }

            conn.disconnect();
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }
}