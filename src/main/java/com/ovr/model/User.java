package com.ovr.model;

public class User {
    private int userId;
    private String username;
    private String passwordHash;   // currently plain text in your DB
    private String role;           // ADMIN or RECEPTIONIST
    private String fullName;
    private String contactNo;
    private boolean isActive;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getContactNo() { return contactNo; }
    public void setContactNo(String contactNo) { this.contactNo = contactNo; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
