<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Login</title>
    <style>
        /* --- CSS VARIABLES (Theme Colors) --- */
        :root {
            --bg-color: #F9F7F5;       /* Off-white background */
            --card-bg: #FFFFFF;        /* Pure white card */
            --primary-brown: #8D6E63;  /* Warm brown */
            --dark-brown: #5D4037;     /* Darker brown for hover/text */
            --text-color: #4E342E;     /* Dark text */
            --border-color: #D7CCC8;   /* Light border */
            --error-color: #D32F2F;    /* Red for errors */
            --shadow: 0 8px 24px rgba(141, 110, 99, 0.15); /* Soft brown shadow */
        }

        /* --- GLOBAL STYLES --- */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh; /* Full viewport height */
        }

        /* --- LOGIN CARD CONTAINER --- */
        .login-wrapper {
            width: 100%;
            max-width: 400px;
            padding: 20px;
            box-sizing: border-box;
            animation: fadeIn 0.8s ease-out; /* Fade-in animation */
        }

        .box {
            background-color: var(--card-bg);
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: var(--shadow);
            border-top: 5px solid var(--primary-brown); /* Brown accent top */
            text-align: center;
        }

        /* --- TYPOGRAPHY --- */
        h2 {
            margin-top: 0;
            margin-bottom: 10px;
            color: var(--dark-brown);
            font-family: 'Times New Roman', serif; /* Assignment requirement */
            font-size: 28px;
            letter-spacing: 0.5px;
        }

        p.subtitle {
            margin-bottom: 30px;
            color: #888;
            font-size: 14px;
        }

        /* --- FORM ELEMENTS --- */
        label {
            display: block;
            text-align: left;
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 14px;
            color: var(--dark-brown);
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            box-sizing: border-box; /* Ensures padding doesn't break width */
            font-size: 15px;
            background-color: #FAFAFA;
            transition: all 0.3s ease;
        }

        input:focus {
            outline: none;
            border-color: var(--primary-brown);
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(141, 110, 99, 0.1);
        }

        /* --- BUTTON STYLES --- */
        button {
            width: 100%;
            padding: 14px;
            background-color: var(--primary-brown);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            letter-spacing: 0.5px;
        }

        button:hover {
            background-color: var(--dark-brown);
            transform: translateY(-2px); /* Slight lift effect */
            box-shadow: 0 4px 12px rgba(93, 64, 55, 0.3);
        }

        button:active {
            transform: translateY(0);
        }

        /* --- ERROR MESSAGE --- */
        .error {
            background-color: #FFEBEE;
            color: var(--error-color);
            padding: 10px;
            border-radius: 6px;
            border-left: 4px solid var(--error-color);
            margin-bottom: 20px;
            font-size: 14px;
            text-align: left;
        }

        /* --- ANIMATION KEYFRAMES --- */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* --- RESPONSIVE ADJUSTMENTS --- */
        @media (max-width: 480px) {
            .box {
                padding: 30px 20px;
            }
            h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>

    <div class="login-wrapper">
        <div class="box">
            <h2>Ocean View Resort</h2>
            <p class="subtitle">Please sign in to access the system</p>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="error">
                    <strong>Error:</strong> <%= error %>
                </div>
            <% } %>

            <form method="post" action="<%= request.getContextPath() %>/login">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username" required />

                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required />

                <button type="submit">Secure Login</button>
            </form>
        </div>
    </div>

</body>
</html>