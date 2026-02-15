<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ovr.model.ReservationView" %>

<%@ page import="com.ovr.util.DB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
    return;
  }

  List<ReservationView> reservations =
      (List<ReservationView>) request.getAttribute("reservations");

  Double revenue = (Double) request.getAttribute("revenue");
  String error = (String) request.getAttribute("error");

  if (revenue == null) {
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");

    String sqlAll = "SELECT COALESCE(SUM(total_amount),0) AS revenue FROM bills";
    String sqlRange =
        "SELECT COALESCE(SUM(total_amount),0) AS revenue " +
        "FROM bills WHERE DATE(generated_at) BETWEEN ? AND ?";

    try (Connection con = DB.getConnection();
         PreparedStatement ps = (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty())
             ? con.prepareStatement(sqlRange)
             : con.prepareStatement(sqlAll)) {

      if (fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()) {
        ps.setString(1, fromDate);
        ps.setString(2, toDate);
      }

      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) revenue = rs.getDouble("revenue");
        else revenue = 0.0;
      }

    } catch (Exception ex) {
      ex.printStackTrace();
      if (error == null) error = "Failed to calculate revenue.";
      revenue = 0.0;
    }
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Business Reports | Ocean View Resort</title>
  
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
      flex-direction: column;
      align-items: center;
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
      max-width: 1200px;
      position: relative;
      z-index: 1;
      animation: fadeIn 0.6s ease-out;
    }

    /* Top Actions Bar */
    .actions-row {
      display: flex;
      justify-content: flex-end;
      gap: 16px;
      margin-bottom: 24px;
      animation: fadeInDown 0.6s ease-out;
    }

    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      margin: 0;
      margin-right: auto;
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

    /* Alert Message */
    .alert {
      background: var(--error-light);
      color: var(--error);
      padding: 18px 24px;
      margin-bottom: 24px;
      border-radius: 14px;
      display: flex;
      align-items: center;
      gap: 14px;
      font-size: 15px;
      font-weight: 500;
      border-left: 5px solid var(--error);
      box-shadow: var(--shadow-md);
      animation: slideInDown 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .alert i {
      font-size: 22px;
    }

    /* Controls Card */
    .controls-card {
      background: var(--white);
      padding: 32px;
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      margin-bottom: 32px;
      border: 1px solid rgba(27, 59, 111, 0.08);
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 24px;
      position: relative;
      overflow: hidden;
      animation: fadeInUp 0.6s ease-out 0.1s both;
    }

    .controls-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    .controls-card h3 {
      margin: 0;
      font-size: 22px;
      font-weight: 700;
      color: var(--navy-blue);
      display: flex;
      align-items: center;
      gap: 12px;
      letter-spacing: -0.3px;
    }

    .controls-card h3 i {
      font-size: 24px;
      color: var(--turquoise);
    }

    .report-form {
      display: flex;
      gap: 20px;
      align-items: center;
      flex-wrap: wrap;
    }

    .report-form > div {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    label {
      font-weight: 700;
      font-size: 12px;
      color: var(--text-dark);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    input[type="date"] {
      padding: 12px 16px;
      border: 2px solid var(--border-light);
      border-radius: 12px;
      font-family: inherit;
      font-size: 14px;
      color: var(--text-dark);
      background: var(--white);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      min-width: 160px;
    }

    input[type="date"]:hover {
      border-color: var(--turquoise);
    }

    input[type="date"]:focus {
      outline: none;
      border-color: var(--turquoise);
      box-shadow: 0 0 0 4px rgba(28, 167, 166, 0.1);
      transform: translateY(-2px);
    }

    .btn-generate {
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border: none;
      padding: 14px 28px;
      border-radius: 12px;
      cursor: pointer;
      font-weight: 700;
      font-size: 14px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.3);
      display: inline-flex;
      align-items: center;
      gap: 10px;
      margin-top: 22px;
      position: relative;
      overflow: hidden;
    }

    .btn-generate::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
      transition: left 0.6s ease;
    }

    .btn-generate:hover::before {
      left: 100%;
    }

    .btn-generate:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 30px rgba(28, 167, 166, 0.4);
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
    }

    .btn-generate i {
      font-size: 16px;
    }

    /* Print Button */
    .btn-print {
      background: linear-gradient(135deg, var(--coral-orange) 0%, #FF6347 100%);
      color: var(--white);
      border: none;
      padding: 12px 24px;
      border-radius: 12px;
      cursor: pointer;
      font-weight: 700;
      font-size: 14px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      display: flex;
      align-items: center;
      gap: 10px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 16px rgba(255, 127, 80, 0.3);
    }

    .btn-print:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 24px rgba(255, 127, 80, 0.4);
    }

    .btn-print i {
      font-size: 16px;
    }

    /* Report Sheet */
    .report-sheet {
      background: var(--white);
      padding: 48px;
      border-radius: 20px;
      box-shadow: var(--shadow-xl);
      border: 1px solid rgba(27, 59, 111, 0.08);
      animation: fadeInUp 0.6s ease-out 0.2s both;
    }

    .report-header {
      text-align: center;
      border-bottom: 3px solid var(--navy-blue);
      padding-bottom: 24px;
      margin-bottom: 36px;
      position: relative;
    }

    .report-header::after {
      content: '';
      position: absolute;
      bottom: -3px;
      left: 50%;
      transform: translateX(-50%);
      width: 100px;
      height: 3px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    .report-header h2 {
      margin: 0;
      font-size: 32px;
      color: var(--navy-blue);
      font-weight: 700;
      letter-spacing: -0.5px;
      margin-bottom: 8px;
    }

    .report-meta {
      color: var(--text-muted);
      font-size: 15px;
      margin-top: 8px;
      font-weight: 500;
    }

    .report-header small {
      display: inline-block;
      margin-top: 12px;
      padding: 8px 20px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.1) 0%, rgba(252, 238, 209, 0.2) 100%);
      border-radius: 20px;
      color: var(--navy-blue);
      font-weight: 600;
      font-size: 13px;
      border: 1px solid rgba(28, 167, 166, 0.2);
    }

    /* Table Styles */
    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 14px;
      box-shadow: var(--shadow-sm);
      border-radius: 12px;
      overflow: hidden;
    }

    thead {
      background: linear-gradient(135deg, var(--navy-blue) 0%, #2C4F7F 100%);
    }

    th {
      color: var(--white);
      text-align: left;
      padding: 16px 14px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.8px;
      font-size: 12px;
      -webkit-print-color-adjust: exact;
      print-color-adjust: exact;
    }

    tbody tr {
      border-bottom: 1px solid rgba(27, 59, 111, 0.06);
      transition: all 0.3s ease;
    }

    tbody tr:hover {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.03) 0%, rgba(252, 238, 209, 0.05) 100%);
      transform: translateX(2px);
    }

    tbody tr:nth-child(even) {
      background-color: rgba(252, 238, 209, 0.15);
      -webkit-print-color-adjust: exact;
      print-color-adjust: exact;
    }

    tbody tr:nth-child(even):hover {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.2) 100%);
    }

    td {
      padding: 16px 14px;
      border-bottom: 1px solid rgba(27, 59, 111, 0.06);
      color: var(--text-dark);
    }

    td strong {
      color: var(--navy-blue);
      font-weight: 700;
    }

    td small {
      color: var(--text-muted);
      font-size: 12px;
    }

    /* Total Box */
    .total-box {
      margin-top: 40px;
      text-align: right;
      padding: 28px 32px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.08) 0%, rgba(252, 238, 209, 0.15) 100%);
      border-radius: 16px;
      border: 2px solid var(--turquoise);
      box-shadow: var(--shadow-md);
    }

    .total-box > div:first-child {
      font-size: 16px;
      color: var(--text-dark);
      font-weight: 600;
      margin-bottom: 8px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .total-amount {
      font-size: 36px;
      font-weight: 700;
      color: var(--turquoise);
      font-family: 'Courier New', monospace;
      display: block;
      letter-spacing: 1px;
    }

    /* Animations */
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    @keyframes fadeInDown {
      from {
        opacity: 0;
        transform: translateY(-20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
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

    /* Print Styles */
    @media print {
      body {
        background: white;
        padding: 0;
      }

      body::before {
        display: none;
      }

      .container {
        max-width: 100%;
        width: 100%;
        box-shadow: none;
        animation: none;
      }

      .controls-card, 
      .actions-row, 
      .back-link, 
      .alert {
        display: none !important;
      }

      .report-sheet {
        box-shadow: none;
        padding: 20px;
        border: none;
        border-radius: 0;
      }

      .report-header h2 {
        color: black !important;
      }

      thead {
        background: #1B3B6F !important;
      }

      th {
        color: white !important;
      }

      tbody tr:hover {
        background: transparent;
        transform: none;
      }
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      body {
        padding: 20px 16px;
      }

      .controls-card {
        padding: 24px 20px;
        flex-direction: column;
        align-items: flex-start;
      }

      .controls-card h3 {
        font-size: 18px;
        width: 100%;
      }

      .report-form {
        width: 100%;
        flex-direction: column;
        gap: 16px;
      }

      .report-form > div {
        width: 100%;
      }

      input[type="date"] {
        width: 100%;
      }

      .btn-generate {
        width: 100%;
        justify-content: center;
      }

      .report-sheet {
        padding: 28px 20px;
        border-radius: 16px;
      }

      .report-header h2 {
        font-size: 24px;
      }

      .report-meta {
        font-size: 13px;
      }

      table {
        font-size: 12px;
      }

      th, td {
        padding: 10px 8px;
        font-size: 11px;
      }

      .total-box {
        padding: 20px;
      }

      .total-amount {
        font-size: 28px;
      }

      .actions-row {
        flex-direction: column;
      }

      .back-link {
        width: 100%;
        justify-content: center;
      }

      .btn-print {
        width: 100%;
        justify-content: center;
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

  <div class="actions-row">
    <a href="<%= request.getContextPath() %>/Views/adminDashboard.jsp" class="back-link">
      <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <% if (error != null) { %>
    <div class="alert">
      <i class="fas fa-exclamation-circle"></i> <%= error %>
    </div>
  <% } %>

  <div class="controls-card">
    <h3><i class="fas fa-filter"></i> Generate Revenue Report</h3>
    
    <form method="post" action="<%= request.getContextPath() %>/admin/reports" class="report-form">
      <div>
        <label>From Date:</label>
        <input type="date" name="fromDate" value="<%= request.getParameter("fromDate") == null ? "" : request.getParameter("fromDate") %>" required>
      </div>
      <div>
        <label>To Date:</label>
        <input type="date" name="toDate" value="<%= request.getParameter("toDate") == null ? "" : request.getParameter("toDate") %>" required>
      </div>
      <button type="submit" class="btn-generate">
        <i class="fas fa-sync-alt"></i> Generate Report
      </button>
    </form>
  </div>

  <% if (reservations != null) { %>
    
    <div class="actions-row">
      <button onclick="window.print()" class="btn-print">
        <i class="fas fa-print"></i> Print Report
      </button>
    </div>

    <div class="report-sheet">
      
      <div class="report-header">
        <h2>Ocean View Resort</h2>
        <p class="report-meta">Reservation & Revenue Analysis Report</p>
        <% if(request.getParameter("fromDate") != null) { %>
           <small>Report Period: <%= request.getParameter("fromDate") %> to <%= request.getParameter("toDate") %></small>
        <% } %>
      </div>

      <table cellpadding="6">
        <thead>
          <tr>
            <th>Reservation</th>
            <th>Guest Name</th>
            <th>Contact</th>
            <th>Room Details</th>
            <th>Check-In Date</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <% for (ReservationView r : reservations) { %>
            <tr>
              <td>#<%= r.getReservationNo() %></td>
              <td><strong><%= r.getGuestName() %></strong></td>
              <td><%= r.getGuestContact() %></td>
              <td><%= r.getRoomNumber() %> <br><small><%= r.getRoomTypeName() %></small></td>
              <td><%= r.getCheckIn() %></td>
              <td><%= r.getStatus() %></td>
            </tr>
          <% } %>
          <% if(reservations.isEmpty()) { %>
            <tr><td colspan="6" style="text-align:center; padding: 40px 20px; color: var(--text-muted);">No reservation records found for the selected period.</td></tr>
          <% } %>
        </tbody>
      </table>

      <div class="total-box">
        <div>Total Revenue Generated:</div>
        <span class="total-amount">LKR <%= String.format("%,.2f", revenue == null ? 0.0 : revenue) %></span>
      </div>

    </div>

  <% } %>

</div>

</body>
</html>
