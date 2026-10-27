<%@page import="java.sql.*, com.ebookmanagement.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Deleting is only accepted via POST (forms with a confirmation in BookTable.jsp / library.jsp)
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("BookTable.jsp");
        return;
    }

    int bookId = Html.toId(request.getParameter("id"));
    String back = "library".equals(request.getParameter("from")) ? "library.jsp" : "BookTable.jsp";
    String result = "notfound";

    if (bookId >= 0) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("DELETE FROM BOOK WHERE ID = ?");
            pstmt.setInt(1, bookId);
            if (pstmt.executeUpdate() > 0) {
                result = "deleted";
            }
        } catch (Exception e) {
            application.log("DeleteBook.jsp: database error", e);
            result = "error";
        } finally {
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }
    response.sendRedirect(back + "?msg=" + result);
%>
