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
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** Handles the registration form (Register.jsp). */
public class RegisterServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(RegisterServlet.class.getName());
    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9_.-]{3,50}$");
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ctx = request.getContextPath();
        String username = trim(request.getParameter("username"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");

        if (!USERNAME.matcher(username).matches()
                || email.length() > 100 || !EMAIL.matcher(email).matches()
                || password == null || password.length() < 4 || password.length() > 100) {
            response.sendRedirect(ctx + "/Register.jsp?error=invalid");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBUtil.getConnection();

            ps = con.prepareStatement("SELECT COUNT(*) FROM USERS WHERE USERNAME = ? OR UPPER(EMAIL) = ?");
            ps.setString(1, username);
            ps.setString(2, email.toUpperCase());
            rs = ps.executeQuery();
            rs.next();
            boolean exists = rs.getInt(1) > 0;
            DBUtil.close(rs);
            DBUtil.close(ps);
            rs = null;
            ps = null;
            if (exists) {
                response.sendRedirect(ctx + "/Register.jsp?error=exists");
                return;
            }

            ps = con.prepareStatement("INSERT INTO USERS (USERNAME, EMAIL, PASSWORD) VALUES (?,?,?)");
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, PasswordUtil.hash(password));
            ps.executeUpdate();
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Registration failed", e);
            String state = e.getSQLState();
            response.sendRedirect(ctx + "/Register.jsp?error=" + ("23505".equals(state) ? "exists" : "db"));
            return;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(ps);
            DBUtil.close(con);
        }
        response.sendRedirect(ctx + "/LoginEbook.html?msg=registered");
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
