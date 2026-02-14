<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ovr.model.RoomType" %>
<%@ page import="com.ovr.model.Room" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
  List<Room> availableRooms = (List<Room>) request.getAttribute("availableRooms");

  String error = (String) request.getAttribute("error");
  String success = (String) request.getAttribute("success");

  Integer selectedRoomTypeId = (Integer) request.getAttribute("selectedRoomTypeId");
  String selectedCheckIn = (String) request.getAttribute("selectedCheckIn");
  String selectedCheckOut = (String) request.getAttribute("selectedCheckOut");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>New Reservation | Ocean View Resort</title>
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #8D6E63 0%, #6D4C41 100%);
      --bg-color: #F4F1EA;
      --card-bg: #FFFFFF;
      --text-main: #3E2723;
      --border-color: #D7CCC8;
      --focus-color: #8D6E63;
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

    .card {
      background: var(--card-bg);
      border-radius: 12px;
      padding: 30px;
      box-shadow: 0 5px 20px rgba(141, 110, 99, 0.1);
      margin-bottom: 25px;
      border-top: 4px solid #8D6E63;
    }

    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    h2 {
      margin: 0;
      font-family: 'Times New Roman', serif;
      font-size: 28px;
      color: var(--text-main);
    }

    h3 {
      margin-top: 0;
      font-size: 18px;
      color: #5D4037;
      border-bottom: 1px solid #EEE;
      padding-bottom: 10px;
      margin-bottom: 20px;
    }

    .search-grid {
      display: grid;
      grid-template-columns: 2fr 1fr 1fr auto;
      gap: 15px;
      align-items: end;
    }

    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }

    .full-width { 
      grid-column: span 2; 
     
    }

    label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      font-size: 13px;
      color: #6D4C41;
      text-transform: uppercase;
    }

    input, select {
      width: 100%;
      padding: 12px;
      border: 1px solid var(--border-color);
      border-radius: 6px;
      font-size: 14px;
      background-color: #FAFAFA;
      box-sizing: border-box;
      font-family: inherit;
    }

    input:focus, select:focus {
      outline: none;
      border-color: var(--focus-color);
      background-color: #fff;
      box-shadow: 0 0 0 3px rgba(141, 110, 99, 0.1);
    }

    .btn-check {
      background-color: #5D4037;
      color: white;
      border: none;
      padding: 13px 25px;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 600;
      transition: background 0.3s;
      height: 44px; /* Align with inputs */
    }

    .btn-check:hover { 
      background-color: #3E2723; 
    }

    .btn-submit {
      width: 100%;
      padding: 14px;
      background: var(--primary-gradient);
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      margin-top: 10px;
      transition: transform 0.2s;
    }
    
    .btn-submit:hover { 
      transform: translateY(-2px); 
    }

    .alert {
      padding: 15px;
      border-radius: 6px;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 14px;
    }

    .alert-error { 
      background-color: #FFEBEE; 
      color: #C62828; 
      border: 1px solid #FFCDD2; 
    }
    
    .alert-success { 
      background-color: #E8F5E9; 
      color: #2E7D32; 
      border: 1px solid #C8E6C9; 
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

    @keyframes fadeIn { from { 
      opacity: 0; 
      transform: translateY(10px); 
    } to { 
      opacity: 1; 
      transform: translateY(0); 
    } }

    @media (max-width: 768px) {
      .search-grid { 
      grid-template-columns: 1fr; 
     }
     
      .form-grid { 
      grid-template-columns: 1fr; 
     }
     
      .full-width { 
      grid-column: span 1; 
     }
     
      .btn-check { 
      width: 100%; 
     }
   }
  </style>
</head>
<body>

<div class="container">

  <div class="header-row">
    <h2><i class="fas fa-calendar-plus"></i> Add Reservation</h2>
    <a href="<%= request.getContextPath() %>/receptionistDashboard.jsp" class="back-link">
      <i class="fas fa-arrow-left"></i> Dashboard
    </a>
  </div>

  <% if (error != null) { %>
    <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
  <% } %>
  <% if (success != null) { %>
    <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= success %></div>
  <% } %>

  <div class="card">
    <h3><span style="color:#8D6E63;">01.</span> Check Availability</h3>
    
    <form method="post" action="<%= request.getContextPath() %>/reservation/available">
      <div class="search-grid">
        
        <div>
          <label>Room Category</label>
          <select name="roomTypeId" required>
            <option value="">-- Select Room Type --</option>
            <% if (roomTypes != null) {
                 for (RoomType rt : roomTypes) { %>
              <option value="<%= rt.getRoomTypeId() %>"
                <%= (selectedRoomTypeId != null && selectedRoomTypeId == rt.getRoomTypeId()) ? "selected" : "" %>>
                <%= rt.getTypeName() %> (LKR <%= rt.getRatePerNight() %>)
              </option>
            <% } } %>
          </select>
        </div>

        <div>
          <label>Check In</label>
          <input type="date" name="checkIn" value="<%= selectedCheckIn == null ? "" : selectedCheckIn %>" required>
        </div>

        <div>
          <label>Check Out</label>
          <input type="date" name="checkOut" value="<%= selectedCheckOut == null ? "" : selectedCheckOut %>" required>
        </div>

        <div>
          <label style="opacity:0">Check</label>
          <button type="submit" class="btn-check">
            <i class="fas fa-search"></i> Check
          </button>
        </div>

      </div>
    </form>
  </div>

  <% if (availableRooms != null) { %>
    
    <div class="card" style="animation: fadeIn 0.5s ease-out;">
      <h3><span style="color:#8D6E63;">02.</span> Select Room & Guest Info</h3>

      <% if (availableRooms.isEmpty()) { %>
        <div class="alert alert-error">
          <i class="fas fa-times-circle"></i> Sorry, no rooms are available for the selected dates. Please try different dates.
        </div>
      <% } else { %>

        <form method="post" action="<%= request.getContextPath() %>/reservation/add">
          
          <input type="hidden" name="roomTypeId" value="<%= selectedRoomTypeId %>" />
          <input type="hidden" name="checkIn" value="<%= selectedCheckIn %>" />
          <input type="hidden" name="checkOut" value="<%= selectedCheckOut %>" />

          <div class="form-grid">
            
            <div class="full-width">
              <label>Select Available Room</label>
              <select name="roomId" required style="border: 2px solid #8D6E63; background-color: #fffaf5;">
                <option value="">-- Choose a Room Number --</option>
                <% for (Room rm : availableRooms) { %>
                  <option value="<%= rm.getRoomId() %>">
                    Room <%= rm.getRoomNumber() %>
                  </option>
                <% } %>
              </select>
            </div>

            <div>
              <label>Guest Full Name</label>
              <input type="text" name="guestName" placeholder="e.g. John Doe" required>
            </div>

            <div>
              <label>Contact Number</label>
              <input type="text" name="guestContact" placeholder="e.g. 077-1234567" required>
            </div>

            <div class="full-width">
              <label>Guest Address</label>
              <input type="text" name="guestAddress" placeholder="Home Address">
            </div>

            <div class="full-width">
              <button type="submit" class="btn-submit">
                <i class="fas fa-check"></i> Confirm Reservation
              </button>
            </div>

          </div>
        </form>

      <% } %>
    </div>
  <% } %>

</div>

</body>
</html>