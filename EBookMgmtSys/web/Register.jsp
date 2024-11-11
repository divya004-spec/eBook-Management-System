<%-- 
    Document   : RegisterServlet
    Created on : 07-Sep-2024, 12:11:11 pm
    Author     : Admin
--%>

<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.logging.Level, java.util.logging.Logger" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register- EBook Management System</title>
    <link rel="stylesheet" href="stylex.css"> <!-- Link to your CSS file -->
</head>
<body>
    <div class="background">
        <div class="login-container">
            <h2>Registration</h2>
            <form action="RegisterServlet" method="post">
                <div class="input-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="input-group">
                    <label for="email">E-Mail</label>
                    <input type="text" id="email" name="email" required>
                </div>
               
                <div class="input-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <button type="submit" class="login-btn">Register</button>
                <p class="register-link">Already have an account? <a href="LoginEbook.html">Login</a></p>
            </form>
        </div>
    </div>
</body>
</html>


          