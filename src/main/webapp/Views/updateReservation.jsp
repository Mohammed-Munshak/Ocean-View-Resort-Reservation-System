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
  <title>Update Reservation | Ocean View Resort</title>
  
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
      --info-bg: #E0F2F1;
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

    .card {
      background: var(--white);
      border-radius: 20px;
      padding: 40px;
      box-shadow: var(--shadow-xl);
      border: 1px solid rgba(27, 59, 111, 0.08);
      position: relative;
      overflow: hidden;
      animation: fadeInUp 0.6s ease-out;
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

    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 32px;
      padding-bottom: 20px;
      border-bottom: 2px solid var(--soft-gray);
    }

    h2 {
      margin: 0;
      font-size: 28px;
      font-weight: 700;
      color: var(--navy-blue);
      display: flex;
      align-items: center;
      gap: 12px;
      letter-spacing: -0.3px;
    }

    h2 i {
      font-size: 30px;
      color: var(--turquoise);
    }

    .back-link {
      color: var(--navy-blue);
      text-decoration: none;
      font-size: 14px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 10px 20px;
      border-radius: 10px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.1) 100%);
      border: 2px solid var(--border-light);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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

    .alert {
      padding: 18px 24px;
      border-radius: 14px;
      margin-bottom: 28px;
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

    .summary-box {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.1) 100%);
      padding: 24px;
      border-radius: 16px;
      margin-bottom: 32px;
      border: 2px solid rgba(28, 167, 166, 0.2);
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
      box-shadow: var(--shadow-sm);
    }

    .summary-item {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .summary-item label {
      font-size: 11px;
      color: var(--text-muted);
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.8px;
    }

    .summary-item span {
      font-weight: 700;
      font-size: 16px;
      color: var(--navy-blue);
    }

    .summary-item span small {
      color: var(--text-muted);
      font-size: 13px;
      font-weight: 500;
    }

    .summary-item:last-child span {
      color: var(--coral-orange);
      text-transform: uppercase;
      font-size: 14px;
      letter-spacing: 0.5px;
    }

    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
    }

    .full-width {
      grid-column: span 2;
    }

    label {
      display: block;
      margin-bottom: 10px;
      font-weight: 700;
      font-size: 13px;
      color: var(--text-dark);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    input[type="text"],
    input[type="date"] {
      width: 100%;
      padding: 14px 18px;
      border: 2px solid var(--border-light);
      border-radius: 12px;
      font-size: 15px;
      background: var(--white);
      color: var(--text-dark);
      box-sizing: border-box;
      font-family: inherit;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    input[type="text"]:hover,
    input[type="date"]:hover {
      border-color: var(--turquoise);
    }

    input[type="text"]:focus,
    input[type="date"]:focus {
      outline: none;
      border-color: var(--turquoise);
      background: var(--white);
      box-shadow: 0 0 0 4px rgba(28, 167, 166, 0.1);
      transform: translateY(-2px);
    }

    .btn-update {
      width: 100%;
      padding: 18px;
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border: none;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      margin-top: 12px;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.3);
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      text-transform: uppercase;
      letter-spacing: 0.8px;
      position: relative;
      overflow: hidden;
    }

    .btn-update::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
      transition: left 0.6s ease;
    }

    .btn-update:hover::before {
      left: 100%;
    }

    .btn-update:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 30px rgba(28, 167, 166, 0.4);
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
    }

    .btn-update:active {
      transform: translateY(-1px);
    }

    .btn-update i {
      font-size: 18px;
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
      display: block;
    }

    .empty-state p {
      font-size: 17px;
      margin: 0;
      font-weight: 500;
      line-height: 1.6;
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
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

    @media (max-width: 768px) {
      body {
        padding: 24px 16px;
      }

      .card {
        padding: 32px 24px;
        border-radius: 16px;
      }

      .header-row {
        flex-direction: column;
        gap: 16px;
        align-items: stretch;
      }

      h2 {
        font-size: 24px;
      }

      .back-link {
        justify-content: center;
      }

      .summary-box {
        grid-template-columns: 1fr;
        gap: 16px;
      }

      .form-grid {
        grid-template-columns: 1fr;
        gap: 20px;
      }

      .full-width {
        grid-column: span 1;
      }
    }

    @media (max-width: 480px) {
      .card {
        padding: 28px 20px;
      }

      h2 {
        font-size: 22px;
        flex-wrap: wrap;
      }

      h2 i {
        font-size: 26px;
      }

      .summary-item span {
        font-size: 15px;
      }

      input[type="text"],
      input[type="date"] {
        padding: 12px 16px;
        font-size: 14px;
      }

      .btn-update {
        padding: 16px;
        font-size: 15px;
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
  <div class="card">
    
    <div class="header-row">
      <h2><i class="fas fa-edit"></i> Update Reservation Details</h2>
      <a href="<%= request.getContextPath() %>/reservation/view" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Search
      </a>
    </div>

    <% if (error != null) { %>
      <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i>
        <span><%= error %></span>
      </div>
    <% } %>
    <% if (success != null) { %>
      <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>
        <span><%= success %></span>
      </div>
    <% } %>

    <% if (r != null) { %>
      <form method="post" action="<%= request.getContextPath() %>/reservation/update">
        <input type="hidden" name="reservationNo" value="<%= r.getReservationNo() %>"/>

        <div class="summary-box">
          <div class="summary-item">
            <label>Reservation ID</label>
            <span><%= r.getReservationNo() %></span>
          </div>
          <div class="summary-item">
            <label>Room Assignment</label>
            <span><%= r.getRoomNumber() %> <small>(<%= r.getRoomTypeName() %>)</small></span>
          </div>
          <div class="summary-item">
            <label>Current Status</label>
            <span><%= r.getStatus() %></span>
          </div>
        </div>

        <div class="form-grid">
          
          <div class="full-width">
            <label>Guest Full Name</label>
            <input type="text" name="guestName" value="<%= r.getGuestName() %>" required>
          </div>

          <div>
            <label>Contact Number</label>
            <input type="text" name="guestContact" value="<%= r.getGuestContact() %>" required>
          </div>

          <div>
            <label>Guest Address</label>
            <input type="text" name="guestAddress" value="<%= r.getGuestAddress() %>">
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
              <i class="fas fa-check-circle"></i> Save Changes
            </button>
          </div>

        </div>
      </form>
    <% } else { %>
      <div class="empty-state">
        <i class="fas fa-search"></i>
        <p>No reservation data available.<br>Please return to the search page and select a reservation to update.</p>
      </div>
    <% } %>

  </div>
</div>

</body>
</html>
