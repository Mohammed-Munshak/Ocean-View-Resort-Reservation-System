<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Login</title>
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
            --error-bg: #FEE2E2;
            --error-color: #DC2626;
            --success-green: #059669;
            --shadow-sm: 0 1px 3px rgba(27, 59, 111, 0.08);
            --shadow-md: 0 4px 12px rgba(27, 59, 111, 0.1);
            --shadow-lg: 0 10px 30px rgba(27, 59, 111, 0.15);
            --shadow-xl: 0 20px 50px rgba(27, 59, 111, 0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, var(--navy-blue) 0%, #2C4F7F 50%, var(--turquoise) 100%);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        /* Professional geometric background pattern */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                linear-gradient(30deg, rgba(28, 167, 166, 0.03) 12%, transparent 12.5%, transparent 87%, rgba(28, 167, 166, 0.03) 87.5%, rgba(28, 167, 166, 0.03)),
                linear-gradient(150deg, rgba(28, 167, 166, 0.03) 12%, transparent 12.5%, transparent 87%, rgba(28, 167, 166, 0.03) 87.5%, rgba(28, 167, 166, 0.03)),
                linear-gradient(30deg, rgba(28, 167, 166, 0.03) 12%, transparent 12.5%, transparent 87%, rgba(28, 167, 166, 0.03) 87.5%, rgba(28, 167, 166, 0.03)),
                linear-gradient(150deg, rgba(28, 167, 166, 0.03) 12%, transparent 12.5%, transparent 87%, rgba(28, 167, 166, 0.03) 87.5%, rgba(28, 167, 166, 0.03));
            background-size: 80px 140px;
            background-position: 0 0, 0 0, 40px 70px, 40px 70px;
            opacity: 0.4;
        }

        /* Subtle animated gradient overlay */
        body::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle at 30% 50%, rgba(255, 127, 80, 0.08) 0%, transparent 50%),
                        radial-gradient(circle at 70% 50%, rgba(28, 167, 166, 0.08) 0%, transparent 50%);
            animation: subtleMove 20s ease-in-out infinite;
            pointer-events: none;
        }

        @keyframes subtleMove {
            0%, 100% { transform: translate(0, 0); }
            50% { transform: translate(30px, -30px); }
        }

        .login-wrapper {
            width: 100%;
            max-width: 460px;
            position: relative;
            z-index: 1;
            animation: fadeInScale 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

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

        .box {
            background: var(--white);
            padding: 50px 45px;
            border-radius: 20px;
            box-shadow: var(--shadow-xl);
            border: 1px solid rgba(255, 255, 255, 0.18);
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            backdrop-filter: blur(10px);
        }

        .box:hover {
            transform: translateY(-4px);
            box-shadow: 0 25px 60px rgba(27, 59, 111, 0.25);
        }

        /* Premium top accent bar */
        .box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, var(--turquoise) 0%, var(--coral-orange) 100%);
        }

        /* Subtle inner glow */
        .box::after {
            content: '';
            position: absolute;
            top: 5px;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(28, 167, 166, 0.2), transparent);
        }

        /* Header section */
        .header-section {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }

        .logo-container {
            margin-bottom: 24px;
            animation: fadeIn 0.8s ease-out 0.2s both;
        }

        .logo-icon {
            width: 72px;
            height: 72px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 30px;
            font-weight: 700;
            letter-spacing: 2px;
            box-shadow: 0 8px 24px rgba(27, 59, 111, 0.3);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        /* Premium shine effect */
        .logo-icon::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transform: rotate(45deg);
            transition: all 0.6s ease;
        }

        .logo-icon:hover {
            transform: translateY(-4px) scale(1.05);
            box-shadow: 0 12px 32px rgba(28, 167, 166, 0.4);
        }

        .logo-icon:hover::before {
            right: 150%;
        }

        h2 {
            color: var(--navy-blue);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            font-size: 32px;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 10px;
            animation: fadeIn 0.8s ease-out 0.3s both;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        p.subtitle {
            color: var(--text-muted);
            font-size: 15px;
            line-height: 1.6;
            font-weight: 400;
            animation: fadeIn 0.8s ease-out 0.4s both;
        }

        /* Form styling */
        form {
            animation: fadeIn 0.8s ease-out 0.5s both;
        }

        .form-group {
            margin-bottom: 24px;
            position: relative;
        }

        label {
            display: block;
            text-align: left;
            margin-bottom: 10px;
            font-weight: 600;
            font-size: 14px;
            color: var(--text-dark);
            letter-spacing: 0.2px;
            transition: color 0.3s ease;
        }

        .input-wrapper {
            position: relative;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 15px 18px;
            border: 2px solid var(--border-light);
            border-radius: 12px;
            font-size: 15px;
            color: var(--text-dark);
            background-color: var(--white);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-family: inherit;
        }

        input[type="text"]::placeholder,
        input[type="password"]::placeholder {
            color: #9CA3AF;
            transition: opacity 0.3s ease;
        }

        input[type="text"]:hover,
        input[type="password"]:hover {
            border-color: var(--turquoise);
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: var(--turquoise);
            background-color: var(--white);
            box-shadow: 0 0 0 4px rgba(28, 167, 166, 0.1);
            transform: translateY(-2px);
        }

        input[type="text"]:focus::placeholder,
        input[type="password"]:focus::placeholder {
            opacity: 0.5;
        }

        /* Premium button styling */
        button {
            width: 100%;
            padding: 17px;
            background: linear-gradient(135deg, var(--turquoise) 0%, var(--navy-blue) 100%);
            color: var(--white);
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 6px 20px rgba(28, 167, 166, 0.3);
            margin-top: 12px;
        }

        /* Animated gradient on hover */
        button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.6s ease;
        }

        button:hover::before {
            left: 100%;
        }

        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(28, 167, 166, 0.4);
            background: linear-gradient(135deg, var(--navy-blue) 0%, var(--turquoise) 100%);
        }

        button:active {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(28, 167, 166, 0.3);
        }

        /* Professional error message */
        .error {
            background: var(--error-bg);
            color: var(--error-color);
            padding: 16px 18px;
            border-radius: 12px;
            border-left: 4px solid var(--error-color);
            margin-bottom: 24px;
            font-size: 14px;
            text-align: left;
            animation: slideInShake 0.5s ease-out;
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.15);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .error strong {
            font-weight: 700;
        }

        @keyframes slideInShake {
            0% { 
                opacity: 0;
                transform: translateX(-20px);
            }
            50% {
                transform: translateX(5px);
            }
            100% { 
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* Responsive design */
        @media (max-width: 480px) {
            body {
                padding: 16px;
            }

            .box {
                padding: 40px 32px;
                border-radius: 16px;
            }

            h2 {
                font-size: 28px;
            }

            .logo-icon {
                width: 64px;
                height: 64px;
                font-size: 26px;
            }

            p.subtitle {
                font-size: 14px;
            }

            input[type="text"],
            input[type="password"] {
                padding: 13px 16px;
                font-size: 14px;
            }

            button {
                padding: 15px;
                font-size: 15px;
            }
        }

        /* Disabled state */
        button:disabled {
            background: linear-gradient(135deg, var(--soft-gray) 0%, #C0C0C0 100%);
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        /* Selection styling */
        ::selection {
            background-color: var(--turquoise);
            color: var(--white);
        }

        ::-moz-selection {
            background-color: var(--turquoise);
            color: var(--white);
        }

        /* Focus visible for accessibility */
        *:focus-visible {
            outline: 2px solid var(--turquoise);
            outline-offset: 2px;
        }
    </style>
</head>
<body>

    <div class="login-wrapper">
        <div class="box">
            <div class="header-section">
                <div class="logo-container">
                    <div class="logo-icon">OV</div>
                </div>
                <h2>Ocean View Resort</h2>
                <p class="subtitle">Please sign in to access the system</p>
            </div>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="error">
                    <strong>Error:</strong> <%= error %>
                </div>
            <% } %>

            <form method="post" action="<%= request.getContextPath() %>/login">
                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-wrapper">
                        <input type="text" id="username" name="username" placeholder="Enter your username" required />
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" placeholder="Enter your password" required />
                    </div>
                </div>

                <button type="submit">Secure Login</button>
            </form>
        </div>
    </div>

</body>
</html>
