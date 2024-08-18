<%@ page import="board.BoardDAO"%>
<%@ page import="board.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./IsLoggedIn.jsp"%> 
<%
String num = request.getParameter("num");  // 일련번호 받기 
BoardDAO dao = new BoardDAO(application);  // DAO 생성
BoardDTO dto = dao.selectView(num);        // 게시물 가져오기 
String sessionId = session.getAttribute("UserId").toString(); // 로그인 ID 얻기 
if (!sessionId.equals(dto.getId())) {      // 본인인지 확인
    JSFunction.alertBack("작성자 본인만 수정할 수 있습니다.", out);
    return;
}
dao.close();  // DB 연결 해제
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원제 게시판 - 수정하기</title>
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
<h2>회원제 게시판 - 수정하기(Edit)</h2>
<form name="writeFrm" method="post" action="EditProcess.jsp" onsubmit="return validateForm(this);">
    <input type="hidden" name="num" value="<%= dto.getNum() %>" />
    <table class="form-table">
        <tr>
            <td>제목</td>
            <td><input type="text" name="title" class="input-text" value="<%= dto.getTitle() %>" /></td>
        </tr>
        <tr>
            <td>내용</td>
            <td><textarea name="content" class="textarea"><%= dto.getContent() %></textarea></td>
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
