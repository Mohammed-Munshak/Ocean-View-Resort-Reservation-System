<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ovr.model.ReservationView" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
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
      max-width: 900px;
      position: relative;
      z-index: 1;
      animation: fadeIn 0.6s ease-out;
    }

    /* Search Card */
    .search-card {
      background: var(--white);
      padding: 36px 40px;
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      margin-bottom: 32px;
      border: 1px solid rgba(27, 59, 111, 0.08);
      position: relative;
      overflow: hidden;
      animation: fadeInDown 0.6s ease-out;
    }

    .search-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    h2 {
      margin-top: 0;
      font-size: 28px;
      font-weight: 700;
      color: var(--navy-blue);
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 14px;
      letter-spacing: -0.3px;
    }

    h2 i {
      font-size: 30px;
      color: var(--turquoise);
    }

    /* Alert Messages */
    .alert {
      padding: 18px 24px;
      border-radius: 14px;
      margin-bottom: 24px;
      font-size: 15px;
      font-weight: 500;
      display: flex;
      align-items: center;
      gap: 14px;
      animation: slideInDown 0.5s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: var(--shadow-md);
    }

    .alert i {
      font-size: 22px;
    }

    .alert-success {
      background: var(--success-light);
      color: var(--success);
      border-left: 5px solid var(--success);
    }

    .alert-error {
      background: var(--error-light);
      color: var(--error);
      border-left: 5px solid var(--error);
    }

    /* Search Form */
    .search-form {
      display: flex;
      gap: 16px;
    }

    input[type="text"] {
      flex: 1;
      padding: 15px 20px;
      border: 2px solid var(--border-light);
      border-radius: 12px;
      font-size: 16px;
      background: var(--white);
      color: var(--text-dark);
      font-family: inherit;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    input[type="text"]:hover {
      border-color: var(--turquoise);
    }

    input[type="text"]:focus {
      outline: none;
      border-color: var(--turquoise);
      box-shadow: 0 0 0 4px rgba(28, 167, 166, 0.1);
      transform: translateY(-2px);
    }

    input[type="text"]::placeholder {
      color: #9CA3AF;
    }

    .btn-search {
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border: none;
      padding: 0 32px;
      border-radius: 12px;
      font-weight: 700;
      font-size: 15px;
      cursor: pointer;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.3);
      text-transform: uppercase;
      letter-spacing: 0.5px;
      position: relative;
      overflow: hidden;
    }

    .btn-search::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
      transition: left 0.6s ease;
    }

    .btn-search:hover::before {
      left: 100%;
    }

    .btn-search:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 30px rgba(28, 167, 166, 0.4);
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
    }

    /* Details Card */
    .details-card {
      background: var(--white);
      border-radius: 20px;
      box-shadow: var(--shadow-xl);
      overflow: hidden;
      animation: fadeInUp 0.6s ease-out;
      border: 1px solid rgba(27, 59, 111, 0.08);
    }

    .details-header {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.1) 100%);
      padding: 24px 40px;
      border-bottom: 2px solid var(--soft-gray);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .res-id {
      font-size: 22px;
      font-weight: 700;
      color: var(--navy-blue);
      display: flex;
      align-items: center;
      gap: 10px;
      letter-spacing: -0.3px;
    }

    .res-id i {
      font-size: 24px;
      color: var(--turquoise);
    }

    .status-badge {
      padding: 8px 18px;
      border-radius: 24px;
      font-size: 12px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      box-shadow: var(--shadow-sm);
    }

    .status-badge i {
      font-size: 10px;
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

    .status-other {
      background: var(--error-light);
      color: var(--error);
      border: 2px solid var(--error);
    }

    /* Details Body */
    .details-body {
      padding: 40px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 48px;
    }

    .info-group h4 {
      margin: 0 0 20px 0;
      color: var(--navy-blue);
      font-size: 16px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.8px;
      border-bottom: 2px solid var(--turquoise);
      padding-bottom: 12px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .info-group h4 i {
      font-size: 18px;
      color: var(--turquoise);
    }

    .info-row {
      display: flex;
      margin-bottom: 16px;
      font-size: 15px;
      line-height: 1.6;
    }

    .info-label {
      min-width: 120px;
      color: var(--text-muted);
      font-weight: 600;
    }

    .info-value {
      flex: 1;
      color: var(--text-dark);
      font-weight: 600;
    }

    /* Actions Footer */
    .actions-footer {
      padding: 24px 40px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.03) 0%, rgba(252, 238, 209, 0.08) 100%);
      border-top: 2px solid var(--soft-gray);
      display: flex;
      justify-content: flex-end;
      gap: 16px;
    }

    .btn-update {
      text-decoration: none;
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      padding: 12px 28px;
      border-radius: 12px;
      font-size: 14px;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 10px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 16px rgba(28, 167, 166, 0.3);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .btn-update:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 24px rgba(28, 167, 166, 0.4);
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
    }

    .btn-update i {
      font-size: 16px;
    }

    .btn-cancel {
      background: var(--white);
      color: var(--error);
      border: 2px solid var(--error);
      padding: 12px 28px;
      border-radius: 12px;
      font-size: 14px;
      font-weight: 700;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 10px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .btn-cancel:hover {
      background: var(--error);
      color: var(--white);
      transform: translateY(-3px);
      box-shadow: 0 8px 24px rgba(239, 68, 68, 0.4);
    }

    .btn-cancel i {
      font-size: 16px;
    }

    /* Back Link */
    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      margin-top: 28px;
      color: var(--navy-blue);
      text-decoration: none;
      font-weight: 600;
      font-size: 14px;
      padding: 10px 20px;
      border-radius: 10px;
      background: var(--white);
      border: 2px solid var(--border-light);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: var(--shadow-sm);
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

    /* Animations */
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

    @keyframes slideInDown {
      from {
        opacity: 0;
        transform: translateY(-30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      body {
        padding: 24px 16px;
      }

      .search-card {
        padding: 28px 24px;
        border-radius: 16px;
      }

      h2 {
        font-size: 24px;
      }

      .search-form {
        flex-direction: column;
      }

      .btn-search {
        width: 100%;
      }

      .details-card {
        border-radius: 16px;
      }

      .details-header {
        padding: 20px 24px;
        flex-direction: column;
        gap: 16px;
        align-items: flex-start;
      }

      .res-id {
        font-size: 19px;
      }

      .details-body {
        padding: 28px 24px;
        grid-template-columns: 1fr;
        gap: 32px;
      }

      .info-label {
        min-width: 100px;
        font-size: 14px;
      }

      .info-value {
        font-size: 14px;
      }

      .actions-footer {
        padding: 20px 24px;
        flex-direction: column;
      }

      .btn-update,
      .btn-cancel {
        width: 100%;
        justify-content: center;
      }

      .back-link {
        width: 100%;
        justify-content: center;
      }
    }

    @media (max-width: 480px) {
      .search-card {
        padding: 24px 20px;
      }

      h2 {
        font-size: 22px;
        flex-wrap: wrap;
      }

      h2 i {
        font-size: 24px;
      }

      .details-header {
        padding: 18px 20px;
      }

      .res-id {
        font-size: 17px;
      }

      .details-body {
        padding: 24px 20px;
      }

      .info-group h4 {
        font-size: 14px;
      }

      .info-row {
        flex-direction: column;
        gap: 4px;
        margin-bottom: 14px;
      }

      .info-label {
        min-width: auto;
      }

      .actions-footer {
        padding: 18px 20px;
      }
    }

    /* Selection Color */
    ::selection {
      background-color: var(--turquoise);
      color: var(--white);
    }

    ::-moz-selection {
      background-color: var(--turquoise);
      color: var(--white);
    }

    /* Focus styles for accessibility */
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

  <div class="search-card">
    <h2><i class="fas fa-search"></i> Search Reservation</h2>
    
    <% if (error != null) { %>
      <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i> <%= error %>
      </div>
    <% } %>
    <% if (success != null) { %>
      <div class="alert alert-success">
        <i class="fas fa-check-circle"></i> <%= success %>
      </div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/reservation/view" class="search-form">
      <input type="hidden" name="action" value="search" />
      <input type="text" name="reservationNo" placeholder="Enter Reservation Number (e.g. RES-101)" required />
      <button type="submit" class="btn-search">Search</button>
    </form>
  </div>

  <% if (r != null) { %>
    <div class="details-card">
      
      <div class="details-header">
        <div class="res-id">
          <i class="fas fa-bookmark"></i>
          <%= r.getReservationNo() %>
        </div>
        <div>
          <% if ("ACTIVE".equalsIgnoreCase(r.getStatus())) { %>
            <span class="status-badge status-active">
              <i class="fas fa-circle"></i> Active
            </span>
          <% } else { %>
            <span class="status-badge status-other">
              <i class="fas fa-circle"></i> <%= r.getStatus() %>
            </span>
          <% } %>
        </div>
      </div>

      <div class="details-body">
        
        <div class="info-group">
          <h4><i class="fas fa-user"></i> Guest Information</h4>
          <div class="info-row">
            <span class="info-label">Full Name:</span>
            <span class="info-value"><%= r.getGuestName() %></span>
          </div>
          <div class="info-row">
            <span class="info-label">Contact:</span>
            <span class="info-value"><%= r.getGuestContact() %></span>
          </div>
          <div class="info-row">
            <span class="info-label">Address:</span>
            <span class="info-value"><%= r.getGuestAddress() == null ? "Not provided" : r.getGuestAddress() %></span>
          </div>
        </div>

        <div class="info-group">
          <h4><i class="fas fa-bed"></i> Reservation Details</h4>
          <div class="info-row">
            <span class="info-label">Room:</span>
            <span class="info-value"><%= r.getRoomNumber() %> (<%= r.getRoomTypeName() %>)</span>
          </div>
          <div class="info-row">
            <span class="info-label">Nightly Rate:</span>
            <span class="info-value">LKR <%= r.getRatePerNight() %></span>
          </div>
          <div class="info-row">
            <span class="info-label">Check-In:</span>
            <span class="info-value"><%= r.getCheckIn() %></span>
          </div>
          <div class="info-row">
            <span class="info-label">Check-Out:</span>
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
              <i class="fas fa-ban"></i> Cancel Booking
            </button>
          </form>

        </div>
      <% } %>

    </div>
  <% } %>

  <a href="<%= request.getContextPath() %>/Views/receptionistDashboard.jsp" class="back-link">
    <i class="fas fa-arrow-left"></i> Back to Dashboard
  </a>

</div>

</body>
</html>
