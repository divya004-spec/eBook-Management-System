<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library - EBook Management System</title>
    <link rel="stylesheet" href="ELibrary.css">
</head>
<body>
    <div class="library-container">
        <header>
            <nav>
                <div class="logo">
                    <h1>EBook Library</h1>
                </div>
                <ul>
                    
                    <li><a href="ELibrary.jsp" class="active">Library</a></li>
                    <li><a href="library.jsp"> My Library</a></li>
                    
                    <li><a href="LogoutServlet.java">Logout</a></li>
                </ul>
            </nav>
        </header>
        <main>
            <section class="library-section">
                <h2>All Available Books</h2>
                <div class="books-grid">
                    <%
                        String url = "jdbc:derby://localhost:1527/Divya;create=true";
                        String user = "root";
                        String password = "root";
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            conn = DriverManager.getConnection(url, user, password);
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery("SELECT TITLE,AUTHOR,GENRE,C_PDF,COVER_IMG FROM EBOOKS");

                            while (rs.next()) {
                    %>
                                <div class="book-card">
                                    <img src="images/<%= rs.getString("COVER_IMG") %>" alt="Book Cover">
                                    <h3><%= rs.getString("TITLE") %></h3>
                                    <p>Author: <%= rs.getString("AUTHOR") %></p>
                                    <p>Genre: <%= rs.getString("GENRE") %></p>
                                    <a href="content/<%=rs.getString("C_PDF")%>" class="choose-btn">Choose Book</a>
                                </div>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (Exception e) {}
                            if (stmt != null) try { stmt.close(); } catch (Exception e) {}
                            if (conn != null) try { conn.close(); } catch (Exception e) {}
                        }
                    %>
                </div>
            </section>
        </main>
    </div>
</body>
</html>
