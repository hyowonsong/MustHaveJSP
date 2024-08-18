<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 페이지</title>
    <link rel="stylesheet" href="../css/styles.css">
    <script>
    function validateForm(form) {
        if (!form.user_id.value) {
            alert("아이디를 입력하세요.");
            return false;
        }
        if (form.user_pw.value === "") {
            alert("패스워드를 입력하세요.");
            return false;
        }
        return true;
    }
    </script>
</head>
<body>
    <div class="container">
        <jsp:include page="../Common/Link.jsp" />
        <h2>로그인 페이지</h2>
        <span class="error-message">
            <%= request.getAttribute("LoginErrMsg") == null ? "" : request.getAttribute("LoginErrMsg") %>
        </span>
        <% if (session.getAttribute("UserId") == null) { %> <!-- 로그인 상태 확인 -->
        <form action="LoginProcess.jsp" method="post" name="loginFrm" onsubmit="return validateForm(this);">
            <label for="user_id">아이디:</label>
            <input type="text" id="user_id" name="user_id" /><br />
            <label for="user_pw">패스워드:</label>
            <input type="password" id="user_pw" name="user_pw" /><br />
            <input type="submit" value="로그인하기" class="btn" />
            <a href="Register.jsp" class="btn secondary">회원가입</a>
        </form>
        <% } else { %> <!-- 로그인된 상태 -->
            <p><%= session.getAttribute("UserName") %> 회원님, 로그인하셨습니다.</p>
            <a href="Logout.jsp">[로그아웃]</a>
        <% } %>
    </div>
</body>
</html>
