<%@page import="java.sql.*, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Online reader for the PDF books in the EBOOKS table (opened from the Library / dashboard)
    int bookId = Html.toId(request.getParameter("bookId"));
    String title = null, author = null, genre = null, pdf = null;
    String dbError = null;

    if (bookId >= 0) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT TITLE, AUTHOR, GENRE, C_PDF FROM EBOOKS WHERE ID = ?");
            ps.setInt(1, bookId);
            rs = ps.executeQuery();
            if (rs.next()) {
                title = rs.getString("TITLE");
                author = rs.getString("AUTHOR");
                genre = rs.getString("GENRE");
                pdf = rs.getString("C_PDF");
            }
        } catch (Exception e) {
            application.log("Read.jsp: database error", e);
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
    <title>Read Book<%= title != null ? " - " + Html.esc(title) : "" %></title>
    <link rel="stylesheet" href="ELibrary.css">
    <link rel="stylesheet" href="app.css">
</head>
<body>
    <div class="library-container">
        <header>
            <nav>
                <div class="logo">
                    <h1>EBook Library</h1>
                </div>
                <ul>
                    <li><a href="dashboard.jsp">Dashboard</a></li>
                    <li><a href="ELibrary.jsp" class="active">Library</a></li>
                    <li><a href="library.jsp">My Library</a></li>
                    <li><a href="LogoutServlet">Logout</a></li>
                </ul>
            </nav>
        </header>
        <main>
            <% if (dbError != null) { %>
                <div class="flash error"><%= dbError %></div>
            <% } else if (title == null) { %>
                <p class="empty-state" style="text-align:center">Book not found. <a href="ELibrary.jsp">Back to the library</a>.</p>
            <% } else { %>
                <section class="reader-wrap">
                    <h2><%= Html.esc(title) %></h2>
                    <p class="meta">By <%= Html.esc(author) %> &middot; <%= Html.esc(genre) %></p>
                    <% if (pdf != null && pdf.trim().length() > 0) { %>
                        <iframe class="reader-frame" src="content/<%= Html.url(pdf) %>" title="<%= Html.esc(title) %>"></iframe>
                        <div class="btn-row">
                            <a href="content/<%= Html.url(pdf) %>" download>Download PDF</a>
                            <a href="ELibrary.jsp">Back to Library</a>
                        </div>
                    <% } else { %>
                        <p class="empty-state">No PDF file is attached to this book.</p>
                        <div class="btn-row"><a href="ELibrary.jsp">Back to Library</a></div>
                    <% } %>
                </section>
            <% } %>
        </main>
    </div>
</body>
</html>
