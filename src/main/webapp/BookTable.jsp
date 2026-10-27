<%@page import="java.sql.*, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Books - EBook Management System</title>
    <link rel="stylesheet" href="library.css">
    <link rel="stylesheet" href="app.css">
    <link rel="stylesheet" href="boxicons/css/boxicons.min.css">
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
                    <li><a href="library.jsp">My Library</a></li>
                    <li><a href="AddBook.jsp">Add Book</a></li>
                    <li><a href="BookTable.jsp" class="active">My Books</a></li>
                    <li><a href="LogoutServlet">Logout</a></li>
                </ul>
            </nav>
        </header>
        <main>
            <section class="library-section">
                <h2>Your Library</h2>

                <% if ("added".equals(msg)) { %><div class="flash success">Book added successfully!</div><% } %>
                <% if ("deleted".equals(msg)) { %><div class="flash success">Book deleted successfully!</div><% } %>
                <% if ("notfound".equals(msg)) { %><div class="flash error">Book not found.</div><% } %>
                <% if ("error".equals(msg)) { %><div class="flash error">The book could not be deleted (database error).</div><% } %>

                <table class="book-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Genre</th>
                            <th>Write</th>
                            <th>Read</th>
                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int rows = 0;
                            String dbError = null;
                            Connection conn = null;
                            Statement stmt = null;
                            ResultSet rs = null;
                            try {
                                conn = DBUtil.getConnection();
                                stmt = conn.createStatement();
                                rs = stmt.executeQuery("SELECT ID, TITLE, AUTHOR, GENRE FROM BOOK ORDER BY ID");

                                while (rs.next()) {
                                    rows++;
                                    int id = rs.getInt("ID");
                        %>
                                    <tr>
                                        <td><%= id %></td>
                                        <td><%= Html.esc(rs.getString("TITLE")) %></td>
                                        <td><%= Html.esc(rs.getString("AUTHOR")) %></td>
                                        <td><%= Html.esc(rs.getString("GENRE")) %></td>

                                        <!-- Write icon: edit the text of the book -->
                                        <td>
                                            <a href="write.jsp?id=<%= id %>" title="Write / edit">
                                                <center><i class='bx bxs-book-reader'></i></center>
                                            </a>
                                        </td>
                                        <!-- Read icon: open the book -->
                                        <td>
                                            <a href="viewContent.jsp?id=<%= id %>" title="Read">
                                                <center><i class='bx bxs-book-open'></i></center>
                                            </a>
                                        </td>
                                        <!-- Delete icon: asks for confirmation first -->
                                        <td>
                                            <a href="javascript:void(0);" onclick="confirmDelete(<%= id %>)" title="Delete">
                                                <center><i class='bx bxs-folder-minus'></i></center>
                                            </a>
                                        </td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                                application.log("BookTable.jsp: database error", e);
                                dbError = "The database could not be reached. Start the Java DB server or restart the application.";
                            } finally {
                                DBUtil.close(rs);
                                DBUtil.close(stmt);
                                DBUtil.close(conn);
                            }
                        %>
                    </tbody>
                </table>
                <% if (dbError != null) { %>
                    <div class="flash error"><%= dbError %></div>
                <% } else if (rows == 0) { %>
                    <p class="empty-state">You have no books yet. <a href="AddBook.jsp">Add your first book</a>.</p>
                <% } %>
            </section>
        </main>
    </div>

    <form id="deleteForm" method="post" action="DeleteBook.jsp" style="display:none">
        <input type="hidden" name="id" id="deleteId">
    </form>
    <script>
        function confirmDelete(id) {
            if (confirm("Are you sure you want to delete this book?")) {
                document.getElementById("deleteId").value = id;
                document.getElementById("deleteForm").submit();
            }
        }
    </script>
</body>
</html>
