package com.ovr.web;

import com.ovr.dao.BillDAO;
import com.ovr.dao.ReservationDAO;
import com.ovr.model.Bill;
import com.ovr.model.ReservationView;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.temporal.ChronoUnit;

@WebServlet("/bill/generate")
public class BillingServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final BillDAO billDAO = new BillDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/login.jsp");
            return;
        }

        req.getRequestDispatcher("/Views/billing.jsp").forward(req, resp);
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

        String reservationNo = req.getParameter("reservationNo");

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            req.setAttribute("error", "Please enter reservation number.");
            req.getRequestDispatcher("/Views/billing.jsp").forward(req, resp);
            return;
        }

        ReservationView r = reservationDAO.findByReservationNo(reservationNo.trim());

        if (r == null) {
            req.setAttribute("error", "Reservation not found.");
            req.getRequestDispatcher("/Views/billing.jsp").forward(req, resp);
            return;
        }

        if (!"ACTIVE".equalsIgnoreCase(r.getStatus()) && !"COMPLETED".equalsIgnoreCase(r.getStatus())) {
            req.setAttribute("error", "Reservation is cancelled. Cannot generate bill.");
            req.getRequestDispatcher("/Views/billing.jsp").forward(req, resp);
            return;
        }

        Bill existing = billDAO.findLatestBillByReservationId(r.getReservationId());
        
        if (existing != null) {
            req.setAttribute("bill", existing);
            req.setAttribute("reservation", r);
            req.setAttribute("info", "Bill already generated. Showing it again for re-print.");
            req.getRequestDispatcher("/Views/billDetails.jsp").forward(req, resp);
            return;
        }

        long nightsLong = ChronoUnit.DAYS.between(r.getCheckIn(), r.getCheckOut());
        int nights = (int) Math.max(nightsLong, 1);

        Bill b = new Bill();
        b.setReservationId(r.getReservationId());
        b.setNights(nights);
        b.setRatePerNight(r.getRatePerNight());
        b.setTotalAmount(nights * r.getRatePerNight());

        boolean saved = billDAO.saveBill(b);

        if (!saved) {
            req.setAttribute("error", "Failed to save bill.");
            req.getRequestDispatcher("/Views/billing.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("reservation", r);
        req.setAttribute("bill", b);
        req.getRequestDispatcher("/Views/billDetails.jsp").forward(req, resp);
    }
}