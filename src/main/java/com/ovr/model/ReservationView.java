package com.ovr.model;

import java.time.LocalDate;

public class ReservationView {
    private int reservationId;
    private String reservationNo;
    private String guestName;
    private String guestAddress;
    private String guestContact;
    private LocalDate checkIn;
    private LocalDate checkOut;
    private String status;

    private int roomId;
    private String roomNumber;
    private int roomTypeId;
    private String roomTypeName;
    private double ratePerNight;

    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }

    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getGuestAddress() { return guestAddress; }
    public void setGuestAddress(String guestAddress) { this.guestAddress = guestAddress; }

    public String getGuestContact() { return guestContact; }
    public void setGuestContact(String guestContact) { this.guestContact = guestContact; }

    public LocalDate getCheckIn() { return checkIn; }
    public void setCheckIn(LocalDate checkIn) { this.checkIn = checkIn; }

    public LocalDate getCheckOut() { return checkOut; }
    public void setCheckOut(LocalDate checkOut) { this.checkOut = checkOut; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(double ratePerNight) { this.ratePerNight = ratePerNight; }
}
