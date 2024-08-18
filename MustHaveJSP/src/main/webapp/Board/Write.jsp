<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./IsLoggedIn.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 글쓰기</title>
    <link rel="stylesheet" href="../css/styles.css">
    <script type="text/javascript">
        function validateForm(form) {
            if (form.title.value == "") {
                alert("제목을 입력하세요.");
                form.title.focus();
                return false;
            }
            if (form.content.value == "") {
                alert("내용을 입력하세요.");
                form.content.focus();
                return false;
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <jsp:include page="../Common/Link.jsp" />
        <h2>게시판 - 글쓰기</h2>
        <form name="writeFrm" method="post" action="WriteProcess.jsp" onsubmit="return validateForm(this);" class="write-form">
            <table>
                <tr>
                    <td>제목</td>
                    <td>
                        <input type="text" name="title" />
                    </td>
                </tr>
                <tr>
                    <td>내용</td>
                    <td>
                        <textarea name="content" rows="10"></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="작성하기" class="btn" />
                        <button type="button" onclick="location.href='List.jsp';" class="btn">목록으로</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
