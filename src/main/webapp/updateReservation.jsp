<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ovr.model.ReservationView" %>

<%
  // --- BACKEND LOGIC PRESERVED ---
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  ReservationView r = (ReservationView) request.getAttribute("reservation");
  String error = (String) request.getAttribute("error");
  String success = (String) request.getAttribute("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Reservation | Ocean View Resort</title>
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    /* --- THEME --- */
    :root {
      --primary-gradient: linear-gradient(135deg, #8D6E63 0%, #6D4C41 100%);
      --bg-color: #F4F1EA;
      --card-bg: #FFFFFF;
      --text-main: #3E2723;
      --border-color: #D7CCC8;
      --read-only-bg: #EFEBE9;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: var(--bg-color);
      color: var(--text-main);
      margin: 0;
      padding: 40px 20px;
      display: flex;
      justify-content: center;
      min-height: 100vh;
    }

    .container {
      width: 100%;
      max-width: 800px;
      animation: slideUp 0.6s ease-out;
    }

    .card {
      background: var(--card-bg);
      border-radius: 12px;
      padding: 40px;
      box-shadow: 0 10px 30px rgba(141, 110, 99, 0.15);
      border-top: 5px solid #8D6E63;
    }

    /* --- HEADER --- */
    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      border-bottom: 1px solid #eee;
      padding-bottom: 15px;
    }

    h2 {
      margin: 0;
      font-family: 'Times New Roman', serif;
      font-size: 28px;
      color: var(--text-main);
    }

    /* --- SUMMARY BOX (Static Info) --- */
    .summary-box {
      background-color: var(--read-only-bg);
      padding: 20px;
      border-radius: 8px;
      margin-bottom: 30px;
      border: 1px solid #D7CCC8;
      display: flex;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 15px;
    }

    .summary-item {
      flex: 1;
      min-width: 150px;
    }
    .summary-item label {
      font-size: 11px;
      color: #795548;
      margin-bottom: 4px;
    }
    .summary-item span {
      display: block;
      font-weight: bold;
      font-size: 16px;
      color: #3E2723;
    }

    /* --- FORM STYLES --- */
    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    
    .full-width { grid-column: span 2; }

    label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      font-size: 13px;
      color: #6D4C41;
      text-transform: uppercase;
    }

    input[type="text"],
    input[type="date"] {
      width: 100%;
      padding: 12px;
      border: 1px solid var(--border-color);
      border-radius: 6px;
      font-size: 15px;
      background-color: #FAFAFA;
      box-sizing: border-box;
      font-family: inherit;
    }

    input:focus {
      outline: none;
      border-color: #8D6E63;
      background-color: white;
      box-shadow: 0 0 0 3px rgba(141, 110, 99, 0.1);
    }

    .btn-update {
      width: 100%;
      padding: 14px;
      background: var(--primary-gradient);
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      margin-top: 10px;
      transition: transform 0.2s;
    }
    .btn-update:hover { transform: translateY(-2px); }

    /* --- ALERTS --- */
    .alert {
      padding: 15px;
      border-radius: 6px;
      margin-bottom: 20px;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .alert-success { background-color: #E8F5E9; color: #2E7D32; border: 1px solid #C8E6C9; }
    .alert-error { background-color: #FFEBEE; color: #C62828; border: 1px solid #FFCDD2; }

    .back-link {
      color: #8D6E63;
      text-decoration: none;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 5px;
    }
    .back-link:hover { color: #3E2723; }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

<div class="container">
  <div class="card">
    
    <div class="header-row">
      <h2><i class="fas fa-edit"></i> Update Reservation</h2>
      <a href="<%= request.getContextPath() %>/reservation/view" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Search
      </a>
    </div>

    <% if (error != null) { %>
      <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
    <% } %>
    <% if (success != null) { %>
      <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= success %></div>
    <% } %>

    <% if (r != null) { %>
      <form method="post" action="<%= request.getContextPath() %>/reservation/update">
        <input type="hidden" name="reservationNo" value="<%= r.getReservationNo() %>"/>

        <div class="summary-box">
          <div class="summary-item">
            <label>RESERVATION NO</label>
            <span>#<%= r.getReservationNo() %></span>
          </div>
          <div class="summary-item">
            <label>ROOM DETAILS</label>
            <span><%= r.getRoomNumber() %> <small>(<%= r.getRoomTypeName() %>)</small></span>
          </div>
          <div class="summary-item">
            <label>CURRENT STATUS</label>
            <span style="color: #F57C00;"><%= r.getStatus() %></span>
          </div>
        </div>

        <div class="form-grid">
          
          <div class="full-width">
            <label>Guest Name</label>
            <input type="text" name="guestName" value="<%= r.getGuestName() %>" required>
          </div>

          <div class="full-width">
            <label>Guest Address</label>
            <input type="text" name="guestAddress" value="<%= r.getGuestAddress() %>">
          </div>

          <div class="full-width">
            <label>Guest Contact</label>
            <input type="text" name="guestContact" value="<%= r.getGuestContact() %>" required>
          </div>

          <div>
            <label>Check-In Date</label>
            <input type="date" name="checkIn" value="<%= r.getCheckIn() %>" required>
          </div>

          <div>
            <label>Check-Out Date</label>
            <input type="date" name="checkOut" value="<%= r.getCheckOut() %>" required>
          </div>

          <div class="full-width">
            <button type="submit" class="btn-update">
              <i class="fas fa-save"></i> Save Changes
            </button>
          </div>

        </div>
      </form>
    <% } else { %>
      <div style="text-align:center; padding: 40px; color: #777;">
        <i class="fas fa-search" style="font-size: 40px; margin-bottom: 15px; display:block;"></i>
        No reservation loaded. Please go back and select a reservation to edit.
      </div>
    <% } %>

  </div>
</div>

</body>
</html>