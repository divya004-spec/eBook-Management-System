<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Read Book</title>
</head>
<body>
    <%
        String bookId = request.getParameter("bookId");
        String url = "jdbc:derby://localhost:1527/Divya;create=true";
        String user = "root";
        String password = "root";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        String bookTitle = "";
        String bookAuthor = "";
        String bookContent = "";

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(url, user, password);
            stmt = conn.createStatement();

            String query = "SELECT title, author, content FROM EBOOKS WHERE id=" + bookId;
            rs = stmt.executeQuery(query);

            if (rs.next()) {
                bookTitle = rs.getString("title");
                bookAuthor = rs.getString("author");
                bookContent = rs.getString("content"); // Assuming there's a 'content' column in EBOOKS
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (stmt != null) try { stmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    %>

    <h1><%= bookTitle %></h1>
    <h3>By <%= bookAuthor %></h3>
    <hr>
    <div style="white-space: pre-line;">
        <%= bookContent %>
    </div>

</body>
</html>
