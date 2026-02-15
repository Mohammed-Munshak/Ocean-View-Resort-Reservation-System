<%@ page contentType="text/html; charset=UTF-8" %>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"RECEPTIONIST".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
    return;
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Generate Bill | Ocean View Resort</title>
  
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
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 40px 20px;
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

    .card {
      background: var(--white);
      width: 100%;
      max-width: 500px;
      padding: 48px 44px;
      border-radius: 24px;
      box-shadow: var(--shadow-xl);
      border: 1px solid rgba(27, 59, 111, 0.08);
      text-align: center;
      animation: fadeInScale 0.6s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      z-index: 1;
      overflow: hidden;
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

    /* Icon Header */
    .icon-header {
      width: 80px;
      height: 80px;
      margin: 0 auto 24px;
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 8px 24px rgba(28, 167, 166, 0.4);
      animation: float 3s ease-in-out infinite;
    }

    .icon-header i {
      font-size: 38px;
      color: var(--white);
    }

    @keyframes float {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-10px); }
    }

    h2 {
      margin: 0 0 12px 0;
      font-size: 32px;
      font-weight: 700;
      color: var(--navy-blue);
      letter-spacing: -0.5px;
    }

    p.subtitle {
      color: var(--text-muted);
      font-size: 15px;
      margin-bottom: 36px;
      font-weight: 500;
      line-height: 1.6;
    }

    /* Alert Error */
    .alert-error {
      background: var(--error-light);
      color: var(--error);
      padding: 18px 20px;
      border-radius: 14px;
      border-left: 5px solid var(--error);
      margin-bottom: 28px;
      text-align: left;
      font-size: 15px;
      display: flex;
      align-items: center;
      gap: 14px;
      font-weight: 500;
      box-shadow: var(--shadow-md);
      animation: slideInDown 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .alert-error i {
      font-size: 22px;
      flex-shrink: 0;
    }

    /* Form Group */
    .form-group {
      text-align: left;
      margin-bottom: 28px;
    }

    label {
      display: block;
      margin-bottom: 10px;
      font-weight: 700;
      font-size: 13px;
      color: var(--text-dark);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .input-wrapper {
      position: relative;
    }

    .input-wrapper i {
      position: absolute;
      left: 18px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--turquoise);
      font-size: 18px;
      z-index: 1;
    }

    input[type="text"] {
      width: 100%;
      padding: 16px 18px 16px 50px;
      border: 2px solid var(--border-light);
      border-radius: 12px;
      font-size: 16px;
      box-sizing: border-box;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      background: var(--white);
      color: var(--text-dark);
      font-family: inherit;
      font-weight: 600;
    }

    input[type="text"]:hover {
      border-color: var(--turquoise);
    }

    input[type="text"]:focus {
      outline: none;
      border-color: var(--turquoise);
      background: var(--white);
      box-shadow: 0 0 0 4px rgba(28, 167, 166, 0.1);
      transform: translateY(-2px);
    }

    input[type="text"]::placeholder {
      color: #9CA3AF;
      font-weight: 400;
    }

    /* Generate Button */
    .btn-generate {
      width: 100%;
      padding: 18px;
      background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
      color: var(--white);
      border: none;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
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

    .btn-generate::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
      transition: left 0.6s ease;
    }

    .btn-generate:hover::before {
      left: 100%;
    }

    .btn-generate:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 30px rgba(28, 167, 166, 0.4);
      background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
    }

    .btn-generate:active {
      transform: translateY(-1px);
    }

    .btn-generate i {
      font-size: 18px;
    }

    /* Back Link */
    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      margin-top: 28px;
      text-decoration: none;
      color: var(--navy-blue);
      font-size: 14px;
      font-weight: 600;
      padding: 10px 20px;
      border-radius: 10px;
      background: linear-gradient(135deg, rgba(28, 167, 166, 0.05) 0%, rgba(252, 238, 209, 0.1) 100%);
      border: 2px solid var(--border-light);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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

    /* Animations */
    @keyframes fadeInScale {
      from {
        opacity: 0;
        transform: scale(0.95) translateY(20px);
      }
      to {
        opacity: 1;
        transform: scale(1) translateY(0);
      }
    }

    @keyframes slideInDown {
      from {
        opacity: 0;
        transform: translateY(-20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* Responsive */
    @media (max-width: 480px) {
      body {
        padding: 24px 16px;
      }

      .card {
        padding: 36px 28px;
        border-radius: 20px;
      }

      .icon-header {
        width: 70px;
        height: 70px;
      }

      .icon-header i {
        font-size: 34px;
      }

      h2 {
        font-size: 28px;
      }

      p.subtitle {
        font-size: 14px;
      }

      input[type="text"] {
        padding: 14px 16px 14px 46px;
        font-size: 15px;
      }

      .btn-generate {
        padding: 16px;
        font-size: 15px;
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

  <div class="card">
    <div class="icon-header">
      <i class="fas fa-file-invoice-dollar"></i>
    </div>

    <h2>Generate Guest Bill</h2>
    <p class="subtitle">Enter the reservation number to process checkout and generate invoice</p>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
      <div class="alert-error">
        <i class="fas fa-exclamation-circle"></i>
        <span><%= error %></span>
      </div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/bill/generate">
      
      <div class="form-group">
        <label>Reservation Number</label>
        <div class="input-wrapper">
          <i class="fas fa-hashtag"></i>
          <input type="text" name="reservationNo" required placeholder="Enter reservation number (e.g. RES-1001)" />
        </div>
      </div>

      <button type="submit" class="btn-generate">
        <i class="fas fa-receipt"></i> Generate Invoice
      </button>

    </form>

    <a href="<%= request.getContextPath() %>/Views/receptionistDashboard.jsp" class="back-link">
      <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
  </div>

</body>
</html>
