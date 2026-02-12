<%@ page contentType="text/html; charset=UTF-8" %>
<%
  // --- BACKEND LOGIC (DO NOT CHANGE) ---
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reception Dashboard | Ocean View Resort</title>
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    /* --- UNIFIED LUXURY THEME --- */
    :root {
      --primary-gradient: linear-gradient(135deg, #8D6E63 0%, #6D4C41 100%);
      --bg-color: #F4F1EA;       /* Warm Sand */
      --card-bg: #FFFFFF;
      --text-main: #3E2723;
      --text-light: #795548;
      --accent: #D7CCC8;
      --shadow: 0 10px 30px rgba(141, 110, 99, 0.1);
      --hover-shadow: 0 15px 35px rgba(141, 110, 99, 0.2);
    }

    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: var(--bg-color);
      color: var(--text-main);
    }

    /* --- HERO HEADER --- */
    .header {
      background: var(--primary-gradient);
      padding: 20px 40px;
      color: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .brand {
      font-family: 'Times New Roman', serif;
      font-size: 28px;
      font-weight: bold;
      letter-spacing: 1px;
    }

    .user-profile {
      display: flex;
      align-items: center;
      gap: 20px;
      font-size: 14px;
      background: rgba(255,255,255,0.1);
      padding: 8px 20px;
      border-radius: 30px;
      backdrop-filter: blur(5px);
    }

    .logout-btn {
      color: white;
      text-decoration: none;
      font-weight: 600;
      transition: opacity 0.3s;
    }
    .logout-btn:hover { opacity: 0.8; }

    /* --- MAIN CONTENT --- */
    .container {
      max-width: 1100px;
      margin: 50px auto;
      padding: 0 20px;
      animation: slideUp 0.6s ease-out;
    }

    h2 {
      font-family: 'Times New Roman', serif;
      font-size: 32px;
      color: var(--text-main);
      margin-bottom: 10px;
    }

    p.welcome-text {
      color: var(--text-light);
      margin-bottom: 40px;
      font-size: 16px;
    }

    /* --- DASHBOARD GRID --- */
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 30px;
    }

    .card {
      background: var(--card-bg);
      border-radius: 16px;
      padding: 35px 25px;
      text-align: center;
      text-decoration: none;
      color: var(--text-main);
      box-shadow: var(--shadow);
      transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1);
      border: 1px solid rgba(255,255,255,0.5);
      position: relative;
      overflow: hidden;
    }

    .card:hover {
      transform: translateY(-8px);
      box-shadow: var(--hover-shadow);
    }

    /* Decorative Circle */
    .card::before {
      content: '';
      position: absolute;
      top: -50px;
      right: -50px;
      width: 100px;
      height: 100px;
      background: var(--bg-color);
      border-radius: 50%;
      opacity: 0.5;
      transition: 0.5s;
    }
    .card:hover::before { transform: scale(1.5); }

    .card i {
      font-size: 42px;
      color: #8D6E63;
      margin-bottom: 20px;
      position: relative;
      z-index: 1;
    }

    .card h3 {
      margin: 10px 0 5px;
      font-size: 18px;
      position: relative;
      z-index: 1;
    }

    .card p {
      font-size: 13px;
      color: #9E9E9E;
      margin: 0;
      position: relative;
      z-index: 1;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

  <div class="header">
    <div class="brand">Ocean View Resort</div>
    <div class="user-profile">
      <span><i class="fas fa-concierge-bell"></i> <%= session.getAttribute("fullName") %></span>
      <span>|</span>
      <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout <i class="fas fa-arrow-right"></i></a>
    </div>
  </div>

  <div class="container">
    <h2>Reception Dashboard</h2>
    <p class="welcome-text">Welcome back. Ready to assist guests today?</p>

    <div class="grid">
      <a href="<%= request.getContextPath() %>/reservation/new" class="card">
        <i class="fas fa-calendar-plus"></i>
        <h3>New Reservation</h3>
        <p>Book a room for a guest</p>
      </a>

      <a href="<%= request.getContextPath() %>/reservation/view" class="card">
        <i class="fas fa-clipboard-list"></i>
        <h3>Search Bookings</h3>
        <p>Check Active Reservations</p>
      </a>
      
      <a href="<%= request.getContextPath() %>/reservation/list" class="card">
  		<i class="fas fa-th-list"></i>
  		<h3>List Reservations</h3>
  		<p>View all booking records</p>
	  </a>

      <a href="<%= request.getContextPath() %>/bill/generate" class="card">
        <i class="fas fa-receipt"></i>
        <h3>Generate Bill</h3>
        <p>Checkout & Payment</p>
      </a>

      <a href="<%= request.getContextPath() %>/help.jsp" class="card">
        <i class="fas fa-question-circle"></i>
        <h3>Help</h3>
        <p>System Assistance</p>
      </a>
    </div>
  </div>

</body>
</html>