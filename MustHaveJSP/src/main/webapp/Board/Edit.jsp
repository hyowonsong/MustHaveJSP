<%@ page import="board.BoardDAO"%>
<%@ page import="board.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./IsLoggedIn.jsp"%>

<%-- 게시물 수정 권한 확인 및 데이터 로드 --%>
<%
String num = request.getParameter("num");
BoardDAO dao = new BoardDAO(application);
BoardDTO dto = dao.selectView(num);
String sessionId = session.getAttribute("UserId").toString();

if (!sessionId.equals(dto.getId())) {
    JSFunction.alertBack("작성자 본인만 수정할 수 있습니다.", out);
    return;
}
dao.close();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원제 게시판 - 수정하기</title>
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
        <h2>회원제 게시판 - 수정하기(Edit)</h2>
        <form name="writeFrm" method="post" action="EditProcess.jsp" onsubmit="return validateForm(this);">
            <input type="hidden" name="num" value="<%= dto.getNum() %>" /> 
            <table>
                <tr>
                    <td>제목</td>
                    <td>
                        <input type="text" name="title" value="<%= dto.getTitle() %>"/> 
                    </td>
                </tr>
                <tr>
                    <td>내용</td>
                    <td>
                        <textarea name="content" rows="10"><%= dto.getContent() %></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="작성 완료" class="btn" />
                        <button type="button" onclick="location.href='List.jsp';" class="btn">목록 보기</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
