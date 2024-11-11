/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ebookmanagement.servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

/**
 *
 * @author Admin
 */
public class RegisterServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter(); 
          
    String username = request.getParameter("username");
     String email = request.getParameter("email");
    String password = request.getParameter("password");
   

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/Divya", "root", "root");
        PreparedStatement ps = con.prepareStatement("INSERT INTO users(username,email,password) VALUES(?,?,?)");
        ps.setString(1, username);
        ps.setString(2, email);
        ps.setString(3, password);
        ps.executeUpdate();

        out.println("<h3><font color='blue' size='5px'><center>Registration successful....</center></font></h3>");
        RequestDispatcher rd = request.getRequestDispatcher("dashboard.jsp");
        rd.forward(request, response);
    } catch (Exception se) {
       out.println(se);
    }

    }
}
