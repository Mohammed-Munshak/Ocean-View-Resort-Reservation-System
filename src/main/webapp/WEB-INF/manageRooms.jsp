<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ovr.model.Room" %>
<%@ page import="com.ovr.model.RoomType" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
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
      max-width: 1100px;
      animation: fadeIn 0.6s ease-out;
    }

    h2, h3 {
      font-family: 'Times New Roman', serif;
      color: var(--text-main);
      margin-top: 0;
    }

    .card {
      background: var(--card-bg);
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 5px 20px rgba(141, 110, 99, 0.1);
      margin-bottom: 30px;
      border-top: 4px solid var(--table-header);
    }

    .alert {
      padding: 15px;
      border-radius: 6px;
      margin-bottom: 20px;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .alert-success { 
      background-color: #E8F5E9; 
      color: var(--success-color); 
      border: 1px solid #C8E6C9; 
    }

    .alert-error { 
      background-color: #FFEBEE; 
      color: var(--error-color); 
      border: 1px solid #FFCDD2; 
    }

    .form-grid {
      display: flex;
      gap: 20px;
      align-items: flex-end;
      flex-wrap: wrap;
    }

    .form-group {
      flex: 1;
      min-width: 200px;
    }

    label {
      display: block;
      margin-bottom: 8px;
      font-size: 13px;
      font-weight: 600;
      color: #6D4C41;
      text-transform: uppercase;
    }

    input[type="text"], select {
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
      padding: 11px 25px;
      border-radius: 4px;
      cursor: pointer;
      font-weight: 600;
      transition: transform 0.2s;
      height: 40px;
    }
    
    .btn-add:hover { 
      transform: translateY(-2px); 
    }

    .table-responsive { 
      overflow-x: auto; 
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
      font-size: 14px;
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
      vertical-align: middle;
    }

    tr:nth-child(even) { 
      background-color: #FAF8F6; 
    }
    
    tr:hover { 
      background-color: #F1EFE9; 
    }

    .inline-form {
      display: flex;
      gap: 8px;
      align-items: center;
    }

    .select-status {
      padding: 6px;
      font-size: 13px;
      border-radius: 4px;
      border: 1px solid #CCC;
    }

    .btn-save {
      background-color: #8D6E63;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 12px;
    }

    .btn-save:hover { 
      background-color: #6D4C41; 
    }

    .btn-toggle {
      padding: 6px 12px;
      border-radius: 4px;
      border: none;
      font-weight: 600;
      font-size: 12px;
      cursor: pointer;
      width: 80px;
    }
    
    .btn-remove { 
      background-color: #FFEBEE; 
      color: #C62828; 
      border: 1px solid #FFCDD2; 
    }
    
    .btn-remove:hover { 
      background-color: #C62828; 
      color: white; 
    }

    .btn-restore { 
      background-color: #E8F5E9; 
      color: #2E7D32; 
      border: 1px solid #C8E6C9; 
    }
    
    .btn-restore:hover { 
      background-color: #2E7D32; 
      color: white; 
    }

    .badge {
      padding: 4px 8px;
      border-radius: 12px;
      font-size: 11px;
      font-weight: bold;
      text-transform: uppercase;
    }

    .badge-active { 
      background-color: #E8F5E9; 
      color: #2E7D32; 
    }
    
    .badge-inactive { 
      background-color: #FFEBEE; 
      color: #C62828; 
    }
    
    .status-available { 
      color: #2E7D32; 
      font-weight: bold; 
    }
    
    .status-maintenance { 
      color: #F57C00; 
      font-weight: bold; 
    }

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
    
    .back-link:hover { 
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

  <div class="header-row">
    <h2><i class="fas fa-door-open"></i> Manage Rooms</h2>
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
            <th>ID</th>
            <th>Room No</th>
            <th>Type</th>
            <th>Current Status</th>
            <th>Active</th>
            <th>Update Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% if (rooms != null) { for (Room rm : rooms) { %>
            <tr>
              <td>#<%= rm.getRoomId() %></td>
              <td><strong><%= rm.getRoomNumber() %></strong></td>
              <td><%= rm.getRoomTypeName() %></td>
              
              <td>
                <% if ("AVAILABLE".equals(rm.getStatus())) { %>
                  <span class="status-available"><i class="fas fa-check-circle"></i> Available</span>
                <% } else { %>
                  <span class="status-maintenance"><i class="fas fa-tools"></i> Maintenance</span>
                <% } %>
              </td>

              <td>
                <% if (rm.getIsActive() == 1) { %>
                  <span class="badge badge-active">Yes</span>
                <% } else { %>
                  <span class="badge badge-inactive">No</span>
                <% } %>
              </td>

              <td>
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

              <td>
                <form method="post" action="<%= request.getContextPath() %>/admin/rooms" style="margin:0;">
                  <input type="hidden" name="action" value="toggle" />
                  <input type="hidden" name="roomId" value="<%= rm.getRoomId() %>" />
                  <input type="hidden" name="newActive" value="<%= rm.getIsActive() == 1 ? 0 : 1 %>" />
                  
                  <% if (rm.getIsActive() == 1) { %>
                    <button type="submit" class="btn-toggle btn-remove">Remove</button>
                  <% } else { %>
                    <button type="submit" class="btn-toggle btn-restore">Restore</button>
                  <% } %>
                </form>
              </td>
            </tr>
          <% } } else { %>
            <tr>
              <td colspan="7" style="text-align:center; padding: 20px;">No rooms found.</td>
            </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>

</div>

</body>
</html>