package com.ovr.web;

import com.ovr.dao.UserDAO;
import com.ovr.util.DB; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/admin/receptionists")
public class ManageReceptionistsServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/login.jsp");
            return;
        }

        req.setAttribute("receptionists", userDAO.getReceptionists());
        req.getRequestDispatcher("/Views/manageReceptionists.jsp").forward(req, resp);
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
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String fullName = req.getParameter("fullName");
            String contactNo = req.getParameter("contactNo");

            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                req.setAttribute("error", "Username and password are required.");
            } else if (userDAO.usernameExists(username.trim())) {
                req.setAttribute("error", "Username already exists.");
            } else {
                boolean ok = userDAO.addReceptionist(
                        username.trim(),
                        password.trim(),
                        fullName == null ? "" : fullName.trim(),
                        contactNo == null ? "" : contactNo.trim()
                );
                
                if (ok) {
                    String welcomeMsg = "Welcome to Ocean View Resort, Galle. Dear " + fullName + ", your Receptionist account is now created with username " + username + ". For assistance, please contact 091 58 96 789 or 091 62 36 894.";
                    sendSMS(contactNo, welcomeMsg);
                }
                
                req.setAttribute(ok ? "success" : "error", ok ? "Receptionist added." : "Failed to add receptionist.");
            }
        }

        if ("toggle".equals(action)) {
            try {
                int userId = Integer.parseInt(req.getParameter("userId"));
                int newActive = Integer.parseInt(req.getParameter("newActive")); 
                
                boolean ok = userDAO.setUserActive(userId, newActive);
                
                if (ok) {
                    String[] userInfo = getContactInfo(userId); 
                    String userPhone = userInfo[0];
                    String userName = userInfo[1];

                    if (userPhone != null && !userPhone.isEmpty()) {
                        
                        if (newActive == 0) {
                            String deactiveMsg = "Ocean View Resort Alert: Dear " + userName + ", your account has been DEACTIVATED by the Administrator. Please contact the office at 091 58 96 789 or 091 62 36 894 for more details.";
                            sendSMS(userPhone, deactiveMsg);
                            
                        } else if (newActive == 1) {
                            String reactiveMsg = "Welcome back to Ocean View Resort, " + userName + ". We apologize for the interruption. Your account is now ACTIVE again. You may login immediately.";
                            sendSMS(userPhone, reactiveMsg);
                        }
                    }
                }
                req.setAttribute(ok ? "success" : "error", ok ? "Status updated." : "Failed to update status.");
            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("error", "Invalid data.");
            }
        }

        req.setAttribute("receptionists", userDAO.getReceptionists());
        req.getRequestDispatcher("/Views/manageReceptionists.jsp").forward(req, resp);
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
            int responseCode = conn.getResponseCode();
            System.out.println("SMS Sent to " + mobile + " | Status: " + responseCode);
            conn.disconnect();
        } catch (Exception e) {
            System.out.println("SMS Failed: " + e.getMessage());
        }
    }

    private String[] getContactInfo(int userId) {
        String[] info = {null, "User"}; 
        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT contact_no, full_name FROM users WHERE user_id=?")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    info[0] = rs.getString("contact_no");
                    info[1] = rs.getString("full_name");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return info;
    }
}