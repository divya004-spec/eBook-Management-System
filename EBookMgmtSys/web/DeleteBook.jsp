<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Book</title>
</head>
<body>
    <%
        String bookId = request.getParameter("id");  // Get the book ID from the request parameter

        if (bookId != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                // Database connection setup
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Divya", "root", "root");

                // Delete query
                String sql = "DELETE FROM BOOK WHERE id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(bookId));  // Set the book ID in the query

                // Execute the delete
                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Book successfully deleted
                    out.println("<h2>Book deleted successfully!</h2>");
                } else {
                    // No rows affected (invalid book ID)
                    out.println("<h2>Error: Book not found.</h2>");
                }

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                // Close resources
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        } else {
            out.println("<h2>Error: Invalid book ID.</h2>");
        }
    %>

    <a href="BookTable.jsp">Return to My Books</a>  <!-- Link back to the library page -->
</body>
</html>
