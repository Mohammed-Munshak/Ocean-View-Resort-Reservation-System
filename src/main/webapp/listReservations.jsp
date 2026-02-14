<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ovr.model.ReservationView" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  List<ReservationView> reservations = (List<ReservationView>) request.getAttribute("reservations");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>All Reservations | Ocean View Resort</title>
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #8D6E63 0%, #6D4C41 100%);
      --bg-color: #F4F1EA;
      --card-bg: #FFFFFF;
      --text-main: #3E2723;
      --border-color: #D7CCC8;
      --table-header: #8D6E63;
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
      max-width: 1200px; /* Wider container for the table */
      animation: fadeIn 0.6s ease-out;
    }

    .card {
      background: var(--card-bg);
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 5px 20px rgba(141, 110, 99, 0.1);
      border-top: 4px solid var(--table-header);
    }

    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    h2 {
      font-family: 'Times New Roman', serif;
      color: var(--text-main);
      margin: 0;
      font-size: 28px;
    }

    .back-link {
      text-decoration: none;
      color: #8D6E63;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 5px;
      transition: color 0.3s;
    }
    .back-link:hover { color: #5D4037; }

    .table-responsive {
      overflow-x: auto;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
      font-size: 14px;
      white-space: nowrap;
    }

    th {
      background-color: var(--table-header);
      color: white;
      text-align: left;
      padding: 12px 15px;
      font-weight: 600;
      text-transform: uppercase;
      font-size: 13px;
    }

    td {
      padding: 12px 15px;
      border-bottom: 1px solid #EEE;
      color: #555;
    }

    tr:nth-child(even) { 
      background-color: #FAF8F6; 
    }
    
    tr:hover { 
      background-color: #F1EFE9; 
    }

    .status-badge {
      padding: 5px 10px;
      border-radius: 12px;
      font-size: 11px;
      font-weight: bold;
      text-transform: uppercase;
    }

    .status-active { 
      background-color: #E8F5E9; 
      color: #2E7D32; 
    }
    
    .status-cancelled { 
      background-color: #FFEBEE; 
      color: #C62828; 
    }
    
    .status-checked-out { 
      background-color: #ECEFF1; 
      color: #546E7A; 
    }

    .btn-view {
      background-color: #8D6E63;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 13px;
      display: flex;
      align-items: center;
      gap: 5px;
      transition: background 0.2s;
    }
    
    .btn-view:hover { 
      background-color: #6D4C41; 
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

<div class="container">

  <div class="header-row">
    <h2><i class="fas fa-list-alt"></i> Latest Reservations</h2>
    <a href="<%= request.getContextPath() %>/receptionistDashboard.jsp" class="back-link">
      <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <div class="card">
    
    <% if (reservations != null && !reservations.isEmpty()) { %>
      <div class="table-responsive">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Guest Name</th>
              <th>Contact</th>
              <th>Room Info</th>
              <th>Check In</th>
              <th>Check Out</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <% for (ReservationView r : reservations) { %>
              <tr>
                <td><strong>#<%= r.getReservationNo() %></strong></td>
                <td><%= r.getGuestName() %></td>
                <td><%= r.getGuestContact() %></td>
                <td><%= r.getRoomNumber() %> <small style="color:#999">(<%= r.getRoomTypeName() %>)</small></td>
                <td><%= r.getCheckIn() %></td>
                <td><%= r.getCheckOut() %></td>
                
                <td>
                  <% String s = r.getStatus(); 
                     String badgeClass = "status-checked-out"; // default
                     if ("ACTIVE".equalsIgnoreCase(s)) { badgeClass = "status-active"; }
                     else if ("CANCELLED".equalsIgnoreCase(s)) { badgeClass = "status-cancelled"; }
                  %>
                  <span class="status-badge <%= badgeClass %>"><%= s %></span>
                </td>

                <td>
                  <form method="post" action="<%= request.getContextPath() %>/reservation/view" style="margin:0;">
                    <input type="hidden" name="action" value="search" />
                    <input type="hidden" name="reservationNo" value="<%= r.getReservationNo() %>" />
                    <button type="submit" class="btn-view" title="View Details">
                      <i class="fas fa-eye"></i> View
                    </button>
                  </form>
                </td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    <% } else { %>
      <div style="text-align:center; padding: 40px; color: #777;">
        <i class="fas fa-folder-open" style="font-size: 40px; margin-bottom: 15px; color: #D7CCC8;"></i>
        <p>No reservations found in the system.</p>
      </div>
    <% } %>

  </div>

</div>

</body>
</html>