package com.ovr.model;

public class RoomType {
    private int roomTypeId;
    private String typeName;
    private double ratePerNight;
    private String description;
    private int isActive;

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public double getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(double ratePerNight) { this.ratePerNight = ratePerNight; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getIsActive() { return isActive; }
    public void setIsActive(int isActive) { this.isActive = isActive; }
}
