<%@page import="java.sql.*, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String q = request.getParameter("q");
    q = (q == null) ? "" : q.trim();
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Library - EBook Management System</title>
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
                    <li><a href="ELibrary.jsp">Library</a></li>
                    <li><a href="library.jsp" class="active">My Library</a></li>
                    <li><a href="AddBook.jsp">Add Book</a></li>
                    <li><a href="LogoutServlet">Logout</a></li>
                </ul>
            </nav>
        </header>
        <main>
            <section class="library-section">
                <h2>My Library</h2>

                <% if ("deleted".equals(msg)) { %><div class="flash success">Book deleted successfully.</div><% } %>
                <% if ("notfound".equals(msg)) { %><div class="flash error">Book not found.</div><% } %>
                <% if ("error".equals(msg)) { %><div class="flash error">The book could not be deleted (database error).</div><% } %>

                <form class="search-form" action="library.jsp" method="get">
                    <input type="search" name="q" value="<%= Html.esc(q) %>" placeholder="Search by title, author or genre">
                    <button type="submit">Search</button>
                    <% if (q.length() > 0) { %><a class="clear" href="library.jsp">Clear</a><% } %>
                </form>

                <div class="books-grid">
                    <%
                        int shown = 0;
                        String dbError = null;
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            conn = DBUtil.getConnection();
                            String sql = "SELECT ID, TITLE, AUTHOR, GENRE, COVER_IMG FROM BOOK";
                            if (q.length() > 0) {
                                sql += " WHERE UPPER(TITLE) LIKE ? OR UPPER(AUTHOR) LIKE ? OR UPPER(GENRE) LIKE ?";
                            }
                            sql += " ORDER BY ID";
                            ps = conn.prepareStatement(sql);
                            if (q.length() > 0) {
                                String like = "%" + q.toUpperCase() + "%";
                                ps.setString(1, like);
                                ps.setString(2, like);
                                ps.setString(3, like);
                            }
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                shown++;
                                int id = rs.getInt("ID");
                    %>
                                <div class="book-card">
                                    <img src="<%= Html.cover(rs.getString("COVER_IMG")) %>" alt="Book Cover">
                                    <h3><%= Html.esc(rs.getString("TITLE")) %></h3>
                                    <p>Author: <%= Html.esc(rs.getString("AUTHOR")) %></p>
                                    <p>Genre: <%= Html.esc(rs.getString("GENRE")) %></p>
                                    <div class="card-actions">
                                        <a href="viewContent.jsp?id=<%= id %>" class="choose-btn">Read</a>
                                        <a href="write.jsp?id=<%= id %>" class="choose-btn secondary">Write</a>
                                        <form method="post" action="DeleteBook.jsp"
                                              onsubmit="return confirm('Are you sure you want to delete this book?');">
                                            <input type="hidden" name="id" value="<%= id %>">
                                            <input type="hidden" name="from" value="library">
                                            <button type="submit" class="choose-btn danger">Delete</button>
                                        </form>
                                    </div>
                                </div>
                    <%
                            }
                        } catch (Exception e) {
                            application.log("library.jsp: database error", e);
                            dbError = "The database could not be reached. Start the Java DB server or restart the application.";
                        } finally {
                            DBUtil.close(rs);
                            DBUtil.close(ps);
                            DBUtil.close(conn);
                        }
                    %>
                </div>
                <% if (dbError != null) { %>
                    <div class="flash error"><%= dbError %></div>
                <% } else if (shown == 0) { %>
                    <p class="empty-state">No books found. <a href="AddBook.jsp">Add your first book</a>.</p>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>
