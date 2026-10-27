<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Fixed messages only - request text is never echoed back
    String error = request.getParameter("error");
    String message = null;
    if ("invalid".equals(error)) {
        message = "Please check your input: username 3-50 letters/digits (_ . - allowed), a valid e-mail and a password of at least 4 characters.";
    } else if ("exists".equals(error)) {
        message = "That username or e-mail address is already registered.";
    } else if ("db".equals(error)) {
        message = "The database is not reachable right now. Please try again.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - EBook Management System</title>
    <link rel="stylesheet" href="stylex.css">
    <link rel="stylesheet" href="app.css">
</head>
<body>
    <div class="background">
        <div class="login-container">
            <h2>Registration</h2>
            <% if (message != null) { %>
                <div class="flash error"><%= message %></div>
            <% } %>
            <form action="RegisterServlet" method="post">
                <div class="input-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required minlength="3" maxlength="50" pattern="[A-Za-z0-9_.\-]+" title="Letters, digits, _ . - only">
                </div>
                <div class="input-group">
                    <label for="email">E-Mail</label>
                    <input type="email" id="email" name="email" required maxlength="100">
                </div>

                <div class="input-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required minlength="4" maxlength="100">
                </div>
                <button type="submit" class="login-btn">Register</button>
                <p class="register-link">Already have an account? <a href="LoginEbook.html">Login</a></p>
                <p class="register-link"><a href="index.html">Back to home</a></p>
            </form>
        </div>
    </div>
</body>
</html>
