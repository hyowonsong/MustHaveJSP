<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 실패</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }
        .container {
            margin-top: 50px;
        }
        .error-message {
            color: red;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .btn-link {
            text-decoration: none;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border-radius: 5px;
        }
        .btn-link:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>회원가입에 실패했습니다.</h2>

        <% String error = request.getParameter("error");
           String message = "";
           if ("noid".equals(error)) {
               message = "아이디를 입력해 주세요.";
           } else if ("idexists".equals(error)) {
               message = "이미 사용 중인 아이디입니다.";
           } else {
               message = "입력한 정보를 다시 확인하고, 다시 시도해 주세요.";
           }
        %>

        <p class="error-message"><%= message %></p>

        <a href="Register.jsp" class="btn-link">회원가입 페이지로 돌아가기</a>
    </div>
</body>
</html>
