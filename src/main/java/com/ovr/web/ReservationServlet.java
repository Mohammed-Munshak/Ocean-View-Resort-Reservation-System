package com.ovr.web;

import com.ovr.dao.ReservationDAO;
import com.ovr.dao.RoomDAO;
import com.ovr.model.Reservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.UUID;

@WebServlet("/reservation/add")
public class ReservationServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	
    	HttpSession session = req.getSession(false);
    	if (session == null || session.getAttribute("role") == null ||
    	        !"RECEPTIONIST".equalsIgnoreCase((String) session.getAttribute("role"))) {
    	    resp.sendRedirect(req.getContextPath() + "/login.jsp");
    	    return;
    	}
    	int createdBy = (int) session.getAttribute("userId");


        String guestName = req.getParameter("guestName");
        String guestAddress = req.getParameter("guestAddress");
        String guestContact = req.getParameter("guestContact");
        int roomTypeId = Integer.parseInt(req.getParameter("roomTypeId"));
        String checkInStr = req.getParameter("checkIn");
        String checkOutStr = req.getParameter("checkOut");
        
        if (guestName.isEmpty() || guestContact.isEmpty()) {
            req.setAttribute("error", "Required fields missing.");
            req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
            return;
        }

        LocalDate checkIn = LocalDate.parse(checkInStr);
        LocalDate checkOut = LocalDate.parse(checkOutStr);

        if (!checkOut.isAfter(checkIn)) {
            req.setAttribute("error", "Check-out must be after check-in.");
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
            req.setAttribute("roomTypes", new com.ovr.dao.RoomTypeDAO().getActiveRoomTypes());
            req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
            return;
        }

        Reservation r = new Reservation();
        r.setReservationNo("RES-" + UUID.randomUUID().toString().substring(0, 8));
        r.setGuestName(guestName);
        r.setGuestAddress(guestAddress);
        r.setGuestContact(guestContact);
		r.setRoomId(roomId);
        r.setCheckIn(checkIn);
        r.setCheckOut(checkOut);
        r.setCreatedBy(createdBy);


        boolean saved = reservationDAO.saveReservation(r);

        if (saved) {
            req.setAttribute("success", "Reservation created: " + r.getReservationNo());
        } else {
            req.setAttribute("error", "Failed to save reservation.");
        }

        req.setAttribute("roomTypes", new com.ovr.dao.RoomTypeDAO().getActiveRoomTypes());
        req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);

    }
}
