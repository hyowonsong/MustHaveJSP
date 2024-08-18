<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="membership.MemberDTO, membership.MemberDAO" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 처리</title>
</head>
<body>
    <h2>회원가입 처리 결과</h2>

    <%-- 폼에서 전송된 데이터 받기 --%>
    <% String id = request.getParameter("id"); %>
    <% String password = request.getParameter("password"); %>
    <% String name = request.getParameter("name"); %>

    <%-- 데이터가 비어 있는지 확인하여 처리 --%>
    <% if (id == null || id.trim().isEmpty() || password == null || password.trim().isEmpty() || name == null || name.trim().isEmpty()) { %>
        <% response.sendRedirect("RegisterFail.jsp?error=noid"); %>
    <% } else { %>
        <%-- MemberDTO 객체 생성 및 데이터 설정 --%>
        <% MemberDTO dto = new MemberDTO(); %>
        <% dto.setId(id); %>
        <% dto.setPass(password); %>
        <% dto.setName(name); %>

        <%-- DAO 객체 생성하여 회원 등록 처리 --%>
        <% MemberDAO dao = new MemberDAO(application.getInitParameter("OracleDriver"),
                                         application.getInitParameter("OracleURL"),
                                         application.getInitParameter("OracleId"),
                                         application.getInitParameter("OraclePwd")); %>
        <% boolean isSuccess = dao.insertMember(dto); %>

        <%-- 회원 등록 결과에 따라 리다이렉트 처리 --%>
        <% if (isSuccess) { %>
            <p>회원가입이 완료되었습니다.</p>
            <p><a href="RegisterSuccess.jsp">회원가입 성공 페이지로 이동</a></p>
        <% } else { %>
            <% response.sendRedirect("RegisterFail.jsp?error=idexists"); %>
        <% } %>
    <% } %>
</body>
</html>
