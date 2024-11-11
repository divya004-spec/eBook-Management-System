<%-- 
    Document   : AddBook
    Created on : 17 Sep, 2024, 5:20:12 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Book - EBook Management System</title>
    <link rel="stylesheet" href="add-book.css">
</head>
<body>
    <div class="add-book-container">
        <header>
            <nav>
                <div class="logo">
                    <h1>EBook Library</h1>
                </div>
                <ul>
                    <li><a href="dashboard.jsp">Dashboard</a></li>
                    <li><a href="library.jsp">Library</a></li>
                    <li><a href="AddBook.jsp" class="active">Add Book</a></li>
                    <li><a href="BookTable.jsp">My Books</a></li>
                    <li><a href="logout.jsp">Logout</a></li>
                </ul>
            </nav>
        </header>
        <main>
            <section class="add-book-section">
                <h2>Add New Book</h2>
                <form class="add-book-form" action="AddBookServlet" method="post">
                    
                    <div class="form-group">
                        <label for="id">Book Title:</label>
                        <input type="text" id="title" name="title" placeholder="Enter book title" required>
                    </div>
                    <div class="form-group">
                        <label for="author">Author:</label>
                        <input type="text" id="author" name="author" placeholder="Enter author's name" required>
                    </div>
                    <div class="form-group">
                        <label for="genre">Genre:</label>
                        <input type="text" id="genre" name="genre" placeholder="Enter genre" required>
                    </div>
                    <div class="form-group">
                        <label for="published_date">Published Date</label>
                        <input type="date" id="published_date" name="published_date" placeholder="Enter published_date" required>
                    </div>
                    <div class="form-group">
                        <label for="cover_img">Cover image :</label>
                        <input type="text" id="cover_img" name="cover_img" placeholder="Enter cover_img path" required>
                    </div>
                    <button type="submit" class="submit-btn">Add Book</button>
                </form>

            </section>
        </main>
    </div>
</body>
</html>
