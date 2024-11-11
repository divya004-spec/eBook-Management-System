<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Reading Dashboard</title>
    <link rel="stylesheet" href="d.css">
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
</style>
<body>
    <header>
        <nav>
            <ul>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="library.jsp">Library</a></li>
                <li><a href="addbook.jsp">Add Book</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="settings.jsp">Settings</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
    </header>

    <%
        String url = "jdbc:derby://localhost:1527/Divya;create=true";
        String user = "root";
        String password = "root";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        int totalBooks = 0;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(url, user, password);
            stmt = conn.createStatement();

            // Query for total books
            rs = stmt.executeQuery("SELECT COUNT(*) FROM EBOOKS");
            if (rs.next()) {
                totalBooks = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (stmt != null) try { stmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    %>

    <div class="dashboard">
        <div class="header">
            <h1>Book Reading Dashboard</h1>
        </div>

        <div class="cards">
            <div class="card total-books">
                <h2>Total Books</h2>
                <p><%= totalBooks %></p>
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
                
                           <div class="book-card">
                        <img src="images/bookcover.jpeg" alt="Book Cover">
                        <h3>Book Title</h3>
                        <p>Author: John Doe</p>
                        <p>Genre: Fiction</p>
                        <a href="#" class="choose-btn">Choose Book</a>
                    </div>
                    <!-- Add more book cards as needed -->
                    <div class="book-card">
                        <img src="images/OIP.jpg" alt="Book Cover">
                        <h3>Another Book</h3>
                        <p>Author: Jane Smith</p>
                        <p>Genre: Science Fiction</p>
                        <a href="#" class="choose-btn">Choose Book</a>
                    </div>
                    <div class="book-card">
                        <img src="images/OIP.jpg" alt="Book Cover">
                        <h3>Another Book</h3>
                        <p>Author: Jane Smith</p>
                        <p>Genre: Science Fiction</p>
                        <a href="#" class="choose-btn">Choose Book</a>
                    </div>
<div class="book-card">
                        <img src="images/OIP(2).jpg" alt="Book Cover">
                        <h3>Another Book</h3>
                        <p>Author: Jane Smith</p>
                        <p>Genre: Science Fiction</p>
                        <a href="#" class="choose-btn">Choose Book</a>
                    </div>

                
            </div>
        </div>
    </div>
</body>
</html>
