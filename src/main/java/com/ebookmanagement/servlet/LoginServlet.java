package com.ebookmanagement.servlet;

import com.ebookmanagement.util.DBUtil;
import com.ebookmanagement.util.PasswordUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** Handles the login form (LoginEbook.html). */
public class LoginServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(LoginServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/LoginEbook.html");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String ctx = request.getContextPath();

        if (username == null || password == null || username.trim().length() == 0 || password.length() == 0) {
            response.sendRedirect(ctx + "/LoginEbook.html?error=invalid");
            return;
        }
        username = username.trim();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean valid = false;
        boolean upgrade = false;
        try {
            con = DBUtil.getConnection();
            ps = con.prepareStatement("SELECT USERNAME, PASSWORD FROM USERS WHERE USERNAME = ?");
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                String stored = rs.getString("PASSWORD");
                valid = PasswordUtil.verify(password, stored);
                upgrade = valid && !PasswordUtil.isHashed(stored);
                username = rs.getString("USERNAME");
            }
            DBUtil.close(rs);
            DBUtil.close(ps);
            ps = null;

            if (upgrade) {                       // old plain-text password -> store a hash
                try {
                    ps = con.prepareStatement("UPDATE USERS SET PASSWORD = ? WHERE USERNAME = ?");
                    ps.setString(1, PasswordUtil.hash(password));
                    ps.setString(2, username);
                    ps.executeUpdate();
                } catch (SQLException ignore) {
                    // column too short etc. - login still succeeds
                }
            }
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Login failed because of a database problem", e);
            response.sendRedirect(ctx + "/LoginEbook.html?error=db");
            return;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(ps);
            DBUtil.close(con);
        }

        if (!valid) {
            response.sendRedirect(ctx + "/LoginEbook.html?error=invalid");
            return;
        }

        // Valid login: start a fresh session (protects against session fixation)
        HttpSession old = request.getSession(false);
        if (old != null) {
            old.invalidate();
        }
        HttpSession session = request.getSession(true);
        session.setAttribute("username", username);
        session.setMaxInactiveInterval(30 * 60);   // 30 minutes
        response.sendRedirect(ctx + "/dashboard.jsp");
    }
}
