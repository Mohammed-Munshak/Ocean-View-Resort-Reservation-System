<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ovr.model.RoomType" %>
<%@ page import="com.ovr.model.Room" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
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

    /* Header */
    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 32px;
      padding: 24px 32px;
      background: var(--white);
      border-radius: 20px;
      box-shadow: var(--shadow-lg);
      border: 1px solid rgba(27, 59, 111, 0.08);
      position: relative;
      overflow: hidden;
      animation: fadeInDown 0.6s ease-out;
    }

    .header-row::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    h2 {
      margin: 0;
      font-size: 32px;
      font-weight: 700;
      color: var(--navy-blue);
      display: flex;
      align-items: center;
      gap: 14px;
      letter-spacing: -0.5px;
    }

    h2 i {
      font-size: 34px;
      color: var(--turquoise);
    }

    .back-link {
      text-decoration: none;
      color: var(--navy-blue);
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 10px 20px;
      border-radius: 10px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.1) 100%);
      border: 2px solid var(--border-light);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      font-size: 14px;
    }

    .back-link:hover {
      background: var(--navy-blue);
      color: var(--white);
      border-color: var(--navy-blue);
      transform: translateX(-4px);
      box-shadow: var(--shadow-md);
    }

    .back-link i {
      transition: transform 0.3s ease;
    }

    .back-link:hover i {
      transform: translateX(-3px);
    }

    /* Alert Messages */
    .alert {
      padding: 18px 24px;
      border-radius: 14px;
      margin-bottom: 28px;
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

    .alert-error {
      background: var(--error-light);
      color: var(--error);
      border-left: 5px solid var(--error);
    }

    .alert-success {
      background: var(--success-light);
      color: var(--success);
      border-left: 5px solid var(--success);
    }

    /* Card Styles */
    .card {
      background: var(--white);
      border-radius: 20px;
      padding: 40px;
      box-shadow: var(--shadow-lg);
      margin-bottom: 32px;
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
      height: 5px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
    }

    h3 {
      margin-top: 0;
      font-size: 22px;
      font-weight: 700;
      color: var(--navy-blue);
      border-bottom: 2px solid var(--soft-gray);
      padding-bottom: 18px;
      margin-bottom: 28px;
      display: flex;
      align-items: center;
      gap: 12px;
      letter-spacing: -0.3px;
    }

    h3 span {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border-radius: 50%;
      font-size: 16px;
      font-weight: 700;
      box-shadow: 0 4px 12px rgba(28, 167, 166, 0.3);
    }

    /* Form Grid */
    .search-grid {
      display: grid;
      grid-template-columns: 2fr 1fr 1fr auto;
      gap: 20px;
      align-items: end;
    }

    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
    }

    .full-width {
      grid-column: span 2;
    }

    /* Form Elements */
    label {
      display: block;
      margin-bottom: 10px;
      font-weight: 700;
      font-size: 13px;
      color: var(--text-dark);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    input, 
    select {
      width: 100%;
      padding: 14px 18px;
      border: 2px solid var(--border-light);
      border-radius: 12px;
      font-size: 15px;
      background: var(--white);
      color: var(--text-dark);
      box-sizing: border-box;
      font-family: inherit;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    input:hover,
    select:hover {
      border-color: var(--turquoise);
    }

    input:focus, 
    select:focus {
      outline: none;
      border-color: var(--turquoise);
      background: var(--white);
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

    /* Special styling for available room select */
    select[name="roomId"] {
      border: 2px solid var(--turquoise);
      background-color: rgba(28, 167, 166, 0.03);
      font-weight: 600;
    }

    select[name="roomId"]:focus {
      background-color: var(--white);
      box-shadow: 0 0 0 4px rgba(28, 167, 166, 0.15);
    }

    /* Check Button */
    .btn-check {
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
      color: var(--white);
      border: none;
      padding: 14px 28px;
      border-radius: 12px;
      cursor: pointer;
      font-weight: 700;
      font-size: 14px;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      height: 48px;
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.3);
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      position: relative;
      overflow: hidden;
    }

    .btn-check::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
      transition: left 0.6s ease;
    }

    .btn-check:hover::before {
      left: 100%;
    }

    .btn-check:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 30px rgba(28, 167, 166, 0.4);
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
    }

    .btn-check:active {
      transform: translateY(-1px);
    }

    .btn-check i {
      font-size: 16px;
    }

    /* Submit Button */
    .btn-submit {
      width: 100%;
      padding: 18px;
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border: none;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      margin-top: 12px;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.3);
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      text-transform: uppercase;
      letter-spacing: 0.8px;
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
        transform: translateY(40px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
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

    /* Responsive Design */
    @media (max-width: 768px) {
      body {
        padding: 24px 16px;
      }

      .header-row {
        flex-direction: column;
        gap: 16px;
        align-items: stretch;
        padding: 20px 24px;
      }

      h2 {
        font-size: 26px;
      }

      .back-link {
        justify-content: center;
      }

      .card {
        padding: 28px 24px;
        border-radius: 16px;
      }

      h3 {
        font-size: 19px;
      }

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

    @media (max-width: 480px) {
      h2 {
        font-size: 22px;
        flex-wrap: wrap;
      }

      h2 i {
        font-size: 28px;
      }

      .card {
        padding: 24px 20px;
      }

      h3 {
        font-size: 17px;
        flex-wrap: wrap;
      }

      h3 span {
        width: 32px;
        height: 32px;
        font-size: 14px;
      }

      input,
      select {
        padding: 12px 16px;
        font-size: 14px;
      }

      .btn-check,
      .btn-submit {
        padding: 14px 20px;
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

  <div class="header-row">
    <h2><i class="fas fa-calendar-plus"></i> Create New Reservation</h2>
    <a href="<%= request.getContextPath() %>/Views/receptionistDashboard.jsp" class="back-link">
      <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <% if (error != null) { %>
    <div class="alert alert-error">
      <i class="fas fa-exclamation-circle"></i> <%= error %>
    </div>
  <% } %>
  <% if (success != null) { %>
    <div class="alert alert-success">
      <i class="fas fa-check-circle"></i> <%= success %>
    </div>
  <% } %>

  <div class="card">
    <h3><span>01</span> Check Room Availability</h3>
    
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
          <label>Check-In Date</label>
          <input type="date" name="checkIn" value="<%= selectedCheckIn == null ? "" : selectedCheckIn %>" required>
        </div>

        <div>
          <label>Check-Out Date</label>
          <input type="date" name="checkOut" value="<%= selectedCheckOut == null ? "" : selectedCheckOut %>" required>
        </div>

        <div>
          <label style="opacity:0">Check</label>
          <button type="submit" class="btn-check">
            <i class="fas fa-search"></i> Search
          </button>
        </div>

      </div>
    </form>
  </div>

  <% if (availableRooms != null) { %>
    
    <div class="card" style="animation: fadeInUp 0.6s ease-out;">
      <h3><span>02</span> Guest Information & Room Selection</h3>

      <% if (availableRooms.isEmpty()) { %>
        <div class="alert alert-error">
          <i class="fas fa-times-circle"></i> No rooms available for the selected dates and room type. Please try different dates or room categories.
        </div>
      <% } else { %>

        <form method="post" action="<%= request.getContextPath() %>/reservation/add">
          
          <input type="hidden" name="roomTypeId" value="<%= selectedRoomTypeId %>" />
          <input type="hidden" name="checkIn" value="<%= selectedCheckIn %>" />
          <input type="hidden" name="checkOut" value="<%= selectedCheckOut %>" />

          <div class="form-grid">
            
            <div class="full-width">
              <label>Select Available Room</label>
              <select name="roomId" required>
                <option value="">-- Choose Room Number --</option>
                <% for (Room rm : availableRooms) { %>
                  <option value="<%= rm.getRoomId() %>">
                    Room <%= rm.getRoomNumber() %>
                  </option>
                <% } %>
              </select>
            </div>

            <div>
              <label>Guest Full Name</label>
              <input type="text" name="guestName" placeholder="Enter guest full name" required>
            </div>

            <div>
              <label>Contact Number</label>
              <input type="text" name="guestContact" placeholder="Phone number" required>
            </div>

            <div class="full-width">
              <label>Guest Address</label>
              <input type="text" name="guestAddress" placeholder="Complete residential address">
            </div>

            <div class="full-width">
              <button type="submit" class="btn-submit">
                <i class="fas fa-check-circle"></i> Confirm Reservation
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
