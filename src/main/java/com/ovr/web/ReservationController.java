package com.ovr.web;

import com.ovr.dao.RoomDAO;
import com.ovr.dao.RoomTypeDAO;
import com.ovr.dao.ReservationDAO;
import com.ovr.model.Room;
import com.ovr.model.Reservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@WebServlet("/reservation/*")
public class ReservationController extends HttpServlet {

    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    private boolean receptionistOnly(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/Views/login.jsp");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!receptionistOnly(req, resp)) return;

        String path = req.getPathInfo();
        if (path == null) path = "/new";

        switch (path) {
            case "/new":
                req.setAttribute("roomTypes", roomTypeDAO.getActiveRoomTypes());
                req.getRequestDispatcher("/Views/addReservation.jsp").forward(req, resp);
                break;

            case "/list":
                req.setAttribute("reservations", reservationDAO.getLatestReservations(100));
                req.getRequestDispatcher("/Views/listReservations.jsp").forward(req, resp);
                break;

            case "/view":
                req.getRequestDispatcher("/Views/viewReservation.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/reservation/new");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!receptionistOnly(req, resp)) return;

        String path = req.getPathInfo();
        if (path == null) path = "/new";

        req.setAttribute("roomTypes", roomTypeDAO.getActiveRoomTypes());

        if ("/available".equals(path)) {
            String roomTypeIdStr = req.getParameter("roomTypeId");
            String checkIn = req.getParameter("checkIn");
            String checkOut = req.getParameter("checkOut");

            try {
                int roomTypeId = Integer.parseInt(roomTypeIdStr);
                List<Room> rooms = roomDAO.getAvailableRooms(roomTypeId, checkIn, checkOut);

                req.setAttribute("availableRooms", rooms);
                req.setAttribute("selectedRoomTypeId", roomTypeId);
                req.setAttribute("selectedCheckIn", checkIn);
                req.setAttribute("selectedCheckOut", checkOut);

            } catch (Exception e) {
                req.setAttribute("error", "Please select valid room type and dates.");
            }

            req.getRequestDispatcher("/Views/addReservation.jsp").forward(req, resp);
            return;
        }

        if ("/add".equals(path)) {
            HttpSession session = req.getSession(false);
            int createdBy = (int) session.getAttribute("userId");

            String guestName = req.getParameter("guestName");
            String guestAddress = req.getParameter("guestAddress");
            String guestContact = req.getParameter("guestContact");

            String roomIdStr = req.getParameter("roomId");
            String checkInStr = req.getParameter("checkIn");
            String checkOutStr = req.getParameter("checkOut");

            if (guestName == null || guestName.trim().isEmpty() ||
                guestContact == null || guestContact.trim().isEmpty()) {
                req.setAttribute("error", "Guest Name and Contact are required.");
                req.getRequestDispatcher("/Views/addReservation.jsp").forward(req, resp);
                return;
            }

            if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
                req.setAttribute("error", "Please select an available room.");
                req.getRequestDispatcher("/Views/addReservation.jsp").forward(req, resp);
                return;
            }

            LocalDate checkIn = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);

            if (!checkOut.isAfter(checkIn)) {
                req.setAttribute("error", "Check-out must be after check-in.");
                req.getRequestDispatcher("/Views/addReservation.jsp").forward(req, resp);
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);

            Reservation r = new Reservation();
            r.setReservationNo("RES" + UUID.randomUUID().toString().replace("-", "").substring(0, 7));
            r.setGuestName(guestName.trim());
            r.setGuestAddress(guestAddress == null ? "" : guestAddress.trim());
            r.setGuestContact(guestContact.trim());
            r.setRoomId(roomId);
            r.setCheckIn(checkIn);
            r.setCheckOut(checkOut);
            r.setStatus("ACTIVE"); // IMPORTANT
            r.setCreatedBy(createdBy);

            boolean saved = reservationDAO.saveReservation(r);

            if (saved) {
                req.setAttribute("success", "Reservation created: " + r.getReservationNo());
            } else {
                req.setAttribute("error", "Failed to save reservation. Check console for SQL error.");
            }

            req.getRequestDispatcher("/Views/addReservation.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/reservation/new");
    }
}