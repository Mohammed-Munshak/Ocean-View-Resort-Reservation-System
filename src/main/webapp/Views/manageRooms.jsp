<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ovr.model.Room" %>
<%@ page import="com.ovr.model.RoomType" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
    return;
  }

  List<Room> rooms = (List<Room>) request.getAttribute("rooms");
  List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
  String error = (String) request.getAttribute("error");
  String success = (String) request.getAttribute("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Rooms | Ocean View Resort</title>
  
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
      --warning: #F59E0B;
      --warning-light: #FEF3C7;
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
      animation: fadeIn 0.6s ease-out;
    }

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

    .card {
      background: var(--white);
      padding: 42px 40px;
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      margin-bottom: 36px;
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
      height: 4px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    .card h3 {
      font-size: 24px;
      font-weight: 700;
      color: var(--navy-blue);
      margin-bottom: 32px;
      display: flex;
      align-items: center;
      gap: 14px;
      letter-spacing: -0.3px;
      padding-bottom: 20px;
      border-bottom: 2px solid var(--soft-gray);
    }

    .card h3 i {
      font-size: 26px;
      color: var(--turquoise);
    }

    /* Form Styles */
    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr auto;
      gap: 20px;
      align-items: end;
    }

    .form-group {
      display: flex;
      flex-direction: column;
    }

    label {
      display: block;
      margin-bottom: 10px;
      font-size: 13px;
      font-weight: 700;
      color: var(--text-dark);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    input[type="text"], 
    select {
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

    input[type="text"]:hover,
    select:hover {
      border-color: var(--turquoise);
    }

    input[type="text"]:focus,
    select:focus {
      outline: none;
      border-color: var(--turquoise);
      box-shadow: 0 0 0 4px rgba(28, 167, 166, 0.1);
      transform: translateY(-2px);
    }

    input::placeholder {
      color: #9CA3AF;
    }

    select {
      cursor: pointer;
      appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%231CA7A6' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right 14px center;
      padding-right: 40px;
    }

    .btn-add {
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border: none;
      padding: 14px 32px;
      border-radius: 12px;
      font-weight: 700;
      cursor: pointer;
      font-size: 14px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.3);
      position: relative;
      overflow: hidden;
      white-space: nowrap;
    }

    .btn-add::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
      transition: left 0.6s ease;
    }

    .btn-add:hover::before {
      left: 100%;
    }

    .btn-add:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 30px rgba(28, 167, 166, 0.4);
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
    }

    .btn-add:active {
      transform: translateY(-1px);
    }

    .table-responsive { 
      overflow-x: auto;
      border-radius: 16px;
      box-shadow: var(--shadow-sm);
    }

    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 14px;
      background: var(--white);
    }

    thead {
      background: linear-gradient(135deg, var(--navy-blue) 0%, #2C4F7F 100%);
    }

    th {
      color: var(--white);
      text-align: left;
      padding: 18px 20px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.8px;
      font-size: 12px;
      white-space: nowrap;
    }

    tbody tr {
      border-bottom: 1px solid rgba(27, 59, 111, 0.06);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    tbody tr:hover {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.03) 0%, rgba(252, 238, 209, 0.05) 100%);
      transform: translateX(2px);
      box-shadow: inset 4px 0 0 var(--turquoise);
    }

    tbody tr:last-child {
      border-bottom: none;
    }

    td {
      padding: 20px;
      color: var(--text-dark);
      vertical-align: middle;
    }

    td strong {
      color: var(--navy-blue);
      font-weight: 700;
      font-size: 15px;
    }

    td:first-child {
      color: var(--text-muted);
      font-family: 'Courier New', monospace;
      font-weight: 600;
      font-size: 13px;
    }

    .status-available {
      color: var(--success);
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 14px;
    }

    .status-available i {
      font-size: 16px;
    }

    .status-maintenance {
      color: var(--warning);
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 14px;
    }

    .status-maintenance i {
      font-size: 16px;
    }

    .badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .badge i {
      font-size: 8px;
      animation: pulse 2s ease-in-out infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.5; }
    }

    .badge-active {
      background: var(--success-light);
      color: var(--success);
      border: 2px solid var(--success);
    }

    .badge-inactive {
      background: var(--error-light);
      color: var(--error);
      border: 2px solid var(--error);
    }

    .inline-form {
      display: flex;
      gap: 10px;
      align-items: center;
    }

    .select-status {
      padding: 10px 36px 10px 14px;
      font-size: 13px;
      border-radius: 10px;
      border: 2px solid var(--border-light);
      background: var(--white);
      color: var(--text-dark);
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      appearance: none;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23FF7F50' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right 10px center;
    }

    .select-status:hover {
      border-color: var(--coral-orange);
    }

    .select-status:focus {
      outline: none;
      border-color: var(--coral-orange);
      box-shadow: 0 0 0 3px rgba(255, 127, 80, 0.1);
    }

    .btn-save {
      background: linear-gradient(135deg, var(--coral-orange) 0%, #FF6347 100%);
      color: var(--white);
      border: none;
      padding: 10px 16px;
      border-radius: 10px;
      cursor: pointer;
      font-size: 14px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 12px rgba(255, 127, 80, 0.3);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .btn-save:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(255, 127, 80, 0.4);
    }

    .btn-save i {
      font-size: 14px;
    }

    .btn-toggle {
      padding: 10px 18px;
      border-radius: 10px;
      border: none;
      font-weight: 700;
      font-size: 12px;
      cursor: pointer;
      text-transform: uppercase;
      letter-spacing: 0.4px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      min-width: 90px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
    }

    .btn-remove {
      background: var(--error-light);
      color: var(--error);
      border: 2px solid var(--error);
    }

    .btn-remove:hover {
      background: var(--error);
      color: var(--white);
      transform: translateY(-3px);
      box-shadow: 0 6px 16px rgba(239, 68, 68, 0.4);
    }

    .btn-restore {
      background: var(--success-light);
      color: var(--success);
      border: 2px solid var(--success);
    }

    .btn-restore:hover {
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

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
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

    @media (max-width: 1024px) {
      .form-grid {
        grid-template-columns: 1fr 1fr;
      }

      .form-grid > div:last-child {
        grid-column: 1 / -1;
      }

      .btn-add {
        width: 100%;
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

      .card {
        padding: 32px 24px;
      }

      .card h3 {
        font-size: 20px;
      }

      .form-grid {
        grid-template-columns: 1fr;
      }

      table {
        font-size: 13px;
      }

      th, td {
        padding: 12px 10px;
        font-size: 12px;
      }

      .select-status {
        padding: 8px 30px 8px 12px;
        font-size: 12px;
      }

      .btn-save {
        padding: 8px 12px;
      }

      .btn-toggle {
        min-width: 80px;
        padding: 8px 14px;
        font-size: 11px;
      }
    }

    @media (max-width: 480px) {
      .page-title {
        font-size: 18px;
      }

      .card {
        padding: 24px 20px;
      }

      .card h3 {
        font-size: 18px;
      }

      /* Mobile table view */
      .table-responsive {
        border-radius: 0;
      }

      table thead {
        display: none;
      }

      table, tbody, tr, td {
        display: block;
      }

      tbody tr {
        margin-bottom: 20px;
        border: 2px solid var(--border-light);
        border-radius: 16px;
        padding: 20px;
        background: var(--white);
        box-shadow: var(--shadow-sm);
      }

      tbody tr:hover {
        transform: translateX(0);
        box-shadow: var(--shadow-md);
      }

      td {
        padding: 10px 0;
        border: none;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      td::before {
        content: attr(data-label);
        font-weight: 700;
        text-transform: uppercase;
        font-size: 11px;
        color: var(--text-muted);
        letter-spacing: 0.5px;
      }

      .inline-form {
        width: 100%;
        justify-content: flex-end;
      }

      .btn-toggle {
        width: 100%;
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

<div class="top-nav">
  <div class="nav-content">
    <div class="page-title">
      <i class="fas fa-door-open"></i>
      <span>Room Management</span>
    </div>
    <a href="<%= request.getContextPath() %>/Views/adminDashboard.jsp" class="back-link">
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

  <div class="card">
    <h3><i class="fas fa-plus-circle"></i> Add New Room</h3>
    <form method="post" action="<%= request.getContextPath() %>/admin/rooms">
      <input type="hidden" name="action" value="add" />
      
      <div class="form-grid">
        <div class="form-group">
          <label>Room Number</label>
          <input type="text" name="roomNumber" placeholder="e.g. 101" required />
        </div>
        
        <div class="form-group">
          <label>Room Type</label>
          <select name="roomTypeId" required>
            <option value="">-- Select Type --</option>
            <% if (roomTypes != null) { for (RoomType rt : roomTypes) { %>
              <option value="<%= rt.getRoomTypeId() %>"><%= rt.getTypeName() %></option>
            <% } } %>
          </select>
        </div>
        
        <div>
          <button type="submit" class="btn-add">Add Room</button>
        </div>
      </div>
    </form>
  </div>

  <div class="card">
    <h3><i class="fas fa-list-ul"></i> Room Inventory</h3>
    <div class="table-responsive">
      <table>
        <thead>
          <tr>
            <th width="8%">ID</th>
            <th width="12%">Room No</th>
            <th width="18%">Type</th>
            <th width="16%">Current Status</th>
            <th width="10%">Active</th>
            <th width="20%">Update Status</th>
            <th width="12%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <% if (rooms != null && !rooms.isEmpty()) { for (Room rm : rooms) { %>
            <tr>
              <td data-label="ID">#<%= rm.getRoomId() %></td>
              <td data-label="Room No"><strong><%= rm.getRoomNumber() %></strong></td>
              <td data-label="Type"><%= rm.getRoomTypeName() %></td>
              
              <td data-label="Current Status">
                <% if ("AVAILABLE".equals(rm.getStatus())) { %>
                  <span class="status-available"><i class="fas fa-check-circle"></i> Available</span>
                <% } else { %>
                  <span class="status-maintenance"><i class="fas fa-tools"></i> Maintenance</span>
                <% } %>
              </td>

              <td data-label="Active">
                <% if (rm.getIsActive() == 1) { %>
                  <span class="badge badge-active"><i class="fas fa-circle"></i> Yes</span>
                <% } else { %>
                  <span class="badge badge-inactive"><i class="fas fa-circle"></i> No</span>
                <% } %>
              </td>

              <td data-label="Update Status">
                <form method="post" action="<%= request.getContextPath() %>/admin/rooms" class="inline-form">
                  <input type="hidden" name="action" value="status" />
                  <input type="hidden" name="roomId" value="<%= rm.getRoomId() %>" />
                  <select name="status" class="select-status">
                    <option value="AVAILABLE" <%= "AVAILABLE".equals(rm.getStatus()) ? "selected" : "" %>>Available</option>
                    <option value="MAINTENANCE" <%= "MAINTENANCE".equals(rm.getStatus()) ? "selected" : "" %>>Maintenance</option>
                  </select>
                  <button type="submit" class="btn-save" title="Save Status"><i class="fas fa-save"></i></button>
                </form>
              </td>

              <td data-label="Actions">
                <form method="post" action="<%= request.getContextPath() %>/admin/rooms" style="margin:0;">
                  <input type="hidden" name="action" value="toggle" />
                  <input type="hidden" name="roomId" value="<%= rm.getRoomId() %>" />
                  <input type="hidden" name="newActive" value="<%= rm.getIsActive() == 1 ? 0 : 1 %>" />
                  
                  <% if (rm.getIsActive() == 1) { %>
                    <button type="submit" class="btn-toggle btn-remove">
                      <i class="fas fa-ban"></i> Remove
                    </button>
                  <% } else { %>
                    <button type="submit" class="btn-toggle btn-restore">
                      <i class="fas fa-undo"></i> Restore
                    </button>
                  <% } %>
                </form>
              </td>
            </tr>
          <% } } else { %>
            <tr>
              <td colspan="7">
                <div class="empty-state">
                  <i class="fas fa-door-open"></i>
                  <p>No rooms found.</p>
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
