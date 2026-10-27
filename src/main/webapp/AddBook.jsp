<%@page import="java.io.File, java.util.Arrays, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = request.getParameter("error");
    String message = null;
    if ("invalid".equals(error)) {
        message = "Please check the form: title and author are required and the date must be valid.";
    } else if ("db".equals(error)) {
        message = "The book could not be saved because the database is not reachable.";
    }

    // list the cover pictures that exist in /images for the suggestion list
    String[] covers = new String[0];
    String imagesPath = application.getRealPath("/images");
    if (imagesPath != null) {
        String[] all = new File(imagesPath).list();
        if (all != null) {
            Arrays.sort(all);
            covers = all;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Book - EBook Management System</title>
    <link rel="stylesheet" href="add-book.css">
    <link rel="stylesheet" href="app.css">
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
                    <li><a href="library.jsp">My Library</a></li>
                    <li><a href="AddBook.jsp" class="active">Add Book</a></li>
                    <li><a href="BookTable.jsp">My Books</a></li>
                    <li><a href="LogoutServlet">Logout</a></li>
                </ul>
            </nav>
        </header>
        <main>
            <section class="add-book-section">
                <h2>Add New Book</h2>
                <% if (message != null) { %>
                    <div class="flash error"><%= message %></div>
                <% } %>
                <form class="add-book-form" action="AddBookServlet" method="post">

                    <div class="form-group">
                        <label for="title">Book Title:</label>
                        <input type="text" id="title" name="title" placeholder="Enter book title" maxlength="255" required>
                    </div>
                    <div class="form-group">
                        <label for="author">Author:</label>
                        <input type="text" id="author" name="author" placeholder="Enter author's name" maxlength="255" required>
                    </div>
                    <div class="form-group">
                        <label for="genre">Genre:</label>
                        <input type="text" id="genre" name="genre" placeholder="Enter genre" maxlength="100" required>
                    </div>
                    <div class="form-group">
                        <label for="published_date">Published Date</label>
                        <input type="date" id="published_date" name="published_date" required>
                    </div>
                    <div class="form-group">
                        <label for="isbn">ISBN (optional):</label>
                        <input type="text" id="isbn" name="isbn" placeholder="Enter ISBN" maxlength="20">
                    </div>
                    <div class="form-group">
                        <label for="cover_img">Cover image (optional):</label>
                        <input type="text" id="cover_img" name="cover_img" list="cover-list"
                               placeholder="File name inside the images folder, e.g. OIP.jpg" maxlength="255">
                        <datalist id="cover-list">
                            <% for (String c : covers) {
                                   String lc = c.toLowerCase();
                                   if (lc.endsWith(".jpg") || lc.endsWith(".jpeg") || lc.endsWith(".png")
                                           || lc.endsWith(".gif") || lc.endsWith(".webp")) { %>
                                <option value="<%= Html.esc(c) %>"></option>
                            <%     }
                               } %>
                        </datalist>
                        <small>Leave empty to use the default cover. You can also paste a full http(s) image URL.</small>
                    </div>
                    <div class="form-group">
                        <label for="content">Book text (optional):</label>
                        <textarea id="content" name="content" rows="6" placeholder="You can also write the text later with the Write icon in My Books"></textarea>
                    </div>
                    <button type="submit" class="submit-btn">Add Book</button>
                </form>

            </section>
        </main>
    </div>
</body>
</html>
