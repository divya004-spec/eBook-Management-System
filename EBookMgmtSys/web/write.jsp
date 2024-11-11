<%-- 
    Document   : write
    Created on : 18 Sep, 2024, 8:47:58 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Write Your Book</title>
    <link rel="stylesheet" href="global.css">
</head>
<body>
    <div class="write-container">
        <header>
            <h1>Write Your Book</h1>
        </header>
        <main>
            <%
                // Declare variables outside of try block for wider scope
                String bookTitle = "";
                String bookContent = "";
                String idParam = request.getParameter("id");

                if (idParam != null && !idParam.isEmpty()) {
                    try {
                        int bookId = Integer.parseInt(idParam);
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;

                        try {
                            // Establish database connection
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Divya", "root", "root");
                            stmt = conn.createStatement();

                            // Fetch book details based on the ID
                            String query = "SELECT title, content FROM BOOK WHERE id=" + bookId;
                            rs = stmt.executeQuery(query);

                            if (rs.next()) {
                                bookTitle = rs.getString("title");
                                bookContent = rs.getString("content"); // Assuming 'content' exists in DB
                            } else {
                                out.println("<p>No book found with the provided ID.</p>");
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                            out.println("<p>Database error occurred. Please try again later.</p>");
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }
                    } catch (NumberFormatException e) {
                        out.println("<p>Invalid book ID format. Please check the URL.</p>");
                    }
                } else {
                    out.println("<p>Book ID is missing. Please check the URL.</p>");
                }
            %>

            <% if (!bookTitle.isEmpty()) { %>
                <h2><%= bookTitle %></h2>

                <form method="post" action="saveBookContent.jsp">
                    <input type="hidden" name="id" value="<%= idParam %>">
                    <textarea name="content" rows="20" cols="100"><%= bookContent %></textarea><br><br>
                    <button type="submit">Save</button>
                </form>
            <% } %>
        </main>
    </div>
</body>
</html>
