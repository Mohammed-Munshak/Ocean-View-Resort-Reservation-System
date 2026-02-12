package com.ovr.web;

import com.ovr.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/receptionists")
public class ManageReceptionistsServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        req.setAttribute("receptionists", userDAO.getReceptionists());
        req.getRequestDispatcher("/manageReceptionists.jsp").forward(req, resp);
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
                req.setAttribute(ok ? "success" : "error", ok ? "Receptionist added." : "Failed to add receptionist.");
            }
        }

        if ("toggle".equals(action)) {
            try {
                int userId = Integer.parseInt(req.getParameter("userId"));
                int newActive = Integer.parseInt(req.getParameter("newActive"));
                boolean ok = userDAO.setUserActive(userId, newActive);
                req.setAttribute(ok ? "success" : "error", ok ? "Receptionist status updated." : "Failed to update status.");
            } catch (Exception e) {
                req.setAttribute("error", "Invalid toggle data.");
            }
        }

        req.setAttribute("receptionists", userDAO.getReceptionists());
        req.getRequestDispatcher("/manageReceptionists.jsp").forward(req, resp);
    }
}