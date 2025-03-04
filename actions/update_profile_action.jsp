<%@ include file="../db/db_connection.jsp" %>
<%@ include file="../includes/md5.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");
    String currentPassword = request.getParameter("current_password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String nickname = request.getParameter("nickname");
    String phone = request.getParameter("phone");
    String securityQuestion = request.getParameter("security_question");
    String securityAnswer = request.getParameter("security_answer");
    String newPassword = request.getParameter("password");

    Statement stmt = null;
    ResultSet rs = null;

    try {
        String checkPasswordQuery = "SELECT password FROM users WHERE username = '" + username + "'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(checkPasswordQuery);

        if (rs.next()) {
            String db_Password = rs.getString("password");
            if (!db_Password.equals(getMD5(currentPassword))) {
                out.println("<script>alert('현재 비밀번호가 잘못되었습니다.'); history.back();</script>");
                return;
            }
        } else {
            out.println("<script>alert('사용자를 찾을 수 없습니다.'); history.back();</script>");
            return;
        }

        String query = "UPDATE users SET name = '" + name + 
                       "', email = '" + email + 
                       "', nickname = '" + nickname + 
                       "', phone = '" + phone + 
                       "', security_question = '" + securityQuestion + 
                       "', security_answer = '" + securityAnswer + "'";
        if (newPassword != null && !newPassword.isEmpty()) {
            query += ", password = '" + getMD5(newPassword) + "'";
        }
        query += " WHERE username = '" + username + "'";
        stmt.executeUpdate(query);
        out.println("<script>alert('정보가 성공적으로 수정되었습니다.'); location.href='../profile.jsp';</script>");
    } catch (Exception e) {
        out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
