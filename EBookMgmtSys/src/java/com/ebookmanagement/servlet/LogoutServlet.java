package com.ebookmanagement.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Invalidate the session to log out the user
        HttpSession session = request.getSession(false); // Get the existing session
        if (session != null) {
            session.invalidate(); // Invalidate the session
        }

        // Redirect to the login page (or home page)
        response.sendRedirect("login.jsp");
    }
}
