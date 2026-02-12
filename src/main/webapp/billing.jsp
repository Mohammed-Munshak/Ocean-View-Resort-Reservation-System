<%@ page contentType="text/html; charset=UTF-8" %>

<%
  // --- BACKEND LOGIC PRESERVED ---
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
  <title>Generate Bill | Ocean View Resort</title>
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    /* --- THEME --- */
    :root {
      --primary-gradient: linear-gradient(135deg, #8D6E63 0%, #6D4C41 100%);
      --bg-color: #F4F1EA;
      --card-bg: #FFFFFF;
      --text-main: #3E2723;
      --border-color: #D7CCC8;
      --error-bg: #FFEBEE;
      --error-text: #C62828;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: var(--bg-color);
      color: var(--text-main);
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }

    /* --- CENTERED CARD --- */
    .card {
      background: var(--card-bg);
      width: 100%;
      max-width: 450px; /* Narrower for single input */
      padding: 40px;
      border-radius: 12px;
      box-shadow: 0 10px 30px rgba(141, 110, 99, 0.15);
      border-top: 5px solid #8D6E63;
      text-align: center;
      animation: fadeIn 0.6s ease-out;
    }

    h2 {
      margin-top: 0;
      font-family: 'Times New Roman', serif;
      font-size: 28px;
      color: var(--text-main);
      margin-bottom: 10px;
    }

    p.subtitle {
      color: #795548;
      font-size: 14px;
      margin-bottom: 30px;
    }

    /* --- FORM ELEMENTS --- */
    .form-group {
      text-align: left;
      margin-bottom: 20px;
    }

    label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      font-size: 13px;
      color: #6D4C41;
      text-transform: uppercase;
    }

    .input-wrapper {
      position: relative;
    }

    .input-wrapper i {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: #A1887F;
    }

    input[type="text"] {
      width: 100%;
      padding: 12px 12px 12px 35px; /* Space for icon */
      border: 1px solid var(--border-color);
      border-radius: 6px;
      font-size: 16px;
      box-sizing: border-box;
      transition: all 0.3s;
      background-color: #FAFAFA;
    }

    input:focus {
      outline: none;
      border-color: #8D6E63;
      background-color: #fff;
      box-shadow: 0 0 0 3px rgba(141, 110, 99, 0.1);
    }

    /* --- BUTTON --- */
    .btn-generate {
      width: 100%;
      padding: 12px;
      background: var(--primary-gradient);
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: transform 0.2s, box-shadow 0.2s;
    }

    .btn-generate:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(109, 76, 65, 0.3);
    }

    /* --- ALERTS --- */
    .alert-error {
      background-color: var(--error-bg);
      color: var(--error-text);
      padding: 12px;
      border-radius: 6px;
      border-left: 4px solid var(--error-text);
      margin-bottom: 20px;
      text-align: left;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    /* --- BACK LINK --- */
    .back-link {
      display: inline-block;
      margin-top: 20px;
      text-decoration: none;
      color: #8D6E63;
      font-size: 14px;
      transition: color 0.3s;
    }
    .back-link:hover { color: #3E2723; }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

  <div class="card">
    <h2>Generate Bill</h2>
    <p class="subtitle">Enter the reservation number to checkout</p>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
      <div class="alert-error">
        <i class="fas fa-exclamation-circle"></i> <%= error %>
      </div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/bill/generate">
      
      <div class="form-group">
        <label>Reservation Number</label>
        <div class="input-wrapper">
          <i class="fas fa-hashtag"></i>
          <input type="text" name="reservationNo" required placeholder="e.g. RES-1001" />
        </div>
      </div>

      <button type="submit" class="btn-generate">
        <i class="fas fa-file-invoice-dollar"></i> Generate Bill
      </button>

    </form>

    <a href="<%= request.getContextPath() %>/receptionistDashboard.jsp" class="back-link">
      <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
  </div>

</body>
</html>