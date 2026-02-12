package com.ovr.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Bill {
    private int billId;
    private int reservationId;
    private int nights;
    private double ratePerNight;
    private double totalAmount;
    private LocalDateTime generatedAt;

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getReservationId() { return reservationId; }
    public void setReservationId(int reservationId) { this.reservationId = reservationId; }

    public int getNights() { return nights; }
    public void setNights(int nights) { this.nights = nights; }

    public double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(double ratePerNight) { this.ratePerNight = ratePerNight; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public LocalDateTime getGeneratedAt() { return generatedAt; }
    public void setGeneratedAt(LocalDateTime timestamp) { this.generatedAt = timestamp; }
	public void setGeneratedAt(Timestamp timestamp) {
		// TODO Auto-generated method stub
		
	}
}
