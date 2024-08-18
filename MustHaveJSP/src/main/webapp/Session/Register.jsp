<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" href="../css/styles.css">
    <script>
        function validateForm() {
            var id = document.getElementById("id").value;
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            var name = document.getElementById("name").value;

            if (id.trim() === '') {
                alert("아이디를 입력해 주세요.");
                return false;
            }
            if (name.trim() === '') {
                alert("이름을 입력해 주세요.");
                return false;
            }
            if (password !== confirmPassword) {
                alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <jsp:include page="../Common/Link.jsp" />
        <h2>회원가입</h2>
        <form action="RegisterProcess.jsp" method="post" onsubmit="return validateForm()">
            <label for="id">아이디:</label>
            <input type="text" id="id" name="id" required><br><br>

            <label for="password">비밀번호:</label>
            <input type="password" id="password" name="password" required><br><br>

            <label for="confirmPassword">비밀번호 확인:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required><br><br>

            <label for="name">이름:</label>
            <input type="text" id="name" name="name" required><br><br>

            <input type="submit" value="가입" class="btn">
        </form>

        <% if ("noid".equals(request.getParameter("error"))) { %>
            <p class="error-message">아이디를 입력해 주세요.</p>
        <% } %>

        <p><a href="LoginForm.jsp">로그인 페이지로 돌아가기</a></p>
    </div>
</body>
</html>
