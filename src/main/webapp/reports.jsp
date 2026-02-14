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
    response.sendRedirect(request.getContextPath() + "/login.jsp");
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
      flex-direction: column;
      align-items: center;
      min-height: 100vh;
    }

    .container {
      width: 100%;
      max-width: 1000px;
      animation: fadeIn 0.6s ease-out;
    }

    .controls-card {
      background: var(--card-bg);
      padding: 25px;
      border-radius: 12px;
      box-shadow: 0 5px 20px rgba(141, 110, 99, 0.1);
      margin-bottom: 30px;
      border-top: 4px solid var(--table-header);
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 20px;
    }

    .report-form {
      display: flex;
      gap: 15px;
      align-items: center;
      flex-wrap: wrap;
    }

    label {
      font-weight: 600;
      font-size: 14px;
      color: #6D4C41;
    }

    input[type="date"] {
      padding: 8px 12px;
      border: 1px solid var(--border-color);
      border-radius: 4px;
      font-family: inherit;
    }

    .btn-generate {
      background: var(--primary-gradient);
      color: white;
      border: none;
      padding: 9px 20px;
      border-radius: 4px;
      cursor: pointer;
      font-weight: 600;
      transition: transform 0.2s;
    }
    
    .btn-generate:hover { 
      transform: translateY(-2px); 
    }

    .report-sheet {
      background: white;
      padding: 40px;
      border-radius: 8px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    }

    .report-header {
      text-align: center;
      border-bottom: 2px solid var(--table-header);
      padding-bottom: 20px;
      margin-bottom: 30px;
    }

    .report-header h2 {
      font-family: 'Times New Roman', serif;
      margin: 0;
      font-size: 28px;
      color: #3E2723;
    }
    
    .report-meta {
      color: #795548;
      font-size: 14px;
      margin-top: 5px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 14px;
    }

    th {
      background-color: var(--table-header);
      color: white;
      text-align: left;
      padding: 10px;
      -webkit-print-color-adjust: exact; /* Forces color print */
    }

    td {
      padding: 10px;
      border-bottom: 1px solid #EEE;
    }

    tr:nth-child(even) { background-color: #FAF8F6; -webkit-print-color-adjust: exact; }

    .total-box {
      margin-top: 30px;
      text-align: right;
      font-size: 18px;
      color: #3E2723;
      padding-top: 20px;
      border-top: 1px solid #3E2723;
    }

    .total-amount {
      font-size: 24px;
      font-weight: bold;
      color: #2E7D32;
    }

    .actions-row {
      display: flex;
      justify-content: flex-end;
      gap: 15px;
      margin-bottom: 20px;
    }

    .btn-print {
      background-color: #5D4037;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 4px;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .back-link {
      display: inline-block;
      margin-top: 20px;
      color: #8D6E63;
      text-decoration: none;
    }

    @media print {
      body { 
        background-color: white; 
        padding: 0; 
      }
      
      .container { 
        max-width: 100%; 
        width: 100%; 
        box-shadow: none; 
        animation: none; 
      }
      
      .controls-card, .actions-row, .back-link, .alert { 
        display: none !important; 
      }
      
      .report-sheet { 
        box-shadow: none; 
        padding: 0; 
        border: none; 
      }
      
      h2 { 
        color: black !important; 
        }
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

<div class="container">

  <div class="actions-row">
    <a href="<%= request.getContextPath() %>/adminDashboard.jsp" class="back-link" style="margin:0; margin-right:auto;">
      <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <% if (error != null) { %>
    <div class="alert" style="color:red; background:#FFEBEE; padding:15px; margin-bottom:20px; border-radius:5px;">
      <i class="fas fa-exclamation-circle"></i> <%= error %>
    </div>
  <% } %>

  <div class="controls-card">
    <h3 style="margin:0; font-family:'Times New Roman',serif;"><i class="fas fa-filter"></i> Generate Report</h3>
    
    <form method="post" action="<%= request.getContextPath() %>/admin/reports" class="report-form">
      <div>
        <label>From:</label>
        <input type="date" name="fromDate" value="<%= request.getParameter("fromDate") == null ? "" : request.getParameter("fromDate") %>" required>
      </div>
      <div>
        <label>To:</label>
        <input type="date" name="toDate" value="<%= request.getParameter("toDate") == null ? "" : request.getParameter("toDate") %>" required>
      </div>
      <button type="submit" class="btn-generate">
        <i class="fas fa-sync-alt"></i> Generate
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
        <p class="report-meta">Official Reservation & Revenue Report</p>
        <% if(request.getParameter("fromDate") != null) { %>
           <small>Period: <%= request.getParameter("fromDate") %> to <%= request.getParameter("toDate") %></small>
        <% } %>
      </div>

      <table cellpadding="6">
        <thead>
          <tr>
            <th>Res No.</th>
            <th>Guest Name</th>
            <th>Contact</th>
            <th>Room Details</th>
            <th>Check In</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <% for (ReservationView r : reservations) { %>
            <tr>
              <td>#<%= r.getReservationNo() %></td>
              <td><strong><%= r.getGuestName() %></strong></td>
              <td><%= r.getGuestContact() %></td>
              <td><%= r.getRoomNumber() %> <br><small style="color:#777"><%= r.getRoomTypeName() %></small></td>
              <td><%= r.getCheckIn() %></td>
              <td><%= r.getStatus() %></td>
            </tr>
          <% } %>
          <% if(reservations.isEmpty()) { %>
            <tr><td colspan="6" style="text-align:center;">No records found for this period.</td></tr>
          <% } %>
        </tbody>
      </table>

      <div class="total-box">
        Total Revenue Generated:<br>
        <span class="total-amount">LKR <%= String.format("%,.2f", revenue == null ? 0.0 : revenue) %></span>
      </div>

    </div>

  <% } %>

</div>

</body>
</html>