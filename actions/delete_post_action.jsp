<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../db/db_connection.jsp" %>
<%
    int postId = Integer.parseInt(request.getParameter("postId"));
    String boardType = request.getParameter("boardType");

    PreparedStatement pstmt = null;
    try {
        String deleteQuery = "";
        if ("admin".equals(boardType)) {
            deleteQuery = "DELETE FROM admin_posts WHERE post_id = ?";
        } else if("vip".equals(boardType)){
            deleteQuery = "DELETE FROM vip_posts WHERE post_id = ?";
        } else {
            deleteQuery = "DELETE FROM user_posts WHERE post_id = ?";
        }

        pstmt = conn.prepareStatement(deleteQuery);
        pstmt.setInt(1, postId);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            // 게시물 삭제 후 게시판 목록으로 리디렉션
            if ("admin".equals(boardType)) {
                response.sendRedirect("/web/board/admin_board.jsp");
            } else if("vip".equals(boardType)){
                response.sendRedirect("/web/board/vip_board.jsp");
            } else {
                response.sendRedirect("/web/board/user_board.jsp");
            }
        } else {
            out.println("게시물 삭제 실패");
        }
    } catch (Exception e) {
        out.println("게시물 삭제 중 오류 발생: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
    }
%>