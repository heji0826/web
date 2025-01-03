<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8"); // 요청 인코딩을 UTF-8로 설정
    response.setCharacterEncoding("UTF-8"); // 응답 인코딩을 UTF-8로 설정
    int commentId = Integer.parseInt(request.getParameter("comment_id"));
    String content = request.getParameter("content");
    String boardType = request.getParameter("boardType");

    String commentTable = "user_comments";
    if ("admin".equals(boardType)) {
        commentTable = "admin_comments";
    }
    else if("vip".equals(boardType)){
        commentTable = "vip_comments";
    }

    Statement stmt = null;
    try {
        String updateQuery = "UPDATE " + commentTable + " SET content = '" + content + "' WHERE comment_id = " + commentId;
        stmt = conn.createStatement();
        stmt.executeUpdate(updateQuery);
        
        // 댓글 수정 후 리디렉션 (원래 페이지로 돌아가도록 처리)
        response.sendRedirect(request.getHeader("Referer"));
    } catch (Exception e) {
        e.printStackTrace();
        out.println("수정 중 오류가 발생했습니다.");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
