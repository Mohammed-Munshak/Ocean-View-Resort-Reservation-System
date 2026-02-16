<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ovr.model.ReservationView" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
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
      --navy-blue: #1B3B6F;
      --turquoise: #1CA7A6;
      --coral-orange: #FF7F50;
      --light-sand: #FCEED1;
      --soft-gray: #E5E5E5;
      --white: #FFFFFF;
      --text-dark: #2C2C2C;
      --text-muted: #6B7280;
      --border-light: #D1D5DB;
      --success: #059669;
      --success-light: #D1FAE5;
      --error: #EF4444;
      --error-light: #FEE2E2;
      --info: #3B82F6;
      --info-light: #DBEAFE;
      --shadow-sm: 0 1px 3px rgba(27, 59, 111, 0.08);
      --shadow-md: 0 4px 12px rgba(27, 59, 111, 0.1);
      --shadow-lg: 0 10px 30px rgba(27, 59, 111, 0.12);
      --shadow-xl: 0 20px 40px rgba(27, 59, 111, 0.15);
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
      background: linear-gradient(135deg, #F8FAFB 0%, var(--light-sand) 100%);
      color: var(--text-dark);
      min-height: 100vh;
      padding: 40px 20px;
      display: flex;
      justify-content: center;
    }

    body::before {
      content: '';
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-image: 
        linear-gradient(30deg, rgba(28, 167, 166, 0.02) 12%, transparent 12.5%, transparent 87%, rgba(28, 167, 166, 0.02) 87.5%),
        linear-gradient(150deg, rgba(27, 59, 111, 0.02) 12%, transparent 12.5%, transparent 87%, rgba(27, 59, 111, 0.02) 87.5%);
      background-size: 60px 104px;
      pointer-events: none;
      z-index: 0;
    }

    .container {
      width: 100%;
      max-width: 1400px;
      position: relative;
      z-index: 1;
      animation: fadeIn 0.6s ease-out;
    }

    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 32px;
      padding: 24px 32px;
      background: var(--white);
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      border: 1px solid rgba(27, 59, 111, 0.08);
      position: relative;
      overflow: hidden;
      animation: fadeInDown 0.6s ease-out;
    }

    .header-row::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    h2 {
      font-size: 32px;
      font-weight: 700;
      color: var(--navy-blue);
      margin: 0;
      display: flex;
      align-items: center;
      gap: 14px;
      letter-spacing: -0.5px;
    }

    h2 i {
      font-size: 34px;
      color: var(--turquoise);
    }

    .back-link {
      text-decoration: none;
      color: var(--navy-blue);
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 10px 20px;
      border-radius: 10px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.1) 100%);
      border: 2px solid var(--border-light);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      font-size: 14px;
    }

    .back-link:hover {
      background: var(--navy-blue);
      color: var(--white);
      border-color: var(--navy-blue);
      transform: translateX(-4px);
      box-shadow: var(--shadow-md);
    }

    .back-link i {
      transition: transform 0.3s ease;
    }

    .back-link:hover i {
      transform: translateX(-3px);
    }

    .card {
      background: var(--white);
      padding: 40px;
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      border: 1px solid rgba(27, 59, 111, 0.08);
      position: relative;
      overflow: hidden;
      animation: fadeInUp 0.6s ease-out 0.1s both;
    }

    .card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    .reservations-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
      gap: 24px;
    }

    .reservation-card {
      background: linear-gradient(135deg, var(--white) 0%, rgba(252, 238, 209, 0.15) 100%);
      border: 2px solid var(--border-light);
      border-radius: 16px;
      padding: 24px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      overflow: hidden;
      box-shadow: var(--shadow-sm);
    }

    .reservation-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 5px;
      height: 100%;
      background: var(--turquoise);
      transition: width 0.3s ease;
    }

    .reservation-card:hover {
      transform: translateY(-4px);
      box-shadow: var(--shadow-lg);
      border-color: var(--turquoise);
    }

    .reservation-card:hover::before {
      width: 8px;
    }

    .reservation-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 20px;
      padding-bottom: 16px;
      border-bottom: 2px solid var(--soft-gray);
    }

    .reservation-id-section {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .reservation-id {
      font-size: 18px;
      font-weight: 700;
      color: var(--navy-blue);
      display: flex;
      align-items: center;
      gap: 8px;
      font-family: 'Courier New', monospace;
    }

    .reservation-id i {
      font-size: 16px;
      color: var(--turquoise);
    }

    .btn-view {
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border: none;
      padding: 8px 16px;
      border-radius: 8px;
      cursor: pointer;
      font-size: 12px;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 2px 8px rgba(28, 167, 166, 0.3);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .btn-view:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(28, 167, 166, 0.4);
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
    }

    .btn-view i {
      font-size: 13px;
    }

    .status-badge {
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      box-shadow: var(--shadow-sm);
    }

    .status-badge i {
      font-size: 8px;
      animation: pulse 2s ease-in-out infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.5; }
    }

    .status-active {
      background: var(--success-light);
      color: var(--success);
      border: 2px solid var(--success);
    }

    .status-cancelled {
      background: var(--error-light);
      color: var(--error);
      border: 2px solid var(--error);
    }

    .status-checked-out {
      background: var(--info-light);
      color: var(--info);
      border: 2px solid var(--info);
    }

    .reservation-details {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .detail-row {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      font-size: 14px;
    }

    .detail-icon {
      width: 20px;
      color: var(--turquoise);
      font-size: 14px;
      margin-top: 2px;
      flex-shrink: 0;
    }

    .detail-content {
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 2px;
    }

    .detail-label {
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      color: var(--text-muted);
      letter-spacing: 0.5px;
    }

    .detail-value {
      font-size: 14px;
      font-weight: 600;
      color: var(--text-dark);
    }

    .detail-sub {
      font-size: 12px;
      color: var(--text-muted);
    }

    .empty-state {
      text-align: center;
      padding: 80px 20px;
      color: var(--text-muted);
    }

    .empty-state i {
      font-size: 72px;
      color: var(--soft-gray);
      margin-bottom: 24px;
      opacity: 0.5;
    }

    .empty-state p {
      font-size: 17px;
      margin: 0;
      font-weight: 500;
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    @keyframes fadeInDown {
      from {
        opacity: 0;
        transform: translateY(-30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(40px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @media (max-width: 1200px) {
      .reservations-grid {
        grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
        gap: 20px;
      }
    }

    @media (max-width: 768px) {
      body {
        padding: 24px 16px;
      }

      .header-row {
        flex-direction: column;
        gap: 16px;
        align-items: stretch;
        padding: 20px 24px;
        border-radius: 16px;
      }

      h2 {
        font-size: 26px;
      }

      .back-link {
        justify-content: center;
      }

      .card {
        padding: 28px 24px;
        border-radius: 16px;
      }

      .reservations-grid {
        grid-template-columns: 1fr;
        gap: 20px;
      }

      .reservation-card {
        padding: 20px;
      }
    }

    @media (max-width: 480px) {
      body {
        padding: 20px 12px;
      }

      .header-row {
        padding: 18px 20px;
      }

      h2 {
        font-size: 22px;
        flex-wrap: wrap;
      }

      h2 i {
        font-size: 28px;
      }

      .card {
        padding: 24px 20px;
      }

      .reservation-card {
        padding: 18px;
      }

      .reservation-id {
        font-size: 16px;
      }

      .detail-row {
        font-size: 13px;
      }

      .detail-value {
        font-size: 13px;
      }
    }

    ::selection {
      background-color: var(--turquoise);
      color: var(--white);
    }

    ::-moz-selection {
      background-color: var(--turquoise);
      color: var(--white);
    }

    *:focus-visible {
      outline: 2px solid var(--turquoise);
      outline-offset: 2px;
    }

    html {
      scroll-behavior: smooth;
    }
  </style>
</head>
<body>

<div class="container">

  <div class="header-row">
    <h2><i class="fas fa-list-alt"></i> All Reservations</h2>
    <a href="<%= request.getContextPath() %>/Views/receptionistDashboard.jsp" class="back-link">
      <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <div class="card">
    
    <% if (reservations != null && !reservations.isEmpty()) { %>
      <div class="reservations-grid">
        <% for (ReservationView r : reservations) { %>
          <div class="reservation-card">
            
            <div class="reservation-header">
              <div class="reservation-id-section">
                <div class="reservation-id">
                  <i class="fas fa-bookmark"></i>
                  <%= r.getReservationNo() %>
                </div>
                <form method="post" action="<%= request.getContextPath() %>/reservation/view" style="margin:0;">
                  <input type="hidden" name="action" value="search" />
                  <input type="hidden" name="reservationNo" value="<%= r.getReservationNo() %>" />
                  <button type="submit" class="btn-view" title="View Details">
                    <i class="fas fa-eye"></i> View Details
                  </button>
                </form>
              </div>
              
              <div>
                <% String s = r.getStatus(); 
                   String badgeClass = "status-checked-out";
                   if ("ACTIVE".equalsIgnoreCase(s)) { badgeClass = "status-active"; }
                   else if ("CANCELLED".equalsIgnoreCase(s)) { badgeClass = "status-cancelled"; }
                %>
                <span class="status-badge <%= badgeClass %>">
                  <i class="fas fa-circle"></i>
                  <%= s %>
                </span>
              </div>
            </div>

            <div class="reservation-details">
              
              <div class="detail-row">
                <i class="fas fa-user detail-icon"></i>
                <div class="detail-content">
                  <span class="detail-label">Guest Name</span>
                  <span class="detail-value"><%= r.getGuestName() %></span>
                </div>
              </div>

              <div class="detail-row">
                <i class="fas fa-phone detail-icon"></i>
                <div class="detail-content">
                  <span class="detail-label">Contact</span>
                  <span class="detail-value"><%= r.getGuestContact() %></span>
                </div>
              </div>

              <div class="detail-row">
                <i class="fas fa-bed detail-icon"></i>
                <div class="detail-content">
                  <span class="detail-label">Room</span>
                  <span class="detail-value"><%= r.getRoomNumber() %></span>
                  <span class="detail-sub"><%= r.getRoomTypeName() %></span>
                </div>
              </div>

              <div class="detail-row">
                <i class="fas fa-calendar-check detail-icon"></i>
                <div class="detail-content">
                  <span class="detail-label">Check-In</span>
                  <span class="detail-value"><%= r.getCheckIn() %></span>
                </div>
              </div>

              <div class="detail-row">
                <i class="fas fa-calendar-times detail-icon"></i>
                <div class="detail-content">
                  <span class="detail-label">Check-Out</span>
                  <span class="detail-value"><%= r.getCheckOut() %></span>
                </div>
              </div>

            </div>

          </div>
        <% } %>
      </div>
    <% } else { %>
      <div class="empty-state">
        <i class="fas fa-folder-open"></i>
        <p>No reservations found in the system.</p>
      </div>
    <% } %>

  </div>

</div>

</body>
</html>
