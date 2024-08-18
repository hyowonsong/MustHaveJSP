<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./IsLoggedIn.jsp"%> <!-- 로그인 확인 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원제 게시판 - 글쓰기</title>
<link rel="stylesheet" href="../css/styles.css">
<script type="text/javascript">
function validateForm(form) {  // 폼 내용 검증
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
    return true;
}
</script>
</head>
<body>
<jsp:include page="../Common/Link.jsp" />
<h2>회원제 게시판 - 글쓰기(Write)</h2>
<form name="writeFrm" method="post" action="WriteProcess.jsp" onsubmit="return validateForm(this);">
    <table class="form-table">
        <tr>
            <td>제목</td>
            <td><input type="text" name="title" class="input-text" /></td>
        </tr>
        <tr>
            <td>내용</td>
            <td><textarea name="content" class="textarea"></textarea></td>
        </tr>
        <tr>
            <td colspan="2" class="form-actions">
                <button type="submit" class="btn">작성 완료</button>
                <button type="reset" class="btn">다시 입력</button>
                <button type="button" class="btn" onclick="location.href='List.jsp';">목록 보기</button>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
