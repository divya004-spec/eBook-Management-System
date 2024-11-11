<%-- 
    Document   : saveBookContent
    Created on : 18 Sep, 2024, 9:02:09 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Save Book Content</title>
    <link rel="stylesheet" href="saveContent.css">
</head>
<body>
    <div class="save-container">
        <h1>Saving Book Content</h1>
        <% 
            int bookId = Integer.parseInt(request.getParameter("id"));
            String content = request.getParameter("content");

            Connection conn = null;
            PreparedStatement ps = null;

            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Divya", "root", "root");

                // Update book content in the database
                String updateQuery = "UPDATE BOOK SET content=? WHERE id=?";
                ps = conn.prepareStatement(updateQuery);
                ps.setString(1, content);
                ps.setInt(2, bookId);

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<h3>Book content saved successfully!</h3>");
                } else {
                    out.println("<h3>Failed to save content.</h3>");
                }

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
        <p><a href="BookTable.jsp" class="btn">Back to Library</a></p>
    </div>
</body>
</html>
