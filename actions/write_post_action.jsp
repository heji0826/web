<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ include file="../db/db_connection.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 폼 값들
    String title = null;
    String content = null;
    String fileName = null;
    int userId = 0;

    // 게시판 종류 설정 (user 또는 admin 또는 vip)
    String boardType = "user";

    // 사용자 정보
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("/web/login.jsp");
        return;
    }

    // 사용자 ID 조회 (데이터베이스에서 user_id를 가져옴)
    Statement stmt = null;
    ResultSet rs = null;
    try {
        String query = "SELECT user_id FROM users WHERE username = '" + username + "'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);

        if (rs.next()) {
            userId = rs.getInt("user_id");
        } else {
            response.sendRedirect("/web/login.jsp");
            return;
        }
    } catch (Exception e) {
        out.println("사용자 정보 조회 오류: " + e.getMessage());
        return;
    } finally {
        if (stmt != null) stmt.close();
        if (rs != null) rs.close();
    }

    // 파일 업로드를 위한 설정
    DiskFileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);

    try {
        // 파일 업로드 처리
        List<FileItem> items = upload.parseRequest(request);
        for (FileItem item : items) {
            if (item.isFormField()) {
                if ("title".equals(item.getFieldName())) {
                    title = item.getString("UTF-8");
                } else if ("content".equals(item.getFieldName())) {
                    content = item.getString("UTF-8");
                } else if ("boardType".equals(item.getFieldName())) {
                    boardType = item.getString("UTF-8");
                }
            } else {
                // attachment에 파일이 있나 확인
                if (item.getName() == null || item.getName().isEmpty()) {
                    continue;  // 파일이 없는 경우 다음 아이템으로 넘어감
                } else {
                    fileName = new File(item.getName()).getName();
                    File uploadDir = new File(getServletContext().getRealPath("/") + "uploads/");
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    File uploadedFile = new File(uploadDir + "/" + fileName);
                    item.write(uploadedFile);  // 파일 업로드
                }
            }
        }

        // 게시물 정보 DB에 삽입
        String insertQuery = "";
        if ("admin".equals(boardType)) {
            insertQuery = "INSERT INTO admin_posts (title, content, attachment_path, created_at, updated_at, user_id) VALUES ('" +
                           title + "', '" + content + "', '" + fileName + "', NOW(), NOW(), " + userId + ")";
        } else if ("user".equals(boardType)) {
            insertQuery = "INSERT INTO user_posts (title, content, attachment_path, created_at, updated_at, user_id) VALUES ('" +
                           title + "', '" + content + "', '" + fileName + "', NOW(), NOW(), " + userId + ")";
        } else {
            insertQuery = "INSERT INTO vip_posts (title, content, attachment_path, created_at, updated_at, user_id) VALUES ('" +
                           title + "', '" + content + "', '" + fileName + "', NOW(), NOW(), " + userId + ")";
        }

        // INSERT 쿼리 실행
        stmt = conn.createStatement();
        stmt.executeUpdate(insertQuery);

        // 게시물 등록 후 리디렉션
        if ("admin".equals(boardType)) {
            response.sendRedirect("/web/board/admin_board.jsp");
        } else if ("user".equals(boardType)) {
            response.sendRedirect("/web/board/user_board.jsp");
        } else {
            response.sendRedirect("/web/board/vip_board.jsp");
        }
    } catch (Exception e) {
        out.println("파일 업로드 또는 게시물 등록에 실패했습니다. 오류: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
