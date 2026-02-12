<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ovr.model.ReservationView" %>
<%@ page import="com.ovr.model.Bill" %>

<%
  // --- BACKEND LOGIC PRESERVED ---
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  ReservationView r = (ReservationView) request.getAttribute("reservation");
  Bill b = (Bill) request.getAttribute("bill");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bill Invoice | Ocean View Resort</title>
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    /* --- THEME & PRINT SETTINGS --- */
    :root {
      --bg-color: #F4F1EA;
      --card-bg: #FFFFFF;
      --primary-brown: #8D6E63;
      --dark-text: #3E2723;
      --light-text: #5D4037;
      --border-color: #EEE;
    }

    body {
      font-family: 'Times New Roman', serif;
      background-color: var(--bg-color);
      color: var(--dark-text);
      margin: 0;
      padding: 40px 0;
      display: flex;
      justify-content: center;
    }

    /* --- INVOICE PAPER --- */
    .invoice-card {
      background: var(--card-bg);
      width: 100%;
      max-width: 700px;
      padding: 50px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.1);
      border-radius: 4px;
    }

    /* --- HEADER --- */
    .invoice-header {
      text-align: center;
      border-bottom: 2px solid var(--primary-brown);
      padding-bottom: 20px;
      margin-bottom: 30px;
    }

    .invoice-header h2 {
      margin: 0;
      font-size: 32px;
      text-transform: uppercase;
      letter-spacing: 2px;
      color: var(--primary-brown);
    }
    
    .hotel-details {
      margin-top: 10px;
      font-size: 14px;
      color: #555;
      line-height: 1.6;
      font-family: 'Segoe UI', sans-serif;
    }

    .invoice-label {
      margin-top: 15px;
      font-style: italic;
      color: #999;
      font-size: 14px;
      display: inline-block;
      border-top: 1px dashed #ddd;
      padding-top: 5px;
      width: 100px;
    }

    /* --- INFO SECTIONS --- */
    .info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 30px;
      margin-bottom: 30px;
      font-family: 'Segoe UI', sans-serif;
    }

    .info-group h4 {
      margin: 0 0 10px;
      color: var(--primary-brown);
      font-size: 14px;
      text-transform: uppercase;
      border-bottom: 1px solid #eee;
      padding-bottom: 5px;
    }

    .info-group p {
      margin: 5px 0;
      font-size: 15px;
    }

    /* --- COST TABLE (Fixed Alignment) --- */
    .cost-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
      font-family: 'Segoe UI', sans-serif;
    }

    .cost-table th {
      padding: 12px 10px;
      background-color: #FAF8F6;
      border-bottom: 2px solid var(--primary-brown); /* Darker line for header */
      font-weight: 600;
      color: var(--light-text);
      text-transform: uppercase;
      font-size: 13px;
    }

    .cost-table td {
      padding: 12px 10px;
      border-bottom: 1px solid var(--border-color);
      color: #333;
    }

    /* Alignment Classes */
    .align-left { text-align: left; }
    .align-center { text-align: center; }
    .align-right { text-align: right; }

    .total-row td {
      font-weight: bold;
      font-size: 18px;
      background-color: #FAF8F6;
      border-top: 2px solid var(--primary-brown);
      color: var(--primary-brown);
      padding-top: 15px;
      padding-bottom: 15px;
    }

    /* --- BUTTONS --- */
    .action-buttons {
      margin-top: 40px;
      text-align: center;
      display: flex;
      justify-content: center;
      gap: 15px;
    }

    /* Common Button Style */
    button, .btn-link, .btn-new {
      padding: 12px 20px;
      border-radius: 5px;
      font-family: 'Segoe UI', sans-serif;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      transition: all 0.3s;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      font-size: 14px;
    }

    .btn-print {
      background-color: var(--primary-brown);
      color: white;
      border: none;
    }
    .btn-print:hover { background-color: #5D4037; }

    .btn-new {
      background-color: white;
      border: 1px solid var(--primary-brown);
      color: var(--primary-brown);
    }
    .btn-new:hover { background-color: #FAF8F6; }
    
    /* Ghost button for 'Back' */
    .btn-ghost {
      background-color: transparent;
      border: 1px solid transparent;
      color: #888;
    }
    .btn-ghost:hover {
       background-color: #f5f5f5;
       color: #555;
    }

    /* --- PRINT STYLES --- */
    @media print {
      body { background-color: white; padding: 0; }
      .invoice-card { box-shadow: none; padding: 0; max-width: 100%; border: none; }
      .action-buttons { display: none; }
      .hotel-details { color: black; }
    }
  </style>
</head>
<body>

<div class="invoice-card">
  
  <% if (r != null && b != null) { %>
    
    <div class="invoice-header">
      <h2>Ocean View Resort</h2>
      <div class="hotel-details">
        No. 124, Matara Road, Unawatuna, Galle, Sri Lanka.<br>
        <strong>Tel:</strong> 091 58 96 789 / 091 62 36 894
      </div>
      <span class="invoice-label">Customer Invoice</span>
    </div>

    <div class="info-grid">
      <div class="info-group">
        <h4>Bill To:</h4>
        <p><strong><%= r.getGuestName() %></strong></p>
        <p><i class="fas fa-phone-alt"></i> <%= r.getGuestContact() %></p>
        <p><i class="fas fa-map-marker-alt"></i> <%= r.getGuestAddress() != null ? r.getGuestAddress() : "Guest Address" %></p>
      </div>

      <div class="info-group">
        <h4>Booking Details:</h4>
        <p><strong>Bill ID:</strong> #<%= b.getBillId() %></p>
        <p><strong>Reservation:</strong> #<%= r.getReservationNo() %></p>
        <p><strong>Room:</strong> <%= r.getRoomNumber() %> (<%= r.getRoomTypeName() %>)</p>
      </div>
    </div>

    <div class="info-grid">
      <div class="info-group">
        <h4>Check-in</h4>
        <p><%= r.getCheckIn() %></p>
      </div>
      <div class="info-group">
        <h4>Check-out</h4>
        <p><%= r.getCheckOut() %></p>
      </div>
    </div>

    <table class="cost-table">
      <thead>
        <tr>
          <th class="align-left">Description</th>
          <th class="align-center">Quantity</th>
          <th class="align-right">Rate</th>
          <th class="align-right">Amount</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="align-left">Room Charge (<%= r.getRoomTypeName() %>)</td>
          <td class="align-center"><%= b.getNights() %> Nights</td>
          <td class="align-right">LKR <%= b.getRatePerNight() %></td>
          <td class="align-right">LKR <%= b.getTotalAmount() %></td>
        </tr>
        <tr class="total-row">
          <td colspan="3" class="align-right">Grand Total</td>
          <td class="align-right">LKR <%= b.getTotalAmount() %></td>
        </tr>
      </tbody>
    </table>

    <div class="action-buttons">
      <button onclick="window.print()" class="btn-print">
        <i class="fas fa-print"></i> Print Bill
      </button>
      
      <a href="<%= request.getContextPath() %>/bill/generate" class="btn-new">
        <i class="fas fa-redo"></i> Generate Another
      </a>
      
      <a href="<%= request.getContextPath() %>/receptionistDashboard.jsp" class="btn-ghost">
        Back to Dashboard
      </a>
    </div>

  <% } else { %>
    
    <div style="text-align: center; color: #D32F2F; padding: 40px;">
      <i class="fas fa-exclamation-triangle" style="font-size: 40px; margin-bottom: 20px;"></i>
      <h3>Bill Data Not Available</h3>
      <p>Please try generating the bill again.</p>
      <a href="<%= request.getContextPath() %>/receptionistDashboard.jsp" class="btn-new">Go Back</a>
    </div>

  <% } %>

</div>

</body>
</html>