<%@ include file="./dashboard.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:include page="../db/db_connection.jsp" />
<!DOCTYPE html>
<html>
<head>
    <title>회원 관리</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="admin-container">
        <div class="content">
            <h1>회원 관리</h1>
            <table class="posts-table">
                <tr>
                    <th>번호</th>
                    <th>아이디</th>
                    <th>닉네임</th>
                    <th>이메일</th>
                    <th>가입일</th>
                    <th>유형</th>
                    <th>회원 삭제</th>
                    <th>상세 정보</th>
            </tr>
                <%
                    if (conn != null) {
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM users");
                        while (rs.next()) {
                            boolean is_Admin_ = rs.getBoolean("is_admin");
                %>
                <tr>
                    <td><%= rs.getInt("user_id") %></td>
            <td><%= rs.getString("username") %></td>
            <td><%= rs.getString("nickname") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                    <td>
                        <%
                            if (is_Admin_) {
                                out.print("관리자");
                            } else {
                                out.print("일반회원");
                            }
                        %>
                    </td>
                    <td>
                        <%
                            if (!is_Admin_) {
                        %>
                        <a href="/web/actions/delete_user_action.jsp?userId=<%= rs.getInt("user_id") %>" class="button">삭제</a>
                        <%
                            } else {
                        %>
                        삭제 불가
                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a href="/web/admin/user_info.jsp?user_id=<%= rs.getInt("user_id") %>" class="button">조회</a>
                    </td> 
            </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                    } else {
                %>
                <tr>
                    <td colspan="7">데이터베이스 연결에 실패했습니다.</td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
    </div>
</body>
</html>
