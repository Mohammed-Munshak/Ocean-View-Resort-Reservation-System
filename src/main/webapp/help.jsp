<%@ page contentType="text/html; charset=UTF-8" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  boolean isAdmin = "ADMIN".equalsIgnoreCase(role);
  boolean isReceptionist = "RECEPTIONIST".equalsIgnoreCase(role);

  String view = request.getParameter("view");
  if (view == null) view = "self";
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Help Guide | Ocean View Resort</title>
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #8D6E63 0%, #6D4C41 100%);
      --bg-color: #F4F1EA;
      --card-bg: #FFFFFF;
      --text-main: #3E2723;
      --border-color: #D7CCC8;
      --highlight-bg: #EFEBE9;
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
      max-width: 900px;
      animation: fadeIn 0.6s ease-out;
    }

    .header-section {
      text-align: center;
      margin-bottom: 30px;
    }
    
    h2 {
      font-family: 'Times New Roman', serif;
      font-size: 32px;
      color: var(--text-main);
      margin: 0 0 10px 0;
    }

    .nav-tabs {
      display: flex;
      justify-content: center;
      margin-bottom: 25px;
      gap: 15px;
    }

    .nav-link {
      text-decoration: none;
      padding: 10px 25px;
      border-radius: 30px;
      font-weight: 600;
      font-size: 14px;
      color: #8D6E63;
      background-color: white;
      border: 1px solid #8D6E63;
      transition: all 0.3s;
    }

    .nav-link:hover {
      background-color: #FAF8F6;
      transform: translateY(-2px);
    }

    .nav-link.active {
      background: var(--primary-gradient);
      color: white;
      border-color: transparent;
      box-shadow: 0 4px 10px rgba(141, 110, 99, 0.3);
    }

    .help-card {
      background: var(--card-bg);
      padding: 40px;
      border-radius: 12px;
      box-shadow: 0 5px 20px rgba(141, 110, 99, 0.1);
      border-top: 5px solid #8D6E63;
    }

    h3 {
      margin-top: 0;
      color: #5D4037;
      font-size: 20px;
      border-bottom: 1px solid #eee;
      padding-bottom: 15px;
      margin-bottom: 20px;
    }

    ol {
      padding-left: 20px;
    }

    ol > li {
      margin-bottom: 20px;
      font-weight: 600;
      color: #4E342E;
    }

    ol > li > b {
      color: #3E2723;
      font-size: 16px;
    }

    ul {
      margin-top: 8px;
      padding-left: 20px;
      list-style-type: none;
    }

    ul li {
      font-weight: 400;
      color: #666;
      margin-bottom: 6px;
      position: relative;
    }

    ul li::before {
      content: "\f054";
      font-family: "Font Awesome 5 Free";
      font-weight: 900;
      font-size: 10px;
      color: #8D6E63;
      position: absolute;
      left: -15px;
      top: 4px;
    }

    code {
      background-color: var(--highlight-bg);
      color: #C62828;
      padding: 2px 6px;
      border-radius: 4px;
      font-family: 'Consolas', 'Monaco', monospace;
      font-size: 0.9em;
      border: 1px solid #D7CCC8;
    }

    .tip-box {
      background-color: #E3F2FD;
      border-left: 4px solid #2196F3;
      padding: 15px;
      margin-top: 20px;
      border-radius: 4px;
      color: #0D47A1;
      font-size: 14px;
    }

    .footer-action {
      margin-top: 30px;
      text-align: center;
    }

    .btn-back {
      text-decoration: none;
      color: #8D6E63;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: color 0.3s;
    }
    .btn-back:hover { 
      color: #5D4037; 
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

<div class="container">

  <div class="header-section">
    <h2><i class="fas fa-question-circle"></i> Help Guide</h2>
    <p style="color:#777;">System Documentation & Support</p>
  </div>

  <div class="nav-tabs">
    <% if (isAdmin) { %>
      <a href="<%= request.getContextPath() %>/help.jsp?view=admin" 
         class="nav-link <%= "admin".equals(view) ? "active" : "" %>">
         <i class="fas fa-user-shield"></i> Admin Help
      </a>
      
      <a href="<%= request.getContextPath() %>/help.jsp?view=receptionist" 
         class="nav-link <%= "receptionist".equals(view) || "self".equals(view) ? "active" : "" %>">
         <i class="fas fa-concierge-bell"></i> Receptionist Help
      </a>
    <% } else { %>
      <span class="nav-link active"><i class="fas fa-concierge-bell"></i> Receptionist Guide</span>
    <% } %>
  </div>

  <% if ((isAdmin && "admin".equals(view)) ) { %>
    <div class="help-card">
      <h3>Admin Dashboard – What you can do</h3>
      <ol>
        <li>
          <b>Manage Room Types & Prices</b>
          <ul>
             <li>Add room categories, change price per night, activate/deactivate.</li>
          </ul>
        </li>
        <li>
          <b>Manage Rooms</b>
          <ul>
            <li>Add rooms, set status to AVAILABLE or MAINTENANCE.</li>
            <li>Remove/restore rooms (using soft delete <code>is_active</code>).</li>
          </ul>
        </li>
        <li>
          <b>Manage Receptionists</b>
          <ul>
             <li>Create receptionist accounts and toggle access.</li>
          </ul>
        </li>
        <li>
          <b>View Reports</b>
          <ul>
             <li>Select date range to view reservations and total revenue.</li>
          </ul>
        </li>
        <li>
          <b>Logout</b>
          <ul><li>End your session safely.</li></ul>
        </li>
      </ol>
      
      <div class="tip-box">
        <i class="fas fa-lightbulb"></i> <b>Tip:</b> If a Room Type or Room is inactive, the receptionist cannot book it.
      </div>
    </div>
  <% } %>

  <% if ((isReceptionist) || (isAdmin && "receptionist".equals(view)) || (isAdmin && "self".equals(view)) ) { %>
    <div class="help-card">
      <h3>Receptionist Dashboard – Step-by-step</h3>
      <ol>
        <li>
          <b>Add Reservation</b>
          <ul>
            <li>Open <b>Add Reservation</b> form.</li>
            <li>Select Room Type and Date Range.</li>
            <li>Submit → System assigns an available room automatically.</li>
          </ul>
        </li>

        <li>
          <b>View Reservations</b>
          <ul>
            <li>Use the reservation number to search.</li>
            <li>You can Update or Cancel (only <code>ACTIVE</code> reservations).</li>
          </ul>
        </li>

        <li>
          <b>Update Reservation</b>
          <ul>
            <li>Modify guest details and dates for active bookings.</li>
          </ul>
        </li>

        <li>
          <b>Generate Bill</b>
          <ul>
            <li>Enter reservation number to checkout.</li>
            <li>System calculates: <code>Nights × Rate</code>.</li>
            <li>Print the final invoice for the guest.</li>
          </ul>
        </li>

        <li>
          <b>Logout</b> – Always logout after your shift.
        </li>
      </ol>
    </div>
  <% } %>

  <div class="footer-action">
    <% if (isAdmin) { %>
      <a href="<%= request.getContextPath() %>/adminDashboard.jsp" class="btn-back">
        <i class="fas fa-arrow-left"></i> Back to Admin Dashboard
      </a>
    <% } else { %>
      <a href="<%= request.getContextPath() %>/receptionistDashboard.jsp" class="btn-back">
        <i class="fas fa-arrow-left"></i> Back to Receptionist Dashboard
      </a>
    <% } %>
  </div>

</div>

</body>
</html>