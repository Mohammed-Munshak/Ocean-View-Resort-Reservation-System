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
  <title>View Reservation | Ocean View Resort</title>
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    /* --- THEME --- */
    :root {
      --primary-gradient: linear-gradient(135deg, #8D6E63 0%, #6D4C41 100%);
      --bg-color: #F4F1EA;
      --card-bg: #FFFFFF;
      --text-main: #3E2723;
      --border-color: #D7CCC8;
      --active-color: #2E7D32;
      --cancel-color: #C62828;
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
      animation: fadeIn 0.6s ease-out;
    }

    /* --- SEARCH CARD --- */
    .search-card {
      background: var(--card-bg);
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 5px 15px rgba(141, 110, 99, 0.1);
      margin-bottom: 30px;
      border-top: 5px solid #8D6E63;
    }

    h2 {
      margin-top: 0;
      font-family: 'Times New Roman', serif;
      font-size: 28px;
      color: var(--text-main);
      margin-bottom: 20px;
    }

    .search-form {
      display: flex;
      gap: 15px;
    }

    input[type="text"] {
      flex: 1;
      padding: 12px 15px;
      border: 1px solid var(--border-color);
      border-radius: 6px;
      font-size: 16px;
      background-color: #FAFAFA;
    }

    .btn-search {
      background: var(--primary-gradient);
      color: white;
      border: none;
      padding: 0 25px;
      border-radius: 6px;
      font-weight: 600;
      cursor: pointer;
      transition: transform 0.2s;
    }
    .btn-search:hover { transform: translateY(-2px); }

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
    .alert-success { background-color: #E8F5E9; color: var(--active-color); border: 1px solid #C8E6C9; }
    .alert-error { background-color: #FFEBEE; color: var(--cancel-color); border: 1px solid #FFCDD2; }

    /* --- DETAILS CARD --- */
    .details-card {
      background: var(--card-bg);
      border-radius: 12px;
      box-shadow: 0 10px 30px rgba(141, 110, 99, 0.15);
      overflow: hidden;
      animation: slideUp 0.5s ease-out;
    }

    .details-header {
      background-color: #FAF8F6;
      padding: 20px 30px;
      border-bottom: 1px solid #EEE;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .res-id {
      font-size: 18px;
      font-weight: bold;
      color: #5D4037;
    }

    .status-badge {
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: bold;
      text-transform: uppercase;
    }
    .status-active { background-color: #E8F5E9; color: #2E7D32; }
    .status-other { background-color: #FFEBEE; color: #C62828; }

    .details-body {
      padding: 30px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 40px;
    }

    .info-group h4 {
      margin: 0 0 15px 0;
      color: #8D6E63;
      font-size: 14px;
      text-transform: uppercase;
      border-bottom: 1px solid #EEE;
      padding-bottom: 5px;
    }

    .info-row {
      display: flex;
      margin-bottom: 10px;
      font-size: 14px;
    }
    .info-label {
      width: 100px;
      color: #999;
      font-weight: 500;
    }
    .info-value {
      flex: 1;
      color: #3E2723;
      font-weight: 600;
    }

    /* --- ACTION BUTTONS --- */
    .actions-footer {
      padding: 20px 30px;
      background-color: #FAF8F6;
      border-top: 1px solid #EEE;
      display: flex;
      justify-content: flex-end;
      gap: 15px;
    }

    .btn-update {
      text-decoration: none;
      background-color: #8D6E63;
      color: white;
      padding: 10px 20px;
      border-radius: 6px;
      font-size: 14px;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 5px;
      transition: background 0.3s;
    }
    .btn-update:hover { background-color: #6D4C41; }

    .btn-cancel {
      background-color: white;
      color: var(--cancel-color);
      border: 1px solid var(--cancel-color);
      padding: 10px 20px;
      border-radius: 6px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 5px;
      transition: all 0.3s;
    }
    .btn-cancel:hover { background-color: #FFEBEE; }

    .back-link {
      display: inline-block;
      margin-top: 20px;
      color: #8D6E63;
      text-decoration: none;
      font-weight: 600;
    }
    .back-link:hover { color: #5D4037; }

    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    @keyframes slideUp { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

    /* Mobile Responsive */
    @media (max-width: 600px) {
      .details-body { grid-template-columns: 1fr; gap: 20px; }
      .search-form { flex-direction: column; }
      .actions-footer { flex-direction: column; }
      .btn-update, .btn-cancel { width: 100%; justify-content: center; }
    }
  </style>
</head>
<body>

<div class="container">

  <div class="search-card">
    <h2><i class="fas fa-search"></i> View Reservation</h2>
    
    <% if (error != null) { %>
      <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
    <% } %>
    <% if (success != null) { %>
      <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= success %></div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/reservation/view" class="search-form">
      <input type="hidden" name="action" value="search" />
      <input type="text" name="reservationNo" placeholder="Enter Reservation No (e.g. RES-101)" required />
      <button type="submit" class="btn-search">Search</button>
    </form>
  </div>

  <% if (r != null) { %>
    <div class="details-card">
      
      <div class="details-header">
        <div class="res-id">#<%= r.getReservationNo() %></div>
        <div>
          <% if ("ACTIVE".equalsIgnoreCase(r.getStatus())) { %>
            <span class="status-badge status-active">Active</span>
          <% } else { %>
            <span class="status-badge status-other"><%= r.getStatus() %></span>
          <% } %>
        </div>
      </div>

      <div class="details-body">
        
        <div class="info-group">
          <h4><i class="fas fa-user"></i> Guest Details</h4>
          <div class="info-row">
            <span class="info-label">Name:</span>
            <span class="info-value"><%= r.getGuestName() %></span>
          </div>
          <div class="info-row">
            <span class="info-label">Contact:</span>
            <span class="info-value"><%= r.getGuestContact() %></span>
          </div>
          <div class="info-row">
            <span class="info-label">Address:</span>
            <span class="info-value"><%= r.getGuestAddress() == null ? "-" : r.getGuestAddress() %></span>
          </div>
        </div>

        <div class="info-group">
          <h4><i class="fas fa-bed"></i> Booking Details</h4>
          <div class="info-row">
            <span class="info-label">Room:</span>
            <span class="info-value"><%= r.getRoomNumber() %> (<%= r.getRoomTypeName() %>)</span>
          </div>
          <div class="info-row">
            <span class="info-label">Rate:</span>
            <span class="info-value">LKR <%= r.getRatePerNight() %>/night</span>
          </div>
          <div class="info-row">
            <span class="info-label">Check-in:</span>
            <span class="info-value"><%= r.getCheckIn() %></span>
          </div>
          <div class="info-row">
            <span class="info-label">Check-out:</span>
            <span class="info-value"><%= r.getCheckOut() %></span>
          </div>
        </div>

      </div>

      <% if ("ACTIVE".equalsIgnoreCase(r.getStatus())) { %>
        <div class="actions-footer">
          
          <a href="<%= request.getContextPath() %>/reservation/update?reservationNo=<%= r.getReservationNo() %>" class="btn-update">
            <i class="fas fa-edit"></i> Update Details
          </a>

          <form method="post" action="<%= request.getContextPath() %>/reservation/view"
                onsubmit="return confirm('Are you sure you want to CANCEL this reservation? This action cannot be undone.');" style="margin:0;">
            <input type="hidden" name="action" value="cancel" />
            <input type="hidden" name="reservationNo" value="<%= r.getReservationNo() %>" />
            <button type="submit" class="btn-cancel">
              <i class="fas fa-ban"></i> Cancel Reservation
            </button>
          </form>

        </div>
      <% } %>

    </div>
  <% } %>

  <a href="<%= request.getContextPath() %>/receptionistDashboard.jsp" class="back-link">
    <i class="fas fa-arrow-left"></i> Back to Dashboard
  </a>

</div>

</body>
</html>