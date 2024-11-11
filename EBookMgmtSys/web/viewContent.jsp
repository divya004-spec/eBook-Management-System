<%-- 
    Document   : viewContent
    Created on : 18 Sep, 2024, 9:06:58 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page session="true" %> <!-- Enables session management -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Read Book Content</title>
    <link rel="stylesheet" href="viewContent.css">
</head>
<body>
    <div class="view-container">
        <header>
            <h1>Read Book Content</h1>
        </header>
        <main>
            <% 
                int bookId = Integer.parseInt(request.getParameter("id"));
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                String content = "";
                String title = "";
                String author = "";
                String publishedDate = "";

                try {
                    // Establish database connection
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Divya", "root", "root");
                    stmt = conn.createStatement();

                    // Query to get the content and other metadata from the BOOK table
                    String query = "SELECT title, author, content, published_date FROM BOOK WHERE id=" + bookId;
                    rs = stmt.executeQuery(query);

                    if (rs.next()) {
                        // Fetch book details
                        title = rs.getString("title");
                        author = rs.getString("author");
                        content = rs.getString("content");
                        publishedDate = rs.getString("published_date");

                        // Store in session to make it available across pages
                        session.setAttribute("bookTitle", title);
                        session.setAttribute("bookAuthor", author);
                        session.setAttribute("publishedDate", publishedDate);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            %>

            <!-- Display the book content -->
            <h2>Title: <%= session.getAttribute("bookTitle") %></h2>
            <p>Author: <%= session.getAttribute("bookAuthor") %></p>
            <p>Published Date: <%= session.getAttribute("publishedDate") %></p>

            <div class="book-content">
                <pre><%= content %></pre>
            </div>

            <p><a href="library.jsp">Back to Library</a></p>
        </main>
    </div>
</body>
</html>
