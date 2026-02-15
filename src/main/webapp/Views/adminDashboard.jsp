<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard | Ocean View Resort</title>
  
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
      --warning: #F59E0B;
      --info: #3B82F6;
      --danger: #EF4444;
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
      position: relative;
    }

    /* Subtle professional background pattern */
    body::before {
      content: '';
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-image: 
        linear-gradient(30deg, rgba(28, 167, 166, 0.02) 12%, transparent 12.5%, transparent 87%, rgba(28, 167, 166, 0.02) 87.5%, rgba(28, 167, 166, 0.02)),
        linear-gradient(150deg, rgba(27, 59, 111, 0.02) 12%, transparent 12.5%, transparent 87%, rgba(27, 59, 111, 0.02) 87.5%, rgba(27, 59, 111, 0.02));
      background-size: 60px 104px;
      background-position: 0 0, 30px 52px;
      pointer-events: none;
      z-index: 0;
    }

    /* Premium Header */
    .header {
      background: linear-gradient(135deg, var(--navy-blue) 0%, #2C4F7F 100%);
      padding: 0;
      color: white;
      box-shadow: var(--shadow-lg);
      position: sticky;
      top: 0;
      z-index: 100;
      backdrop-filter: blur(10px);
      border-bottom: 2px solid rgba(28, 167, 166, 0.3);
    }

    .header-content {
      max-width: 1400px;
      margin: 0 auto;
      padding: 18px 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 16px;
    }

    .brand-logo {
      width: 52px;
      height: 52px;
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--coral-orange) 100%);
      border-radius: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
      font-weight: 700;
      letter-spacing: 1px;
      box-shadow: 0 4px 16px rgba(28, 167, 166, 0.4);
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      overflow: hidden;
    }

    .brand-logo::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 100%;
      height: 200%;
      background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.2), transparent);
      transform: rotate(45deg);
      transition: all 0.6s ease;
    }

    .brand-logo:hover {
      transform: translateY(-3px) scale(1.05);
      box-shadow: 0 8px 24px rgba(28, 167, 166, 0.5);
    }

    .brand-logo:hover::before {
      right: 150%;
    }

    .brand-text {
      display: flex;
      flex-direction: column;
      gap: 3px;
    }

    .brand-name {
      font-size: 22px;
      font-weight: 700;
      letter-spacing: -0.3px;
      line-height: 1;
    }

    .brand-subtitle {
      font-size: 11px;
      opacity: 0.8;
      letter-spacing: 1.2px;
      text-transform: uppercase;
      font-weight: 500;
      color: var(--turquoise);
    }

    .user-profile {
      display: flex;
      align-items: center;
      gap: 20px;
      background: rgba(255, 255, 255, 0.1);
      padding: 10px 26px;
      border-radius: 50px;
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.15);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .user-profile:hover {
      background: rgba(255, 255, 255, 0.15);
      border-color: rgba(255, 255, 255, 0.25);
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .user-info {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 14px;
      font-weight: 600;
    }

    .user-info i {
      font-size: 18px;
      opacity: 0.9;
      color: var(--turquoise);
    }

    .divider {
      width: 1px;
      height: 24px;
      background: rgba(255, 255, 255, 0.25);
    }

    .logout-btn {
      color: white;
      text-decoration: none;
      font-weight: 600;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 8px 18px;
      border-radius: 24px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      background: rgba(255, 127, 80, 0.15);
      border: 1px solid rgba(255, 127, 80, 0.3);
    }
    
    .logout-btn:hover { 
      background: var(--coral-orange);
      border-color: var(--coral-orange);
      transform: translateX(-3px);
      box-shadow: 0 4px 12px rgba(255, 127, 80, 0.4);
    }

    .logout-btn i {
      transition: transform 0.3s ease;
    }

    .logout-btn:hover i {
      transform: translateX(4px);
    }

    /* Main Container */
    .container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 48px 40px;
      position: relative;
      z-index: 1;
    }

    /* Page Header */
    .page-header {
      margin-bottom: 48px;
      animation: fadeInDown 0.6s ease-out;
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      flex-wrap: wrap;
      gap: 20px;
    }

    .page-header-content {
      flex: 1;
      min-width: 300px;
    }

    .page-header h2 {
      font-size: 36px;
      color: var(--navy-blue);
      margin-bottom: 12px;
      font-weight: 700;
      letter-spacing: -0.5px;
    }

    .welcome-text {
      color: var(--text-muted);
      font-size: 16px;
      line-height: 1.6;
      max-width: 650px;
    }

    /* Dashboard Grid */
    .dashboard-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 28px;
      animation: fadeInUp 0.6s ease-out 0.2s both;
    }

    /* Premium Card Styles */
    .card {
      background: var(--white);
      border-radius: 20px;
      padding: 36px 32px;
      text-decoration: none;
      color: var(--text-dark);
      box-shadow: var(--shadow-md);
      border: 1px solid rgba(27, 59, 111, 0.08);
      position: relative;
      overflow: hidden;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      background: linear-gradient(135deg, var(--white) 0%, rgba(252, 238, 209, 0.3) 100%);
    }

    /* Premium gradient accent bar */
    .card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 5px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .card::after {
      content: '';
      position: absolute;
      bottom: 0;
      right: 0;
      width: 120px;
      height: 120px;
      background: radial-gradient(circle, rgba(28, 167, 166, 0.04) 0%, transparent 70%);
      transition: all 0.5s ease;
      opacity: 0;
    }

    .card:hover::before {
      transform: scaleX(1);
    }

    .card:hover::after {
      opacity: 1;
      width: 180px;
      height: 180px;
    }

    .card:hover {
      transform: translateY(-8px);
      box-shadow: var(--shadow-xl);
      border-color: rgba(28, 167, 166, 0.2);
    }

    .card-icon-wrapper {
      width: 70px;
      height: 70px;
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 24px;
      position: relative;
      transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
    }

    .card:hover .card-icon-wrapper {
      transform: scale(1.1) rotate(-8deg);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    }

    .card i {
      font-size: 34px;
      transition: all 0.4s ease;
      position: relative;
      z-index: 1;
    }

    .card:hover i {
      transform: scale(1.15);
      filter: brightness(1.1);
    }

    .card-content {
      flex: 1;
      margin-bottom: 20px;
    }

    .card h3 {
      font-size: 20px;
      font-weight: 700;
      margin-bottom: 10px;
      color: var(--text-dark);
      letter-spacing: -0.2px;
      transition: color 0.3s ease;
    }

    .card:hover h3 {
      color: var(--navy-blue);
    }

    .card p {
      font-size: 14px;
      color: var(--text-muted);
      line-height: 1.7;
      margin: 0;
    }

    .card-footer {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 14px;
      font-weight: 600;
      opacity: 0;
      transform: translateY(10px);
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      padding: 10px 18px;
      border-radius: 10px;
      background: rgba(28, 167, 166, 0.05);
    }

    .card:hover .card-footer {
      opacity: 1;
      transform: translateY(0);
    }

    .card-footer i {
      font-size: 14px;
      transition: transform 0.3s ease;
    }

    .card:hover .card-footer i {
      transform: translateX(5px);
    }

    /* Premium color variants for different cards */
    .card:nth-child(1) .card-icon-wrapper { 
      background: linear-gradient(135deg, rgba(27, 59, 111, 0.1) 0%, rgba(28, 167, 166, 0.1) 100%);
    }
    .card:nth-child(1) i { color: var(--navy-blue); }
    .card:nth-child(1) .card-footer { color: var(--navy-blue); }
    
    .card:nth-child(2) .card-icon-wrapper { 
      background: linear-gradient(135deg, rgba(5, 150, 105, 0.1) 0%, rgba(16, 185, 129, 0.1) 100%);
    }
    .card:nth-child(2) i { color: var(--success); }
    .card:nth-child(2):hover h3 { color: var(--success); }
    .card:nth-child(2) .card-footer { color: var(--success); background: rgba(5, 150, 105, 0.05); }
    
    .card:nth-child(3) .card-icon-wrapper { 
      background: linear-gradient(135deg, rgba(245, 158, 11, 0.1) 0%, rgba(251, 191, 36, 0.1) 100%);
    }
    .card:nth-child(3) i { color: var(--warning); }
    .card:nth-child(3):hover h3 { color: var(--warning); }
    .card:nth-child(3) .card-footer { color: var(--warning); background: rgba(245, 158, 11, 0.05); }
    
    .card:nth-child(4) .card-icon-wrapper { 
      background: linear-gradient(135deg, rgba(59, 130, 246, 0.1) 0%, rgba(96, 165, 250, 0.1) 100%);
    }
    .card:nth-child(4) i { color: var(--info); }
    .card:nth-child(4):hover h3 { color: var(--info); }
    .card:nth-child(4) .card-footer { color: var(--info); background: rgba(59, 130, 246, 0.05); }
    
    .card:nth-child(5) .card-icon-wrapper { 
      background: linear-gradient(135deg, rgba(239, 68, 68, 0.1) 0%, rgba(248, 113, 113, 0.1) 100%);
    }
    .card:nth-child(5) i { color: var(--danger); }
    .card:nth-child(5):hover h3 { color: var(--danger); }
    .card:nth-child(5) .card-footer { color: var(--danger); background: rgba(239, 68, 68, 0.05); }

    /* Smooth Animations */
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

    /* Responsive Design */
    @media (max-width: 1200px) {
      .dashboard-grid {
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 24px;
      }
    }

    @media (max-width: 768px) {
      .header-content {
        padding: 16px 24px;
        flex-direction: column;
        gap: 16px;
        align-items: stretch;
      }

      .user-profile {
        justify-content: space-between;
      }

      .container {
        padding: 32px 24px;
      }

      .page-header {
        margin-bottom: 36px;
      }

      .page-header h2 {
        font-size: 28px;
      }

      .dashboard-grid {
        grid-template-columns: 1fr;
        gap: 20px;
      }

      .brand-name {
        font-size: 19px;
      }

      .brand-subtitle {
        font-size: 10px;
      }
    }

    @media (max-width: 480px) {
      .header-content {
        padding: 14px 20px;
      }

      .brand-logo {
        width: 44px;
        height: 44px;
        font-size: 18px;
      }

      .user-info span {
        display: none;
      }

      .container {
        padding: 24px 20px;
      }

      .page-header h2 {
        font-size: 24px;
      }

      .welcome-text {
        font-size: 14px;
      }

      .card {
        padding: 28px 24px;
        border-radius: 16px;
      }

      .card-icon-wrapper {
        width: 60px;
        height: 60px;
      }

      .card i {
        font-size: 30px;
      }

      .card h3 {
        font-size: 18px;
      }
    }

    /* Smooth scrolling */
    html {
      scroll-behavior: smooth;
    }

    /* Premium selection color */
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
  </style>
</head>
<body>

  <div class="header">
    <div class="header-content">
      <div class="brand">
        <div class="brand-logo">OV</div>
        <div class="brand-text">
          <div class="brand-name">Ocean View Resort</div>
          <div class="brand-subtitle">Management System</div>
        </div>
      </div>
      <div class="user-profile">
        <div class="user-info">
          <i class="fas fa-user-shield"></i>
          <span><%= session.getAttribute("fullName") %></span>
        </div>
        <div class="divider"></div>
        <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
          Logout <i class="fas fa-arrow-right"></i>
        </a>
      </div>
    </div>
  </div>

  <div class="container">
    <div class="page-header">
      <div class="page-header-content">
        <h2>Admin Dashboard</h2>
        <p class="welcome-text">Manage your hotel staff, rooms, and system configurations with comprehensive control and oversight.</p>
      </div>
    </div>

    <div class="dashboard-grid">
      <a href="<%= request.getContextPath() %>/admin/receptionists" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-users-cog"></i>
        </div>
        <div class="card-content">
          <h3>Receptionists</h3>
          <p>Manage staff access, permissions, and account settings</p>
        </div>
        <div class="card-footer">
          Manage Staff <i class="fas fa-arrow-right"></i>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/admin/roomtypes" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-tags"></i>
        </div>
        <div class="card-content">
          <h3>Add Types & Rates</h3>
          <p>Configure room types and pricing structures for the resort</p>
        </div>
        <div class="card-footer">
          Set Rates <i class="fas fa-arrow-right"></i>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/admin/rooms" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-bed"></i>
        </div>
        <div class="card-content">
          <h3>Available Rooms</h3>
          <p>Monitor room status, availability, and maintenance schedules</p>
        </div>
        <div class="card-footer">
          View Rooms <i class="fas fa-arrow-right"></i>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/admin/reports" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-chart-pie"></i>
        </div>
        <div class="card-content">
          <h3>Reports</h3>
          <p>Access detailed business analytics and performance metrics</p>
        </div>
        <div class="card-footer">
          View Reports <i class="fas fa-arrow-right"></i>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/help.jsp" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-life-ring"></i>
        </div>
        <div class="card-content">
          <h3>Help</h3>
          <p>System documentation and troubleshooting guides</p>
        </div>
        <div class="card-footer">
          Get Help <i class="fas fa-arrow-right"></i>
        </div>
      </a>
    </div>
  </div>

</body>
</html>
