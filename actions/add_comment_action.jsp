<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");
    String content = request.getParameter("content");
    int postId = Integer.parseInt(request.getParameter("post_id"));
    String boardType = request.getParameter("board_type");

    String nickname = null;
    int userId = 0;
    PreparedStatement stmt = null;
    PreparedStatement nicknameStmt = null;
    ResultSet nicknameRs = null;
    PreparedStatement userStmt = null;
    ResultSet userRs = null;

    try {
        // 유효하지 않은 사용자일 경우
        if (username == null) {
            response.sendRedirect("/web/login.jsp");
            return;
        }
        // 사용자 닉네임 및 user_id 조회
        String nicknameQuery = "SELECT nickname, user_id FROM users WHERE username = ?";
        nicknameStmt = conn.prepareStatement(nicknameQuery);
        nicknameStmt.setString(1, username);
        nicknameRs = nicknameStmt.executeQuery();

        if (nicknameRs.next()) {
            nickname = nicknameRs.getString("nickname");
            userId = nicknameRs.getInt("user_id");
        }

        // 유효한 사용자 여부 확인
        String userCheckQuery = "SELECT COUNT(*) FROM users WHERE user_id = ?";
        userStmt = conn.prepareStatement(userCheckQuery);
        userStmt.setInt(1, userId);
        userRs = userStmt.executeQuery();

        if (userRs.next() && userRs.getInt(1) > 0) {
            // board_type에 따라 댓글 테이블 선택
            String commentTable = "user_comments";
            if ("admin".equals(boardType)) {
                commentTable = "admin_comments";
            }

            // 댓글 삽입 쿼리
            String query = "INSERT INTO " + commentTable + " (post_id, user_id, content) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            stmt.setString(3, content);
            stmt.executeUpdate();

            // 게시물 상세보기 페이지로 리디렉션
            response.sendRedirect("../board/post.jsp?id=" + postId + "&boardType=" + boardType);
        } else {
            response.sendRedirect("/web/login.jsp");
        }
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (nicknameStmt != null) nicknameStmt.close();
        if (nicknameRs != null) nicknameRs.close();
        if (userStmt != null) userStmt.close();
        if (userRs != null) userRs.close();
        if (conn != null) conn.close();
    }
%>