<%@page import="java.sql.*, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String idParam = request.getParameter("id");
    int bookId = Html.toId(idParam);

    String bookTitle = null;
    String bookContent = "";
    String problem = null;

    if (bookId < 0) {
        problem = "Book ID is missing or invalid. Please open this page from My Books.";
    } else {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT TITLE, CONTENT FROM BOOK WHERE ID = ?");
            ps.setInt(1, bookId);
            rs = ps.executeQuery();
            if (rs.next()) {
                bookTitle = rs.getString("TITLE");
                bookContent = Html.nz(rs.getString("CONTENT"), "");
            } else {
                problem = "No book found with the provided ID.";
            }
        } catch (Exception e) {
            application.log("write.jsp: database error", e);
            problem = "Database error occurred. Please try again later.";
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
    <title>Write Your Book</title>
    <link rel="stylesheet" href="global.css">
    <link rel="stylesheet" href="app.css">
</head>
<body>
    <div class="write-container">
        <header>
            <h1>Write Your Book</h1>
        </header>
        <main>
            <% if (problem != null) { %>
                <div class="flash error"><%= Html.esc(problem) %></div>
            <% } else { %>
                <h2><%= Html.esc(bookTitle) %></h2>

                <form method="post" action="saveBookContent.jsp">
                    <input type="hidden" name="id" value="<%= bookId %>">
                    <textarea name="content" rows="20" cols="100"><%= Html.esc(bookContent) %></textarea><br><br>
                    <button type="submit">Save</button>
                </form>
            <% } %>
            <div class="btn-row">
                <a href="BookTable.jsp">Back to My Books</a>
            </div>
        </main>
    </div>
</body>
</html>
