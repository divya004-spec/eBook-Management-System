<%@page import="java.sql.*, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");

    int totalEbooks = 0;
    int totalMyBooks = 0;
    String dbError = null;
    java.util.List<String[]> featured = new java.util.ArrayList<String[]>();

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        conn = DBUtil.getConnection();
        stmt = conn.createStatement();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM EBOOKS");
        if (rs.next()) {
            totalEbooks = rs.getInt(1);
        }
        DBUtil.close(rs);

        rs = stmt.executeQuery("SELECT COUNT(*) FROM BOOK");
        if (rs.next()) {
            totalMyBooks = rs.getInt(1);
        }
        DBUtil.close(rs);

        rs = stmt.executeQuery("SELECT ID, TITLE, AUTHOR, GENRE, COVER_IMG FROM EBOOKS ORDER BY ID FETCH FIRST 4 ROWS ONLY");
        while (rs.next()) {
            featured.add(new String[] { String.valueOf(rs.getInt("ID")), rs.getString("TITLE"),
                rs.getString("AUTHOR"), rs.getString("GENRE"), rs.getString("COVER_IMG") });
        }
    } catch (Exception e) {
        application.log("dashboard.jsp: database error", e);
        dbError = "The database could not be reached. Start the Java DB server or restart the application.";
    } finally {
        DBUtil.close(rs);
        DBUtil.close(stmt);
        DBUtil.close(conn);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Reading Dashboard</title>
    <link rel="stylesheet" href="app.css">
</head>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Arial', sans-serif;
        background: linear-gradient(to right, #ece9e6, #ffffff);
        display: flex;
        flex-direction: column;
        align-items: center;
        height: auto;
    }

    /* Navbar Styles */
    header {
        width: 100%;
        background-color: #333;
        padding: 15px 0;
        color: #fff;
    }

    nav {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    nav ul {
        list-style: none;
        display: flex;
        gap: 20px;
    }

    nav ul li a {
        color: #fff;
        text-decoration: none;
        font-size: 18px;
        transition: color 0.3s;
    }

    nav ul li a:hover {
        color: #4CAF50;
    }

    .dashboard {
        width: 80%;
        max-width: 1000px;
        text-align: center;
        margin-top: 20px;
    }

    .header {
        margin-bottom: 30px;
    }

    .header h1 {
        font-size: 2.5em;
        color: #333;
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
    }

    .cards {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 20px;
        position:center;
    }

    .card {
        background: #ffffff;
        padding: 20px;
        border-radius: 15px;
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s, box-shadow 0.3s;
        position: relative;
        overflow: hidden;
    }

    .card h2 {
        font-size: 1.8em;
        margin-bottom: 10px;
        color: #333;
    }

    .card p {
        font-size: 1.5em;
        color: #555;
    }

    .card button {
        padding: 10px 20px;
        background-color: black;
        color: #fff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 1em;
        transition: background-color 0.3s;
    }

    .card button:hover {
        background-color: #5754e8;
    }

    .book-card {
        display: flex;
        flex-direction: column;
        background: #f9f9f9;
        padding: 15px;
        border-radius: 10px;
        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s;
    }

    .book-card img {
        max-width: 100%;
        border-radius: 5px;
        margin-bottom: 10px;
    }

    .book-card h3 {
        font-size: 1.4em;
        margin-bottom: 5px;
        color: #333;
    }

    .book-card p {
        font-size: 1em;
        color: #777;
        margin-bottom: 10px;
    }

    .book-card:hover {
        transform: translateY(-5px);
    }

    .welcome { margin-top: 8px; color: #666; }
    .book-card .choose-btn {
        display: inline-block; padding: 10px 15px; background: #4CAF50; color: #fff;
        border-radius: 5px; text-decoration: none; font-size: 16px; margin-top: auto;
    }
    .book-card .choose-btn:hover { background: #45a049; }
    .book-card { text-align: center; }
</style>
<body>
    <header>
        <nav>
            <ul>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="ELibrary.jsp">Library</a></li>
                <li><a href="library.jsp">My Library</a></li>
                <li><a href="AddBook.jsp">Add Book</a></li>
                <li><a href="BookTable.jsp">My Books</a></li>
                <li><a href="LogoutServlet">Logout (<%= Html.esc(username) %>)</a></li>
            </ul>
        </nav>
    </header>

    <div class="dashboard">
        <div class="header">
            <h1>Book Reading Dashboard</h1>
            <p class="welcome">Welcome back, <b><%= Html.esc(username) %></b>!</p>
        </div>

        <% if (dbError != null) { %>
            <div class="flash error"><%= dbError %></div>
        <% } %>

        <div class="cards">
            <div class="card total-books">
                <h2>Total Books</h2>
                <p><%= totalEbooks %></p>
            </div>
            <div class="card my-books">
                <h2>My Books</h2>
                <p><%= totalMyBooks %></p>
            </div>
            <div class="card books-read">
                <h2>Read Books</h2>
                <a href="ELibrary.jsp"><button>Click</button></a>
            </div>
            <div class="card currently-reading">
                <h2>My Library</h2>
                <a href="library.jsp"><button>Click</button></a>
            </div>
            <div class="card add-book">
                <h2>Add Book</h2>
                <a href="AddBook.jsp"><button>Add</button></a>
            </div>
        </div>

        <div class="book-cards">
            <h2 style="margin: 30px 0;">Our Content</h2>
            <div class="cards">
                <% for (String[] b : featured) { %>
                    <div class="book-card">
                        <img src="<%= Html.cover(b[4]) %>" alt="Book Cover">
                        <h3><%= Html.esc(b[1]) %></h3>
                        <p>Author: <%= Html.esc(b[2]) %></p>
                        <p>Genre: <%= Html.esc(b[3]) %></p>
                        <a href="Read.jsp?bookId=<%= b[0] %>" class="choose-btn">Choose Book</a>
                    </div>
                <% } %>
                <% if (featured.isEmpty() && dbError == null) { %>
                    <p>No books available yet.</p>
                <% } %>
            </div>
        </div>
        <p class="db-badge">Database: <%= Html.esc(DBUtil.getModeDescription()) %></p>
    </div>
</body>
</html>
