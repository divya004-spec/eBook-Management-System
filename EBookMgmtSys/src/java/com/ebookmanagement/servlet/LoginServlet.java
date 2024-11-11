package com.ebookmanagement.servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to login page if accessed via GET
        RequestDispatcher rd = request.getRequestDispatcher("LoginEbook.html");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter pw = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Load JDBC driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            // Establish connection
            con = DriverManager.getConnection("jdbc:derby://localhost:1527/Divya", "root", "root");
            
            // Use PreparedStatement to avoid SQL injection
            String query = "SELECT username, password FROM users WHERE username = ? AND password = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Valid login, create session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setMaxInactiveInterval(30 * 60); // Session expires after 30 minutes

                // Redirect to dashboard
                RequestDispatcher rd = request.getRequestDispatcher("dashboard.jsp");
                rd.include(request, response);
            } else {
                // Invalid login, redirect back to login page with error message
                pw.println("<h2><font color='red'><center>Username or Password is invalid...!!</center></font></h2>");
                RequestDispatcher rd = request.getRequestDispatcher("LoginEbook.html");
                rd.include(request, response);
            }
        } catch (Exception e) {
            pw.println("<h2>Error: " + e.getMessage() + "</h2>");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                pw.println("<h2>Error: " + ex.getMessage() + "</h2>");
            }
        }
    }
}
