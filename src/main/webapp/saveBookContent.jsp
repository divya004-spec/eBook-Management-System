<%@page import="java.sql.*, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Only the Save button of write.jsp (POST) may change data
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("BookTable.jsp");
        return;
    }

    int bookId = Html.toId(request.getParameter("id"));
    String content = request.getParameter("content");
    if (content == null) {
        content = "";
    }

    boolean saved = false;
    if (bookId >= 0) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("UPDATE BOOK SET CONTENT = ? WHERE ID = ?");
            ps.setString(1, content);
            ps.setInt(2, bookId);
            saved = ps.executeUpdate() > 0;
        } catch (Exception e) {
            application.log("saveBookContent.jsp: database error", e);
        } finally {
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
    <title>Save Book Content</title>
    <link rel="stylesheet" href="saveContent.css">
</head>
<body>
    <div class="save-container">
        <h1>Saving Book Content</h1>
        <% if (saved) { %>
            <h3>Book content saved successfully!</h3>
            <p>
                <a href="viewContent.jsp?id=<%= bookId %>" class="btn">Read it now</a>
                <a href="BookTable.jsp" class="btn">Back to Library</a>
            </p>
        <% } else { %>
            <h3>Failed to save content.</h3>
            <p>The book was not found or the database is not reachable.</p>
            <p><a href="BookTable.jsp" class="btn">Back to Library</a></p>
        <% } %>
    </div>
</body>
</html>
