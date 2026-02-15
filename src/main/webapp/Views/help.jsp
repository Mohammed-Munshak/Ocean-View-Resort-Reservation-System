<%@ page contentType="text/html; charset=UTF-8" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null) {
    response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
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
      --navy-blue: #1B3B6F;
      --turquoise: #1CA7A6;
      --coral-orange: #FF7F50;
      --light-sand: #FCEED1;
      --soft-gray: #E5E5E5;
      --white: #FFFFFF;
      --text-dark: #2C2C2C;
      --text-muted: #6B7280;
      --border-light: #D1D5DB;
      --info-bg: #E0F2F1;
      --info-border: #00897B;
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
      line-height: 1.7;
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
      max-width: 1000px;
      position: relative;
      z-index: 1;
      animation: fadeIn 0.6s ease-out;
    }

    /* Header Section */
    .header-section {
      text-align: center;
      margin-bottom: 36px;
      padding: 32px 24px;
      background: var(--white);
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      border: 1px solid rgba(27, 59, 111, 0.08);
      position: relative;
      overflow: hidden;
      animation: fadeInDown 0.6s ease-out;
    }

    .header-section::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    h2 {
      font-size: 36px;
      color: var(--navy-blue);
      margin: 0 0 10px 0;
      font-weight: 700;
      letter-spacing: -0.5px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 14px;
    }

    h2 i {
      font-size: 38px;
      color: var(--turquoise);
    }

    .header-section p {
      color: var(--text-muted);
      font-size: 16px;
      margin: 0;
      font-weight: 500;
    }

    /* Navigation Tabs */
    .nav-tabs {
      display: flex;
      justify-content: center;
      margin-bottom: 32px;
      gap: 16px;
      animation: fadeInUp 0.6s ease-out 0.1s both;
    }

    .nav-link {
      text-decoration: none;
      padding: 14px 32px;
      border-radius: 12px;
      font-weight: 700;
      font-size: 14px;
      color: var(--navy-blue);
      background: var(--white);
      border: 2px solid var(--border-light);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      display: inline-flex;
      align-items: center;
      gap: 10px;
      box-shadow: var(--shadow-sm);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .nav-link i {
      font-size: 16px;
    }

    .nav-link:hover {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.1) 100%);
      border-color: var(--turquoise);
      transform: translateY(-3px);
      box-shadow: var(--shadow-md);
    }

    .nav-link.active {
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border-color: transparent;
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.3);
    }

    /* Help Card */
    .help-card {
      background: var(--white);
      padding: 48px;
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      border: 1px solid rgba(27, 59, 111, 0.08);
      position: relative;
      overflow: hidden;
      animation: fadeInUp 0.6s ease-out 0.2s both;
    }

    .help-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: linear-gradient(90deg, var(--coral-orange) 0%, var(--turquoise) 100%);
    }

    h3 {
      margin-top: 0;
      color: var(--navy-blue);
      font-size: 24px;
      font-weight: 700;
      border-bottom: 2px solid var(--soft-gray);
      padding-bottom: 20px;
      margin-bottom: 32px;
      letter-spacing: -0.3px;
      display: flex;
      align-items: center;
      gap: 12px;
    }

    h3::before {
      content: '\f05a';
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      font-size: 26px;
      color: var(--turquoise);
    }

    /* Ordered List Styling */
    ol {
      padding-left: 0;
      counter-reset: item;
      list-style: none;
    }

    ol > li {
      margin-bottom: 32px;
      padding-left: 48px;
      position: relative;
      counter-increment: item;
    }

    ol > li::before {
      content: counter(item);
      position: absolute;
      left: 0;
      top: 0;
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 16px;
      box-shadow: 0 4px 12px rgba(28, 167, 166, 0.3);
    }

    ol > li > b {
      color: var(--navy-blue);
      font-size: 18px;
      font-weight: 700;
      display: block;
      margin-bottom: 12px;
      letter-spacing: -0.2px;
    }

    /* Unordered List (nested) */
    ul {
      margin-top: 12px;
      padding-left: 0;
      list-style: none;
    }

    ul li {
      font-weight: 400;
      color: var(--text-dark);
      margin-bottom: 10px;
      position: relative;
      padding-left: 24px;
      line-height: 1.8;
    }

    ul li::before {
      content: "\f054";
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      font-size: 10px;
      color: var(--turquoise);
      position: absolute;
      left: 0;
      top: 7px;
    }

    /* Code Styling */
    code {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.08) 0%, rgba(252, 238, 209, 0.15) 100%);
      color: var(--coral-orange);
      padding: 4px 10px;
      border-radius: 6px;
      font-family: 'Courier New', 'Monaco', monospace;
      font-size: 0.9em;
      border: 1px solid rgba(255, 127, 80, 0.2);
      font-weight: 600;
      white-space: nowrap;
    }

    /* Tip Box */
    .tip-box {
      background: linear-gradient(135deg, var(--info-bg) 0%, rgba(224, 242, 241, 0.5) 100%);
      border-left: 5px solid var(--info-border);
      padding: 20px 24px;
      margin-top: 32px;
      border-radius: 12px;
      color: #00695C;
      font-size: 15px;
      line-height: 1.7;
      box-shadow: var(--shadow-sm);
      display: flex;
      align-items: flex-start;
      gap: 14px;
    }

    .tip-box i {
      font-size: 24px;
      color: #00897B;
      margin-top: 2px;
      flex-shrink: 0;
    }

    .tip-box b {
      color: #004D40;
      font-weight: 700;
    }

    /* Footer Action */
    .footer-action {
      margin-top: 36px;
      text-align: center;
      animation: fadeInUp 0.6s ease-out 0.3s both;
    }

    .btn-back {
      text-decoration: none;
      color: var(--white);
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 14px 32px;
      border-radius: 12px;
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 6px 20px rgba(27, 59, 111, 0.3);
      font-size: 14px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      position: relative;
      overflow: hidden;
    }

    .btn-back::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
      transition: left 0.6s ease;
    }

    .btn-back:hover::before {
      left: 100%;
    }

    .btn-back:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 30px rgba(27, 59, 111, 0.4);
    }

    .btn-back i {
      font-size: 16px;
      transition: transform 0.3s ease;
    }

    .btn-back:hover i {
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
        transform: translateY(30px);
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

      .header-section {
        padding: 24px 20px;
        margin-bottom: 28px;
      }

      h2 {
        font-size: 28px;
        flex-direction: column;
      }

      .header-section p {
        font-size: 14px;
      }

      .nav-tabs {
        flex-direction: column;
        gap: 12px;
      }

      .nav-link {
        justify-content: center;
        padding: 12px 24px;
      }

      .help-card {
        padding: 32px 24px;
      }

      h3 {
        font-size: 20px;
      }

      ol > li {
        padding-left: 44px;
        margin-bottom: 28px;
      }

      ol > li::before {
        width: 32px;
        height: 32px;
        font-size: 14px;
      }

      ol > li > b {
        font-size: 16px;
      }

      .tip-box {
        padding: 16px 20px;
        flex-direction: column;
        gap: 10px;
      }

      .btn-back {
        width: 100%;
        justify-content: center;
      }
    }

    @media (max-width: 480px) {
      h2 {
        font-size: 24px;
      }

      h2 i {
        font-size: 28px;
      }

      .help-card {
        padding: 24px 20px;
      }

      h3 {
        font-size: 18px;
        padding-bottom: 16px;
        margin-bottom: 24px;
      }

      ol > li {
        padding-left: 40px;
      }

      ol > li::before {
        width: 28px;
        height: 28px;
        font-size: 13px;
      }

      ol > li > b {
        font-size: 15px;
      }

      ul li {
        font-size: 14px;
      }

      code {
        font-size: 0.85em;
        padding: 3px 8px;
      }

      .tip-box {
        font-size: 14px;
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

  <div class="header-section">
    <h2><i class="fas fa-question-circle"></i> Help & Documentation</h2>
    <p>Complete System Guide & Support Resources</p>
  </div>

  <div class="nav-tabs">
    <% if (isAdmin) { %>
      <a href="<%= request.getContextPath() %>/Views/help.jsp?view=admin" 
         class="nav-link <%= "admin".equals(view) ? "active" : "" %>">
         <i class="fas fa-user-shield"></i> Admin Guide
      </a>
      
      <a href="<%= request.getContextPath() %>/Views/help.jsp?view=receptionist" 
         class="nav-link <%= "receptionist".equals(view) || "self".equals(view) ? "active" : "" %>">
         <i class="fas fa-concierge-bell"></i> Receptionist Guide
      </a>
    <% } else { %>
      <span class="nav-link active"><i class="fas fa-concierge-bell"></i> Receptionist Guide</span>
    <% } %>
  </div>

  <% if ((isAdmin && "admin".equals(view)) ) { %>
    <div class="help-card">
      <h3>Administrator Dashboard – Complete Guide</h3>
      <ol>
        <li>
          <b>Manage Room Types & Pricing</b>
          <ul>
            <li>Create new room categories and define pricing structures</li>
            <li>Update nightly rates for different room types</li>
            <li>Activate or deactivate room categories as needed</li>
          </ul>
        </li>
        <li>
          <b>Manage Room Inventory</b>
          <ul>
            <li>Add new rooms to the system and assign room types</li>
            <li>Set room status: <code>AVAILABLE</code> or <code>MAINTENANCE</code></li>
            <li>Remove or restore rooms (soft delete using <code>is_active</code> flag)</li>
          </ul>
        </li>
        <li>
          <b>Manage Receptionist Accounts</b>
          <ul>
            <li>Create new receptionist user accounts</li>
            <li>Set credentials and access permissions</li>
            <li>Activate or deactivate receptionist access</li>
          </ul>
        </li>
        <li>
          <b>Generate Business Reports</b>
          <ul>
            <li>Select custom date ranges for analysis</li>
            <li>View all reservations within the selected period</li>
            <li>Calculate total revenue generated</li>
            <li>Print or export reports for records</li>
          </ul>
        </li>
        <li>
          <b>Secure Logout</b>
          <ul><li>End your administrative session securely</li></ul>
        </li>
      </ol>
      
      <div class="tip-box">
        <i class="fas fa-lightbulb"></i>
        <div>
          <b>Important:</b> If a room type or specific room is marked as inactive, receptionists will not be able to create bookings for those items. Always ensure active inventory matches your operational capacity.
        </div>
      </div>
    </div>
  <% } %>

  <% if ((isReceptionist) || (isAdmin && "receptionist".equals(view)) || (isAdmin && "self".equals(view)) ) { %>
    <div class="help-card">
      <h3>Receptionist Dashboard – Step-by-Step Guide</h3>
      <ol>
        <li>
          <b>Create New Reservation</b>
          <ul>
            <li>Navigate to the <b>Add Reservation</b> form</li>
            <li>Enter guest information (name, contact details)</li>
            <li>Select preferred room type and date range</li>
            <li>Submit the form → System automatically assigns an available room</li>
          </ul>
        </li>

        <li>
          <b>Search & View Reservations</b>
          <ul>
            <li>Use the reservation number to search specific bookings</li>
            <li>View comprehensive reservation details</li>
            <li>Update or cancel reservations (only <code>ACTIVE</code> status)</li>
          </ul>
        </li>

        <li>
          <b>Update Existing Reservations</b>
          <ul>
            <li>Modify guest information and contact details</li>
            <li>Adjust check-in and check-out dates</li>
            <li>Changes only permitted for active bookings</li>
          </ul>
        </li>

        <li>
          <b>Generate Guest Bills</b>
          <ul>
            <li>Enter reservation number for checkout process</li>
            <li>System calculates: <code>Number of Nights × Nightly Rate</code></li>
            <li>Review billing details with guest</li>
            <li>Print final invoice for guest records</li>
          </ul>
        </li>

        <li>
          <b>Secure Logout</b>
          <ul><li>Always logout at the end of your shift for security</li></ul>
        </li>
      </ol>

      <div class="tip-box">
        <i class="fas fa-info-circle"></i>
        <div>
          <b>Pro Tip:</b> Always verify guest information before finalizing a reservation. Double-check dates and room type preferences to ensure a smooth check-in experience.
        </div>
      </div>
    </div>
  <% } %>

  <div class="footer-action">
    <% if (isAdmin) { %>
      <a href="<%= request.getContextPath() %>/Views/adminDashboard.jsp" class="btn-back">
        <i class="fas fa-arrow-left"></i> Return to Admin Dashboard
      </a>
    <% } else { %>
      <a href="<%= request.getContextPath() %>/Views/receptionistDashboard.jsp" class="btn-back">
        <i class="fas fa-arrow-left"></i> Return to Receptionist Dashboard
      </a>
    <% } %>
  </div>

</div>

</body>
</html>
