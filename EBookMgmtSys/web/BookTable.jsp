<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library - EBook Management System</title>
    <link rel="stylesheet" href="library.css">
    <link rel="stylesheet" href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css">
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
                    <li><a href="library.jsp">Library</a></li>
                    <li><a href="AddBook.jsp" >Add Book</a></li>
                    <li><a href="BookTable.jsp" class="active">My Books</a></li>
                    <li><a href="logout.jsp">Logout</a></li>                
                </ul>
            </nav>
        </header>
        <main>
            <section class="library-section">
                <h2>Your Library</h2>
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
                            // Database connection setup
                            Connection conn = null;
                            Statement stmt = null;
                            ResultSet rs = null;
                            
                            try {
                                Class.forName("org.apache.derby.jdbc.ClientDriver");
                                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Divya", "root", "root");
                                stmt = conn.createStatement();
                                String query = "SELECT id,title,author,genre FROM BOOK";
                                rs = stmt.executeQuery(query);
                                
                                // Fetching and displaying book data
                                while (rs.next()) {
                                    int id = rs.getInt("id");
                                    String title = rs.getString("title");
                                    String author = rs.getString("author");
                                    String genre = rs.getString("genre");
                                   
                        %>
                                    <tr>
                                        <td><%= id %></td>
                                        <td><%= title %></td>
                                        <td><%= author %></td>
                                        <td><%= genre %></td>
                                       
                                        <!-- Write Icon to redirect to writing page -->
                                        <td>
                                            <a href="write.jsp?id=<%= id %>">
                                                <center><i class='bx bxs-book-reader'></i></center>
                                            </a>
                                        </td>
                                        <!-- Read Icon to redirect to reading page -->
                                        <td>
                                            <a href="viewContent.jsp?id=<%= id %>">
                                                <center><i class='bx bxs-book-open'></i></center>
                                            </a>
                                        </td>
                                        <td>
                                            <a href="javascript:void(0);" onclick="confirmDelete(<%= id %>)">
                                            <center><i class='bx bxs-folder-minus'></i></center>
                                            </a>
                                        </td>
                                        <script>
    function confirmDelete(id) {
        var result = confirm("Are you sure you want to delete this book?");
        if (result) {
            window.location.href = 'DeleteBook.jsp?id=' + id;
        }
    }
</script>

                                    </tr>
                        <% 
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                // Close resources
                                try {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            }
                        %>
                    </tbody>
                </table>
            </section>
        </main>
    </div>
</body>
</html>
