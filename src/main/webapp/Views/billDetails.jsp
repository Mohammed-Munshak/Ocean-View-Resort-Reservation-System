<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ovr.model.ReservationView" %>
<%@ page import="com.ovr.model.Bill" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
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
      --error: #EF4444;
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
      padding: 40px 20px;
      display: flex;
      justify-content: center;
      min-height: 100vh;
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

    .invoice-card {
      background: var(--white);
      width: 100%;
      max-width: 650px;
      padding: 40px;
      box-shadow: var(--shadow-xl);
      border-radius: 20px;
      position: relative;
      z-index: 1;
      animation: fadeInUp 0.6s ease-out;
      border: 1px solid rgba(27, 59, 111, 0.08);
    }

    .invoice-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 6px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
      border-radius: 20px 20px 0 0;
    }

    .invoice-header {
      text-align: center;
      padding-bottom: 24px;
      margin-bottom: 28px;
      border-bottom: 3px solid var(--navy-blue);
      position: relative;
    }

    .invoice-header::after {
      content: '';
      position: absolute;
      bottom: -3px;
      left: 50%;
      transform: translateX(-50%);
      width: 120px;
      height: 3px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    .invoice-header h2 {
      margin: 0 0 8px 0;
      font-size: 28px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: var(--navy-blue);
    }

    .hotel-details {
      margin-top: 10px;
      font-size: 13px;
      color: var(--text-muted);
      line-height: 1.8;
    }

    .invoice-label {
      margin-top: 16px;
      display: inline-block;
      padding: 6px 20px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.1) 0%, rgba(252, 238, 209, 0.2) 100%);
      border-radius: 20px;
      color: var(--navy-blue);
      font-weight: 700;
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 0.8px;
      border: 2px solid var(--turquoise);
    }

    .info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      margin-bottom: 24px;
    }

    .info-group h4 {
      margin: 0 0 10px;
      color: var(--navy-blue);
      font-size: 13px;
      font-weight: 700;
      text-transform: uppercase;
      border-bottom: 2px solid var(--turquoise);
      padding-bottom: 6px;
      letter-spacing: 0.5px;
    }

    .info-group p {
      margin: 6px 0;
      font-size: 14px;
      line-height: 1.6;
      color: var(--text-dark);
    }

    .info-group p i {
      color: var(--turquoise);
      width: 16px;
      font-size: 12px;
    }

    .info-group strong {
      color: var(--navy-blue);
      font-weight: 700;
    }

    .cost-table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
      box-shadow: var(--shadow-sm);
      border-radius: 12px;
      overflow: hidden;
    }

    .cost-table thead {
      background: linear-gradient(135deg, var(--navy-blue) 0%, #2C4F7F 100%);
    }

    .cost-table th {
      padding: 12px 14px;
      font-weight: 700;
      color: var(--white);
      text-transform: uppercase;
      font-size: 11px;
      letter-spacing: 0.8px;
    }

    .cost-table td {
      padding: 14px;
      border-bottom: 1px solid rgba(27, 59, 111, 0.06);
      color: var(--text-dark);
      font-size: 14px;
    }

    .cost-table tbody tr:hover {
      background: rgba(28, 167, 166, 0.03);
    }

    .align-left { text-align: left; }
    .align-center { text-align: center; }
    .align-right { text-align: right; }

    .total-row {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.08) 0%, rgba(252, 238, 209, 0.15) 100%);
    }

    .total-row td {
      font-weight: 700;
      font-size: 18px;
      border-top: 3px solid var(--turquoise);
      border-bottom: none;
      color: var(--navy-blue);
      padding: 16px 14px;
    }

    .thank-you-box {
      margin: 28px 0 24px;
      padding: 20px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.1) 100%);
      border-radius: 12px;
      border-left: 5px solid var(--turquoise);
      text-align: center;
    }

    .thank-you-box i {
      font-size: 32px;
      color: var(--turquoise);
      margin-bottom: 10px;
      display: block;
    }

    .thank-you-box h3 {
      margin: 0 0 8px 0;
      color: var(--navy-blue);
      font-size: 18px;
      font-weight: 700;
    }

    .thank-you-box p {
      margin: 0;
      color: var(--text-muted);
      font-size: 14px;
      line-height: 1.6;
    }

    .action-buttons {
      margin-top: 32px;
      text-align: center;
      display: flex;
      justify-content: center;
      gap: 12px;
      flex-wrap: wrap;
    }

    button, .btn-link, .btn-new, .btn-ghost {
      padding: 11px 24px;
      border-radius: 10px;
      font-weight: 700;
      cursor: pointer;
      text-decoration: none;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      display: inline-flex;
      align-items: center;
      gap: 8px;
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .btn-print {
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border: none;
      box-shadow: 0 4px 16px rgba(28, 167, 166, 0.3);
    }

    .btn-print:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 24px rgba(28, 167, 166, 0.4);
    }

    .btn-print i {
      font-size: 15px;
    }

    .btn-new {
      background: var(--white);
      border: 2px solid var(--navy-blue);
      color: var(--navy-blue);
    }

    .btn-new:hover {
      background: var(--navy-blue);
      color: var(--white);
      transform: translateY(-3px);
      box-shadow: 0 4px 12px rgba(27, 59, 111, 0.3);
    }

    .btn-ghost {
      background: transparent;
      border: 2px solid transparent;
      color: var(--text-muted);
    }

    .btn-ghost:hover {
      background: rgba(27, 59, 111, 0.05);
      color: var(--navy-blue);
    }

    .error-state {
      text-align: center;
      color: var(--error);
      padding: 60px 20px;
    }

    .error-state i {
      font-size: 48px;
      margin-bottom: 20px;
      color: var(--error);
    }

    .error-state h3 {
      font-size: 22px;
      margin-bottom: 12px;
      color: var(--navy-blue);
    }

    .error-state p {
      color: var(--text-muted);
      margin-bottom: 24px;
    }

    @media print {
      body {
        background: white;
        padding: 0;
      }

      body::before {
        display: none;
      }

      .invoice-card {
        box-shadow: none;
        padding: 20px;
        max-width: 100%;
        border: none;
        border-radius: 0;
      }

      .invoice-card::before {
        print-color-adjust: exact;
        -webkit-print-color-adjust: exact;
      }

      .action-buttons {
        display: none;
      }

      .invoice-header::after {
        print-color-adjust: exact;
        -webkit-print-color-adjust: exact;
      }

      .cost-table thead {
        background: #1B3B6F !important;
        print-color-adjust: exact;
        -webkit-print-color-adjust: exact;
      }

      .cost-table th {
        color: white !important;
        print-color-adjust: exact;
        -webkit-print-color-adjust: exact;
      }

      .thank-you-box {
        print-color-adjust: exact;
        -webkit-print-color-adjust: exact;
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

    @media (max-width: 600px) {
      body {
        padding: 20px 12px;
      }

      .invoice-card {
        padding: 28px 24px;
        border-radius: 16px;
      }

      .invoice-header h2 {
        font-size: 24px;
      }

      .hotel-details {
        font-size: 12px;
      }

      .info-grid {
        grid-template-columns: 1fr;
        gap: 16px;
      }

      .cost-table {
        font-size: 13px;
      }

      .cost-table th,
      .cost-table td {
        padding: 10px 8px;
        font-size: 12px;
      }

      .total-row td {
        font-size: 16px;
      }

      .thank-you-box {
        padding: 16px;
      }

      .thank-you-box i {
        font-size: 28px;
      }

      .thank-you-box h3 {
        font-size: 16px;
      }

      .action-buttons {
        flex-direction: column;
      }

      .btn-print,
      .btn-new,
      .btn-ghost {
        width: 100%;
        justify-content: center;
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

    html {
      scroll-behavior: smooth;
    }
  </style>
</head>
<body>

<div class="invoice-card">
  
  <% if (r != null && b != null) { %>
    
    <div class="invoice-header">
      <h2>Ocean View Resort</h2>
      <div class="hotel-details">
        No. 124, Matara Road, Unawatuna, Galle, Sri Lanka<br>
        <strong>Tel:</strong> +94 91 589 6789 | <strong>Email:</strong> info@oceanviewresort.lk
      </div>
      <span class="invoice-label">Guest Invoice</span>
    </div>

    <div class="info-grid">
      <div class="info-group">
        <h4>Bill To:</h4>
        <p><strong><%= r.getGuestName() %></strong></p>
        <p><i class="fas fa-phone"></i> <%= r.getGuestContact() %></p>
        <% if (r.getGuestAddress() != null && !r.getGuestAddress().trim().isEmpty()) { %>
          <p><i class="fas fa-map-marker-alt"></i> <%= r.getGuestAddress() %></p>
        <% } %>
      </div>

      <div class="info-group">
        <h4>Booking Details:</h4>
        <p><strong>Bill ID:</strong> #<%= b.getBillId() %></p>
        <p><strong>Reservation:</strong> <%= r.getReservationNo() %></p>
        <p><strong>Room:</strong> <%= r.getRoomNumber() %> (<%= r.getRoomTypeName() %>)</p>
      </div>
    </div>

    <div class="info-grid">
      <div class="info-group">
        <h4>Check-In</h4>
        <p><i class="fas fa-calendar-check"></i> <%= r.getCheckIn() %></p>
      </div>
      <div class="info-group">
        <h4>Check-Out</h4>
        <p><i class="fas fa-calendar-times"></i> <%= r.getCheckOut() %></p>
      </div>
    </div>

    <table class="cost-table">
      <thead>
        <tr>
          <th class="align-left">Description</th>
          <th class="align-center">Nights</th>
          <th class="align-right">Rate/Night</th>
          <th class="align-right">Amount</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="align-left"><strong><%= r.getRoomTypeName() %></strong> Room Charge</td>
          <td class="align-center"><%= b.getNights() %></td>
          <td class="align-right">LKR <%= String.format("%,.2f", b.getRatePerNight()) %></td>
          <td class="align-right">LKR <%= String.format("%,.2f", b.getTotalAmount()) %></td>
        </tr>
        <tr class="total-row">
          <td colspan="3" class="align-right">Grand Total</td>
          <td class="align-right">LKR <%= String.format("%,.2f", b.getTotalAmount()) %></td>
        </tr>
      </tbody>
    </table>

    <div class="thank-you-box">
      <i class="fas fa-heart"></i>
      <h3>Thank You for Choosing Ocean View Resort!</h3>
      <p>We hope you had a wonderful stay. It was our pleasure to serve you.<br>
      We look forward to welcoming you back soon!</p>
    </div>

    <div class="action-buttons">
      <button onclick="window.print()" class="btn-print">
        <i class="fas fa-print"></i> Print Invoice
      </button>
      
      <a href="<%= request.getContextPath() %>/bill/generate" class="btn-new">
        <i class="fas fa-redo"></i> New Bill
      </a>
      
      <a href="<%= request.getContextPath() %>/Views/receptionistDashboard.jsp" class="btn-ghost">
        <i class="fas fa-home"></i> Dashboard
      </a>
    </div>

  <% } else { %>
    
    <div class="error-state">
      <i class="fas fa-exclamation-triangle"></i>
      <h3>Bill Data Not Available</h3>
      <p>Unable to load invoice information. Please try generating the bill again.</p>
      <a href="<%= request.getContextPath() %>/bill/generate" class="btn-new">
        <i class="fas fa-redo"></i> Try Again
      </a>
    </div>

  <% } %>

</div>

</body>
</html>
