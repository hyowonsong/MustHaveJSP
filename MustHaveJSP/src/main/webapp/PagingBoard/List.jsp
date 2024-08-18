<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.BoardDTO"%>
<%@ page import="utils.BoardPage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
BoardDAO dao = new BoardDAO(application);
Map<String, Object> param = new HashMap<String, Object>();
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
if (searchWord != null) {
    param.put("searchField", searchField);
    param.put("searchWord", searchWord);
}

int totalCount = dao.selectCount(param);  // 게시물 수 확인

/*** 페이지 처리 start ***/
int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));
int totalPage = (int)Math.ceil((double)totalCount / pageSize); // 전체 페이지 수

int pageNum = 1;  // 기본값
String pageTemp = request.getParameter("pageNum");
if (pageTemp != null && !pageTemp.equals(""))
    pageNum = Integer.parseInt(pageTemp); // 요청받은 페이지로 수정

int start = (pageNum - 1) * pageSize + 1;  // 첫 게시물 번호
int end = pageNum * pageSize; // 마지막 게시물 번호
param.put("start", start);
param.put("end", end);
/*** 페이지 처리 end ***/

List<BoardDTO> boardLists = dao.selectListPage(param);  // 게시물 목록 받기
dao.close();  // DB 연결 닫기
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원제 게시판 - 목록 보기</title>
<link rel="stylesheet" href="../css/styles.css">
</head>
<body>
    <jsp:include page="../Common/Link.jsp" />
    <h2>목록 보기(List) - 현재 페이지 : <%= pageNum %> (전체 : <%= totalPage %>)</h2>
    <!-- 검색폼 -->
    <form method="get">
    <table class="form-table">
    <tr>
        <td>
            <select name="searchField" class="input-select">
                <option value="title">제목</option>
                <option value="content">내용</option>
            </select>
            <input type="text" name="searchWord" class="input-text" />
            <input type="submit" value="검색하기" class="btn" />
        </td>
    </tr>
    </table>
    </form>
    <!-- 게시물 목록 테이블 -->
    <table class="data-table">
        <tr>
            <th width="10%">번호</th>
            <th width="50%">제목</th>
            <th width="15%">작성자</th>
            <th width="10%">조회수</th>
            <th width="15%">작성일</th>
        </tr>
<%
if (boardLists.isEmpty()) {
%>
        <tr>
            <td colspan="5" align="center">등록된 게시물이 없습니다^^*</td>
        </tr>
<%
} else {
    int virtualNum = 0;  // 화면상에서의 게시물 번호
    int countNum = 0;
    for (BoardDTO dto : boardLists) {
        virtualNum = totalCount - (((pageNum - 1) * pageSize) + countNum++);
%>
        <tr align="center">
            <td><%= virtualNum %></td>
            <td align="left"><a href="View.jsp?num=<%= dto.getNum() %>"><%= dto.getTitle() %></a></td>
            <td><%= dto.getId() %></td>
            <td><%= dto.getVisitcount() %></td>
            <td><%= dto.getPostdate() %></td>
        </tr>
<%
    }
}
%>
    </table>
    <!-- 목록 하단의 [글쓰기] 버튼 -->
    <table class="form-table">
        <tr align="center">
            <td>
                <%= BoardPage.pagingStr(totalCount, pageSize, blockPage, pageNum, request.getRequestURI()) %>
            </td>
            <td><button type="button" class="btn" onclick="location.href='Write.jsp';">글쓰기</button></td>
        </tr>
    </table>
</body>
</html>
