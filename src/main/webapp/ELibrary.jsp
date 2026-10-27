<%@page import="java.sql.*, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String q = request.getParameter("q");
    q = (q == null) ? "" : q.trim();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library - EBook Management System</title>
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
            <section class="library-section">
                <h2>All Available Books</h2>

                <form class="search-form" action="ELibrary.jsp" method="get">
                    <input type="search" name="q" value="<%= Html.esc(q) %>" placeholder="Search by title, author or genre">
                    <button type="submit">Search</button>
                    <% if (q.length() > 0) { %><a class="clear" href="ELibrary.jsp">Clear</a><% } %>
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
                            String sql = "SELECT ID, TITLE, AUTHOR, GENRE, C_PDF, COVER_IMG FROM EBOOKS";
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
                                String pdf = rs.getString("C_PDF");
                    %>
                                <div class="book-card">
                                    <img src="<%= Html.cover(rs.getString("COVER_IMG")) %>" alt="Book Cover">
                                    <h3><%= Html.esc(rs.getString("TITLE")) %></h3>
                                    <p>Author: <%= Html.esc(rs.getString("AUTHOR")) %></p>
                                    <p>Genre: <%= Html.esc(rs.getString("GENRE")) %></p>
                                    <div class="card-actions">
                                        <a href="Read.jsp?bookId=<%= rs.getInt("ID") %>" class="choose-btn">Read</a>
                                        <% if (pdf != null && pdf.trim().length() > 0) { %>
                                            <a href="content/<%= Html.url(pdf) %>" class="choose-btn secondary" download>Download</a>
                                        <% } %>
                                    </div>
                                </div>
                    <%
                            }
                        } catch (Exception e) {
                            application.log("ELibrary.jsp: database error", e);
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
                    <p class="empty-state">No books found<%= q.length() > 0 ? " for \"" + Html.esc(q) + "\"" : "" %>.</p>
                <% } %>
            </section>
        </main>
    </div>
</body>
</html>
