<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ovr.model.User" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  List<User> receptionists = (List<User>) request.getAttribute("receptionists");
  String error = (String) request.getAttribute("error");
  String success = (String) request.getAttribute("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Receptionists | Ocean View Resort</title>
  
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
      --warning: #F59E0B;
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
      padding: 0;
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

    /* Premium Navigation Header */
    .top-nav {
      background: linear-gradient(135deg, var(--navy-blue) 0%, #2C4F7F 100%);
      padding: 0;
      box-shadow: var(--shadow-lg);
      position: sticky;
      top: 0;
      z-index: 100;
      border-bottom: 2px solid rgba(28, 167, 166, 0.3);
    }

    .nav-content {
      max-width: 1400px;
      margin: 0 auto;
      padding: 20px 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .page-title {
      color: var(--white);
      font-size: 24px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 14px;
      letter-spacing: -0.3px;
    }

    .page-title i {
      font-size: 26px;
      color: var(--turquoise);
    }

    .back-link {
      text-decoration: none;
      color: var(--white);
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 11px 24px;
      border-radius: 10px;
      background: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.2);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      font-size: 14px;
    }

    .back-link:hover {
      background: rgba(255, 255, 255, 0.18);
      transform: translateX(-4px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .back-link i {
      transition: transform 0.3s ease;
    }

    .back-link:hover i {
      transform: translateX(-3px);
    }

    .container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 40px;
      position: relative;
      z-index: 1;
    }

    /* Alert Messages */
    .alert {
      padding: 18px 24px;
      border-radius: 14px;
      margin-bottom: 32px;
      display: flex;
      align-items: center;
      gap: 14px;
      font-size: 15px;
      font-weight: 500;
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

    /* Add Staff Form Section */
    .add-section {
      background: var(--white);
      padding: 42px 40px;
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      margin-bottom: 36px;
      border: 1px solid rgba(27, 59, 111, 0.08);
      animation: fadeInUp 0.6s ease-out;
      position: relative;
      overflow: hidden;
    }

    .add-section::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    .section-header {
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 2px solid var(--soft-gray);
    }

    .section-header i {
      font-size: 28px;
      color: var(--turquoise);
    }

    .section-header h3 {
      font-size: 24px;
      font-weight: 700;
      color: var(--navy-blue);
      letter-spacing: -0.3px;
    }

    .form-row {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 24px;
      margin-bottom: 28px;
    }

    .form-group {
      display: flex;
      flex-direction: column;
    }

    .form-label {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-dark);
      margin-bottom: 10px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      display: flex;
      align-items: center;
      gap: 7px;
    }

    .form-label i {
      font-size: 13px;
      color: var(--turquoise);
    }

    .form-input {
      width: 100%;
      padding: 14px 18px;
      border: 2px solid var(--border-light);
      border-radius: 12px;
      font-size: 15px;
      color: var(--text-dark);
      background: var(--white);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      font-family: inherit;
    }

    .form-input:hover {
      border-color: var(--turquoise);
    }

    .form-input:focus {
      outline: none;
      border-color: var(--turquoise);
      box-shadow: 0 0 0 4px rgba(28, 167, 166, 0.1);
      transform: translateY(-2px);
    }

    .form-input::placeholder {
      color: #9CA3AF;
    }

    .form-helper {
      font-size: 12px;
      color: var(--text-muted);
      margin-top: 6px;
      font-style: italic;
    }

    .btn-submit {
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border: none;
      padding: 16px 36px;
      border-radius: 12px;
      font-size: 15px;
      font-weight: 700;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 12px;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.3);
      text-transform: uppercase;
      letter-spacing: 0.5px;
      position: relative;
      overflow: hidden;
    }

    .btn-submit::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
      transition: left 0.6s ease;
    }

    .btn-submit:hover::before {
      left: 100%;
    }

    .btn-submit:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 30px rgba(28, 167, 166, 0.4);
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
    }

    .btn-submit:active {
      transform: translateY(-1px);
    }

    .btn-submit i {
      font-size: 18px;
    }

    /* Staff Directory Section */
    .directory-section {
      background: var(--white);
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      border: 1px solid rgba(27, 59, 111, 0.08);
      overflow: hidden;
      animation: fadeInUp 0.6s ease-out 0.1s both;
      position: relative;
    }

    .directory-section::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--coral-orange) 0%, var(--turquoise) 100%);
    }

    .directory-header {
      padding: 32px 40px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.05) 100%);
      border-bottom: 2px solid var(--soft-gray);
    }

    .directory-header h3 {
      font-size: 24px;
      font-weight: 700;
      color: var(--navy-blue);
      display: flex;
      align-items: center;
      gap: 14px;
      letter-spacing: -0.3px;
    }

    .directory-header i {
      font-size: 28px;
      color: var(--coral-orange);
    }

    .table-container {
      overflow-x: auto;
      padding: 0;
    }

    .staff-table {
      width: 100%;
      border-collapse: collapse;
    }

    .staff-table thead {
      background: linear-gradient(135deg, var(--navy-blue) 0%, #2C4F7F 100%);
    }

    .staff-table th {
      padding: 18px 24px;
      text-align: left;
      font-size: 13px;
      font-weight: 700;
      color: var(--white);
      text-transform: uppercase;
      letter-spacing: 0.8px;
      white-space: nowrap;
    }

    .staff-table tbody tr {
      border-bottom: 1px solid rgba(27, 59, 111, 0.08);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .staff-table tbody tr:hover {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.03) 0%, rgba(252, 238, 209, 0.05) 100%);
      transform: translateX(2px);
      box-shadow: inset 4px 0 0 var(--turquoise);
    }

    .staff-table tbody tr:last-child {
      border-bottom: none;
    }

    .staff-table td {
      padding: 22px 24px;
      font-size: 15px;
      color: var(--text-dark);
      vertical-align: middle;
    }

    .staff-id {
      font-weight: 700;
      color: var(--navy-blue);
      font-family: 'Courier New', monospace;
      font-size: 14px;
      background: rgba(27, 59, 111, 0.06);
      padding: 4px 10px;
      border-radius: 6px;
      display: inline-block;
    }

    .staff-username {
      font-weight: 700;
      color: var(--text-dark);
    }

    .staff-name {
      color: var(--text-muted);
      font-weight: 500;
    }

    .staff-contact {
      color: var(--text-muted);
      font-family: 'Courier New', monospace;
      font-size: 14px;
      background: rgba(107, 114, 128, 0.06);
      padding: 4px 10px;
      border-radius: 6px;
      display: inline-block;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      padding: 8px 16px;
      border-radius: 24px;
      font-size: 12px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      transition: all 0.3s ease;
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
      box-shadow: 0 2px 8px rgba(5, 150, 105, 0.2);
    }

    .status-inactive {
      background: var(--error-light);
      color: var(--error);
      border: 2px solid var(--error);
      box-shadow: 0 2px 8px rgba(239, 68, 68, 0.2);
    }

    /* Premium Action Buttons */
    .btn-action {
      padding: 10px 18px;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      font-size: 13px;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      text-transform: uppercase;
      letter-spacing: 0.4px;
    }

    .btn-action i {
      font-size: 13px;
    }

    .btn-deactivate {
      background: var(--error-light);
      color: var(--error);
      border: 2px solid var(--error);
    }

    .btn-deactivate:hover {
      background: var(--error);
      color: var(--white);
      transform: translateY(-3px);
      box-shadow: 0 6px 16px rgba(239, 68, 68, 0.4);
    }

    .btn-activate {
      background: var(--success-light);
      color: var(--success);
      border: 2px solid var(--success);
    }

    .btn-activate:hover {
      background: var(--success);
      color: var(--white);
      transform: translateY(-3px);
      box-shadow: 0 6px 16px rgba(5, 150, 105, 0.4);
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

    /* Smooth Animations */
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

    /* Responsive Design */
    @media (max-width: 1024px) {
      .container {
        padding: 30px 24px;
      }

      .add-section {
        padding: 34px 28px;
      }

      .directory-header {
        padding: 28px 28px;
      }

      .form-row {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 768px) {
      .nav-content {
        padding: 16px 24px;
        flex-direction: column;
        gap: 14px;
        align-items: stretch;
      }

      .page-title {
        font-size: 20px;
      }

      .back-link {
        justify-content: center;
      }

      .container {
        padding: 24px 20px;
      }

      .add-section {
        padding: 28px 24px;
      }

      .directory-header {
        padding: 24px;
      }

      .section-header h3,
      .directory-header h3 {
        font-size: 20px;
      }

      .staff-table {
        font-size: 14px;
      }

      .staff-table th,
      .staff-table td {
        padding: 14px 12px;
        font-size: 13px;
      }

      .btn-action {
        padding: 8px 14px;
        font-size: 12px;
      }
    }

    @media (max-width: 480px) {
      .page-title {
        font-size: 18px;
      }

      .back-link {
        padding: 10px 20px;
        font-size: 13px;
      }

      .form-row {
        gap: 20px;
      }

      .btn-submit {
        width: 100%;
        justify-content: center;
      }

      .staff-table th,
      .staff-table td {
        padding: 12px 10px;
      }

      .staff-table thead {
        display: none;
      }

      .staff-table tbody tr {
        display: block;
        margin-bottom: 20px;
        border: 2px solid var(--border-light);
        border-radius: 16px;
        padding: 20px;
        background: var(--white);
        box-shadow: var(--shadow-sm);
      }

      .staff-table tbody tr:hover {
        transform: translateX(0);
        box-shadow: var(--shadow-md);
      }

      .staff-table td {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border: none;
      }

      .staff-table td::before {
        content: attr(data-label);
        font-weight: 700;
        text-transform: uppercase;
        font-size: 11px;
        color: var(--text-muted);
        letter-spacing: 0.5px;
      }

      .btn-action {
        width: 100%;
        justify-content: center;
      }
    }

    /* Premium Selection Color */
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
  <div class="top-nav">
    <div class="nav-content">
      <div class="page-title">
        <i class="fas fa-users-cog"></i>
        <span>Manage Receptionists</span>
      </div>
      <a href="<%= request.getContextPath() %>/adminDashboard.jsp" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
      </a>
    </div>
  </div>

  <div class="container">

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

    <div class="add-section">
      <div class="section-header">
        <i class="fas fa-user-plus"></i>
        <h3>Add New Receptionist</h3>
      </div>

      <form method="post" action="<%= request.getContextPath() %>/admin/receptionists">
        <input type="hidden" name="action" value="add" />
        
        <div class="form-row">
          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-user"></i>
              Username
            </label>
            <input type="text" name="username" class="form-input" placeholder="Enter username" required />
          </div>

          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-lock"></i>
              Password
            </label>
            <input type="text" name="password" class="form-input" placeholder="Enter password" required />
          </div>

          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-id-card"></i>
              Full Name
            </label>
            <input type="text" name="fullName" class="form-input" placeholder="Enter full name" />
          </div>

          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-phone"></i>
              Contact No
            </label>
            <input type="text" name="contactNo" class="form-input" placeholder="Enter contact number" />
            <span class="form-helper">Optional: Staff contact information</span>
          </div>
        </div>

        <button type="submit" class="btn-submit">
          <i class="fas fa-plus-circle"></i>
          Add Staff Member
        </button>
      </form>
    </div>

    <div class="directory-section">
      <div class="directory-header">
        <h3>
          <i class="fas fa-list"></i>
          Staff Directory
        </h3>
      </div>

      <div class="table-container">
        <table class="staff-table">
          <thead>
            <tr>
              <th width="8%">ID</th>
              <th width="18%">Username</th>
              <th width="25%">Full Name</th>
              <th width="20%">Contact</th>
              <th width="12%">Status</th>
              <th width="17%">Action</th>
            </tr>
          </thead>
          <tbody>
            <% if (receptionists != null && !receptionists.isEmpty()) { 
                 for (User u : receptionists) { %>
              <tr>
                <td data-label="ID">
                  <span class="staff-id">#<%= u.getUserId() %></span>
                </td>
                <td data-label="Username">
                  <span class="staff-username"><%= u.getUsername() %></span>
                </td>
                <td data-label="Full Name">
                  <span class="staff-name"><%= u.getFullName() == null ? "-" : u.getFullName() %></span>
                </td>
                <td data-label="Contact">
                  <span class="staff-contact"><%= u.getContactNo() == null ? "-" : u.getContactNo() %></span>
                </td>
                <td data-label="Status">
                  <% if (u.isActive()) { %>
                    <span class="status-badge status-active">
                      <i class="fas fa-circle"></i> Active
                    </span>
                  <% } else { %>
                    <span class="status-badge status-inactive">
                      <i class="fas fa-circle"></i> Inactive
                    </span>
                  <% } %>
                </td>
                <td data-label="Action">
                  <form method="post" action="<%= request.getContextPath() %>/admin/receptionists" style="margin:0;">
                    <input type="hidden" name="action" value="toggle" />
                    <input type="hidden" name="userId" value="<%= u.getUserId() %>" />
                    <input type="hidden" name="newActive" value="<%= u.isActive() ? 0 : 1 %>" />
                    
                    <% if (u.isActive()) { %>
                      <button type="submit" class="btn-action btn-deactivate">
                        <i class="fas fa-ban"></i> Deactivate
                      </button>
                    <% } else { %>
                      <button type="submit" class="btn-action btn-activate">
                        <i class="fas fa-check"></i> Activate
                      </button>
                    <% } %>
                  </form>
                </td>
              </tr>
            <% } 
            } else { %>
              <tr>
                <td colspan="6">
                  <div class="empty-state">
                    <i class="fas fa-users"></i>
                    <p>No receptionists found in the system.</p>
                  </div>
                </td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

  </div>

</body>
</html>
