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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // basic validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.findActiveByUsername(username.trim());

        // ✅ Because your DB currently stores plain text (admin123 etc.)
        if (user == null || !password.equals(user.getPasswordHash())) {
            req.setAttribute("error", "Invalid username or password.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // create session
        HttpSession session = req.getSession(true);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("role", user.getRole());
        session.setAttribute("fullName", user.getFullName());

        // redirect based on role
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/adminDashboard.jsp");
        } else if ("RECEPTIONIST".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/receptionistDashboard.jsp");
        } else {
            // fallback
            session.invalidate();
            req.setAttribute("error", "User role not recognized.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
