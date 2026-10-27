<%@page import="java.sql.*, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int bookId = Html.toId(request.getParameter("id"));
    String msg = request.getParameter("msg");

    boolean found = false;
    String title = "", author = "", genre = "", isbn = "", publishedDate = "", content = null;
    String dbError = null;

    if (bookId >= 0) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT TITLE, AUTHOR, GENRE, ISBN, CONTENT, PUBLISHED_DATE FROM BOOK WHERE ID = ?");
            ps.setInt(1, bookId);
            rs = ps.executeQuery();
            if (rs.next()) {
                found = true;
                title = rs.getString("TITLE");
                author = rs.getString("AUTHOR");
                genre = Html.nz(rs.getString("GENRE"), "-");
                isbn = Html.nz(rs.getString("ISBN"), "-");
                publishedDate = Html.nz(rs.getString("PUBLISHED_DATE"), "-");
                content = rs.getString("CONTENT");
            }
        } catch (Exception e) {
            application.log("viewContent.jsp: database error", e);
            dbError = "The database could not be reached. Start the Java DB server or restart the application.";
        } finally {
            DBUtil.close(rs);
            DBUtil.close(ps);
            DBUtil.close(conn);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Read Book Content</title>
    <link rel="stylesheet" href="viewContent.css">
    <link rel="stylesheet" href="app.css">
</head>
<body>
    <div class="view-container">
        <header>
            <h1>Read Book Content</h1>
        </header>
        <main>
            <% if ("saved".equals(msg)) { %><div class="flash success">Book content saved successfully!</div><% } %>

            <% if (dbError != null) { %>
                <div class="flash error"><%= dbError %></div>
            <% } else if (!found) { %>
                <p>Book not found.</p>
            <% } else { %>
                <h2>Title: <%= Html.esc(title) %></h2>
                <p>Author: <%= Html.esc(author) %></p>
                <p>Genre: <%= Html.esc(genre) %> &nbsp;|&nbsp; ISBN: <%= Html.esc(isbn) %></p>
                <p>Published Date: <%= Html.esc(publishedDate) %></p>

                <div class="book-content">
                    <% if (content == null || content.trim().length() == 0) { %>
                        <pre>(This book has no content yet. Use the Write button to add some.)</pre>
                    <% } else { %>
                        <pre><%= Html.esc(content) %></pre>
                    <% } %>
                </div>

                <div class="btn-row">
                    <a href="write.jsp?id=<%= bookId %>">Write / Edit</a>
                </div>
            <% } %>

            <div class="btn-row">
                <a href="library.jsp">Back to Library</a>
                <a href="BookTable.jsp">My Books</a>
            </div>
        </main>
    </div>
</body>
</html>
