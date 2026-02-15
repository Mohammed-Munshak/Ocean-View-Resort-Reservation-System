<%@ page contentType="text/html; charset=UTF-8" %>
<%
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
      --shadow-sm: 0 1px 3px rgba(27, 59, 111, 0.08);
      --shadow-md: 0 4px 12px rgba(27, 59, 111, 0.1);
      --shadow-lg: 0 10px 30px rgba(27, 59, 111, 0.12);
      --shadow-xl: 0 20px 50px rgba(27, 59, 111, 0.2);
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

    /* Premium geometric background */
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

    /* Ultra Premium Header */
    .header {
      background: linear-gradient(135deg, var(--navy-blue) 0%, #2C4F7F 100%);
      padding: 0;
      color: white;
      box-shadow: var(--shadow-xl);
      position: sticky;
      top: 0;
      z-index: 100;
      border-bottom: 3px solid rgba(28, 167, 166, 0.4);
    }

    .header-content {
      max-width: 1400px;
      margin: 0 auto;
      padding: 18px 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .brand-section {
      display: flex;
      align-items: center;
      gap: 18px;
    }

    .brand-logo {
      width: 56px;
      height: 56px;
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--coral-orange) 100%);
      border-radius: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24px;
      font-weight: 700;
      letter-spacing: 1px;
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.5);
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
      box-shadow: 0 10px 30px rgba(28, 167, 166, 0.6);
    }

    .brand-logo:hover::before {
      right: 150%;
    }

    .brand-text {
      display: flex;
      flex-direction: column;
      gap: 3px;
    }

    .brand {
      font-size: 24px;
      font-weight: 700;
      letter-spacing: -0.3px;
    }

    .brand-subtitle {
      font-size: 11px;
      opacity: 0.85;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      font-weight: 500;
      color: var(--turquoise);
    }

    .user-profile {
      display: flex;
      align-items: center;
      gap: 22px;
      background: rgba(255, 255, 255, 0.12);
      padding: 10px 28px;
      border-radius: 50px;
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.18);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .user-profile:hover {
      background: rgba(255, 255, 255, 0.18);
      border-color: rgba(255, 255, 255, 0.28);
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
    }

    .user-info {
      font-size: 14px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .user-info i {
      font-size: 18px;
      color: var(--turquoise);
    }

    .divider {
      width: 1px;
      height: 24px;
      background: rgba(255, 255, 255, 0.3);
    }

    .logout-btn {
      color: white;
      text-decoration: none;
      font-weight: 700;
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
      transform: translateX(3px);
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
      animation: fadeIn 0.6s ease-out;
    }

    /* Page Header */
    .page-header {
      margin-bottom: 48px;
      animation: fadeInDown 0.6s ease-out;
    }

    h2 {
      font-size: 38px;
      color: var(--navy-blue);
      margin-bottom: 12px;
      font-weight: 700;
      letter-spacing: -0.8px;
      display: flex;
      align-items: center;
      gap: 16px;
    }

    h2 i {
      font-size: 40px;
      color: var(--turquoise);
    }

    p.welcome-text {
      color: var(--text-muted);
      font-size: 17px;
      font-weight: 500;
      line-height: 1.6;
      max-width: 700px;
    }

    /* Premium Card Grid */
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 32px;
      animation: fadeInUp 0.6s ease-out 0.2s both;
    }

    /* Ultra Professional Card Design */
    .card {
      background: var(--white);
      border-radius: 24px;
      padding: 42px 36px;
      text-align: center;
      text-decoration: none;
      color: var(--text-dark);
      box-shadow: var(--shadow-lg);
      border: 1px solid rgba(27, 59, 111, 0.08);
      transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      overflow: hidden;
      background: linear-gradient(135deg, var(--white) 0%, rgba(252, 238, 209, 0.2) 100%);
    }

    /* Premium gradient accent bar */
    .card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    }

    /* Radial glow effect */
    .card::after {
      content: '';
      position: absolute;
      bottom: -60px;
      right: -60px;
      width: 140px;
      height: 140px;
      background: radial-gradient(circle, rgba(28, 167, 166, 0.08) 0%, transparent 70%);
      transition: all 0.5s ease;
      opacity: 0;
    }

    .card:hover::before {
      transform: scaleX(1);
    }

    .card:hover::after {
      opacity: 1;
      width: 200px;
      height: 200px;
    }

    .card:hover {
      transform: translateY(-12px);
      box-shadow: var(--shadow-xl);
      border-color: rgba(28, 167, 166, 0.25);
    }

    /* Icon Container */
    .card-icon-wrapper {
      width: 80px;
      height: 80px;
      margin: 0 auto 24px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.1) 0%, rgba(252, 238, 209, 0.2) 100%);
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 6px 20px rgba(28, 167, 166, 0.15);
    }

    .card:hover .card-icon-wrapper {
      transform: scale(1.15) rotate(-8deg);
      box-shadow: 0 10px 30px rgba(28, 167, 166, 0.3);
    }

    .card i {
      font-size: 40px;
      color: var(--turquoise);
      position: relative;
      z-index: 1;
      transition: all 0.4s ease;
    }

    .card:hover i {
      transform: scale(1.2);
      color: var(--navy-blue);
    }

    /* Card Text */
    .card h3 {
      margin: 0 0 10px 0;
      font-size: 21px;
      font-weight: 700;
      color: var(--navy-blue);
      letter-spacing: -0.3px;
      position: relative;
      z-index: 1;
      transition: color 0.3s ease;
    }

    .card:hover h3 {
      color: var(--turquoise);
    }

    .card p {
      font-size: 14px;
      color: var(--text-muted);
      margin: 0;
      position: relative;
      z-index: 1;
      font-weight: 500;
      line-height: 1.6;
    }

    /* Card footer arrow */
    .card-footer {
      margin-top: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      color: var(--turquoise);
      font-size: 13px;
      font-weight: 700;
      opacity: 0;
      transform: translateY(10px);
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      text-transform: uppercase;
      letter-spacing: 0.5px;
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

    /* Unique colors for each card */
    .card:nth-child(1) .card-icon-wrapper {
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.1) 0%, rgba(16, 185, 129, 0.1) 100%);
    }
    
    .card:nth-child(2) .card-icon-wrapper {
      background: linear-gradient(135deg, rgba(59, 130, 246, 0.1) 0%, rgba(96, 165, 250, 0.1) 100%);
    }
    .card:nth-child(2) i {
      color: #3B82F6;
    }
    .card:nth-child(2):hover i {
      color: #2563EB;
    }
    .card:nth-child(2):hover h3 {
      color: #3B82F6;
    }
    .card:nth-child(2) .card-footer {
      color: #3B82F6;
    }

    .card:nth-child(3) .card-icon-wrapper {
      background: linear-gradient(135deg, rgba(139, 92, 246, 0.1) 0%, rgba(167, 139, 250, 0.1) 100%);
    }
    .card:nth-child(3) i {
      color: #8B5CF6;
    }
    .card:nth-child(3):hover i {
      color: #7C3AED;
    }
    .card:nth-child(3):hover h3 {
      color: #8B5CF6;
    }
    .card:nth-child(3) .card-footer {
      color: #8B5CF6;
    }

    .card:nth-child(4) .card-icon-wrapper {
      background: linear-gradient(135deg, rgba(255, 127, 80, 0.1) 0%, rgba(248, 113, 113, 0.1) 100%);
    }
    .card:nth-child(4) i {
      color: var(--coral-orange);
    }
    .card:nth-child(4):hover i {
      color: #FF6347;
    }
    .card:nth-child(4):hover h3 {
      color: var(--coral-orange);
    }
    .card:nth-child(4) .card-footer {
      color: var(--coral-orange);
    }

    .card:nth-child(5) .card-icon-wrapper {
      background: linear-gradient(135deg, rgba(236, 72, 153, 0.1) 0%, rgba(244, 114, 182, 0.1) 100%);
    }
    .card:nth-child(5) i {
      color: #EC4899;
    }
    .card:nth-child(5):hover i {
      color: #DB2777;
    }
    .card:nth-child(5):hover h3 {
      color: #EC4899;
    }
    .card:nth-child(5) .card-footer {
      color: #EC4899;
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

    /* Responsive Design */
    @media (max-width: 1200px) {
      .grid {
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 28px;
      }
    }

    @media (max-width: 768px) {
      .header-content {
        padding: 16px 24px;
        flex-direction: column;
        gap: 16px;
        align-items: stretch;
      }

      .brand-section {
        justify-content: center;
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

      h2 {
        font-size: 30px;
        flex-wrap: wrap;
      }

      p.welcome-text {
        font-size: 15px;
      }

      .grid {
        grid-template-columns: 1fr;
        gap: 24px;
      }

      .card {
        padding: 36px 28px;
      }
    }

    @media (max-width: 480px) {
      .brand {
        font-size: 20px;
      }

      .brand-logo {
        width: 48px;
        height: 48px;
        font-size: 20px;
      }

      .user-info span {
        display: none;
      }

      h2 {
        font-size: 26px;
      }

      h2 i {
        font-size: 28px;
      }

      .card {
        padding: 32px 24px;
      }

      .card-icon-wrapper {
        width: 70px;
        height: 70px;
      }

      .card i {
        font-size: 36px;
      }

      .card h3 {
        font-size: 19px;
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

  <div class="header">
    <div class="header-content">
      <div class="brand-section">
        <div class="brand-logo">OV</div>
        <div class="brand-text">
          <div class="brand">Ocean View Resort</div>
          <div class="brand-subtitle">Reception Desk</div>
        </div>
      </div>
      <div class="user-profile">
        <div class="user-info">
          <i class="fas fa-concierge-bell"></i>
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
      <h2><i class="fas fa-dashboard"></i> Reception Dashboard</h2>
      <p class="welcome-text">Welcome back! Ready to provide exceptional guest service and manage reservations efficiently.</p>
    </div>

    <div class="grid">
      <a href="<%= request.getContextPath() %>/reservation/new" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-calendar-plus"></i>
        </div>
        <h3>New Reservation</h3>
        <p>Create a new booking for guests</p>
        <div class="card-footer">
          Book Now <i class="fas fa-arrow-right"></i>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/reservation/view" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-clipboard-list"></i>
        </div>
        <h3>Search Bookings</h3>
        <p>Find and manage active reservations</p>
        <div class="card-footer">
          Search <i class="fas fa-arrow-right"></i>
        </div>
      </a>
      
      <a href="<%= request.getContextPath() %>/reservation/list" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-th-list"></i>
        </div>
        <h3>List Reservations</h3>
        <p>View comprehensive booking records</p>
        <div class="card-footer">
          View All <i class="fas fa-arrow-right"></i>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/bill/generate" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-receipt"></i>
        </div>
        <h3>Generate Bill</h3>
        <p>Process checkout and payments</p>
        <div class="card-footer">
          Checkout <i class="fas fa-arrow-right"></i>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/help.jsp" class="card">
        <div class="card-icon-wrapper">
          <i class="fas fa-question-circle"></i>
        </div>
        <h3>Help & Support</h3>
        <p>System documentation and assistance</p>
        <div class="card-footer">
          Get Help <i class="fas fa-arrow-right"></i>
        </div>
      </a>
    </div>
  </div>

</body>
</html>
