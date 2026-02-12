<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ovr.model.User" %>

<%
  // --- BACKEND LOGIC PRESERVED ---
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
    /* --- THEME --- */
    :root {
      --primary-gradient: linear-gradient(135deg, #8D6E63 0%, #6D4C41 100%);
      --bg-color: #F4F1EA;
      --card-bg: #FFFFFF;
      --text-main: #3E2723;
      --border-color: #D7CCC8;
      --table-header: #8D6E63;
      --success-color: #2E7D32;
      --error-color: #C62828;
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
      max-width: 1000px;
      animation: fadeIn 0.6s ease-out;
    }

    h2, h3 {
      font-family: 'Times New Roman', serif;
      color: var(--text-main);
      margin-top: 0;
    }

    /* --- CARDS --- */
    .card {
      background: var(--card-bg);
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 5px 20px rgba(141, 110, 99, 0.1);
      margin-bottom: 30px;
      border-top: 4px solid var(--table-header);
    }

    /* --- ALERTS --- */
    .alert {
      padding: 15px;
      border-radius: 6px;
      margin-bottom: 20px;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .alert-success { background-color: #E8F5E9; color: var(--success-color); border: 1px solid #C8E6C9; }
    .alert-error { background-color: #FFEBEE; color: var(--error-color); border: 1px solid #FFCDD2; }

    /* --- ADD FORM --- */
    .form-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
      align-items: end;
    }

    label {
      display: block;
      margin-bottom: 8px;
      font-size: 13px;
      font-weight: 600;
      color: #6D4C41;
      text-transform: uppercase;
    }

    input[type="text"] {
      width: 100%;
      padding: 10px;
      border: 1px solid var(--border-color);
      border-radius: 4px;
      box-sizing: border-box;
      background-color: #FAFAFA;
    }

    .btn-add {
      background: var(--primary-gradient);
      color: white;
      border: none;
      padding: 11px 20px;
      border-radius: 4px;
      cursor: pointer;
      font-weight: 600;
      width: 100%;
      transition: transform 0.2s;
    }
    .btn-add:hover { transform: translateY(-2px); }

    /* --- TABLE STYLES --- */
    .table-responsive {
      overflow-x: auto;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
      font-size: 15px;
    }

    th {
      background-color: var(--table-header);
      color: white;
      text-align: left;
      padding: 12px 15px;
      font-weight: 600;
    }

    td {
      padding: 12px 15px;
      border-bottom: 1px solid #EEE;
      color: #555;
    }

    tr:nth-child(even) { background-color: #FAF8F6; }
    tr:hover { background-color: #F1EFE9; }

    /* --- STATUS BADGES --- */
    .status-badge {
      padding: 4px 10px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: bold;
    }
    .status-active { background-color: #E8F5E9; color: #2E7D32; }
    .status-inactive { background-color: #FFEBEE; color: #C62828; }

    /* --- ACTION BUTTONS --- */
    .btn-action {
      padding: 6px 12px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 12px;
      font-weight: 600;
      transition: background 0.3s;
    }

    .btn-deactivate {
      background-color: #FFEBEE;
      color: #C62828;
      border: 1px solid #FFCDD2;
    }
    .btn-deactivate:hover { background-color: #C62828; color: white; }

    .btn-activate {
      background-color: #E8F5E9;
      color: #2E7D32;
      border: 1px solid #C8E6C9;
    }
    .btn-activate:hover { background-color: #2E7D32; color: white; }

    /* --- HEADER ROW --- */
    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .back-link {
      text-decoration: none;
      color: #8D6E63;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 5px;
    }
    .back-link:hover { color: #5D4037; }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

<div class="container">
  
  <div class="header-row">
    <h2><i class="fas fa-users-cog"></i> Manage Receptionists</h2>
    <a href="<%= request.getContextPath() %>/adminDashboard.jsp" class="back-link">
      <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <% if (error != null) { %>
    <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
  <% } %>
  <% if (success != null) { %>
    <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= success %></div>
  <% } %>

  <div class="card">
    <h3><i class="fas fa-user-plus"></i> Add New Receptionist</h3>
    
    <form method="post" action="<%= request.getContextPath() %>/admin/receptionists">
      <input type="hidden" name="action" value="add" />
      
      <div class="form-grid">
        <div>
          <label>Username</label>
          <input type="text" name="username" required placeholder="Login ID" />
        </div>
        <div>
          <label>Password</label>
          <input type="text" name="password" required placeholder="Secure Password" />
        </div>
        <div>
          <label>Full Name</label>
          <input type="text" name="fullName" placeholder="Staff Name" />
        </div>
        <div>
          <label>Contact No</label>
          <input type="text" name="contactNo" placeholder="Phone Number" />
        </div>
        <div>
          <button type="submit" class="btn-add">
            <i class="fas fa-plus-circle"></i> Add Staff
          </button>
        </div>
      </div>
    </form>
  </div>

  <div class="card">
    <h3><i class="fas fa-list"></i> Staff Directory</h3>
    
    <div class="table-responsive">
      <table>
        <thead>
          <tr>
            <th width="5%">ID</th>
            <th width="15%">Username</th>
            <th width="25%">Full Name</th>
            <th width="20%">Contact</th>
            <th width="10%">Status</th>
            <th width="15%">Action</th>
          </tr>
        </thead>
        <tbody>
          <% if (receptionists != null) { for (User u : receptionists) { %>
            <tr>
              <td>#<%= u.getUserId() %></td>
              <td><strong><%= u.getUsername() %></strong></td>
              <td><%= u.getFullName() == null ? "-" : u.getFullName() %></td>
              <td><%= u.getContactNo() == null ? "-" : u.getContactNo() %></td>
              
              <td>
                <% if (u.isActive()) { %>
                  <span class="status-badge status-active">Active</span>
                <% } else { %>
                  <span class="status-badge status-inactive">Inactive</span>
                <% } %>
              </td>

              <td>
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
          <% } } else { %>
            <tr>
              <td colspan="6" style="text-align:center; padding: 20px;">No receptionists found.</td>
            </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>

</div>

</body>
</html>