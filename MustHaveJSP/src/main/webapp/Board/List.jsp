<%@ page import="java.util.*"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 게시물 목록 로드 및 검색 기능 구현 --%>
<%
BoardDAO dao = new BoardDAO(application);
Map<String, Object> param = new HashMap<>();
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");

if (searchWord != null) {
    param.put("searchField", searchField);
    param.put("searchWord", searchWord);
}

int totalCount = dao.selectCount(param);
List<BoardDTO> boardLists = dao.selectList(param);
dao.close();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
    <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
    <div class="container">
        <jsp:include page="../Common/Link.jsp" />
        <h2>게시판 목록</h2>
        <form method="get" class="search-form">
            <select name="searchField">
                <option value="title">제목</option>
                <option value="content">내용</option>
            </select>
            <input type="text" name="searchWord" />
            <input type="submit" value="검색하기" class="btn" />
        </form>
        <table>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>조회수</th>
                <th>작성일</th>
            </tr>
            <% if (boardLists.isEmpty()) { %>
                <tr>
                    <td colspan="5" align="center">등록된 게시물이 없습니다.</td>
                </tr>
            <% } else {
                int virtualNum = totalCount;
                for (BoardDTO dto : boardLists) {
                    virtualNum--; %>
                    <tr align="center">
                        <td><%= virtualNum %></td>
                        <td align="left"><a href="View.jsp?num=<%= dto.getNum() %>"><%= dto.getTitle() %></a></td>
                        <td><%= dto.getId() %></td>
                        <td><%= dto.getVisitcount() %></td>
                        <td><%= dto.getPostdate() %></td>
                    </tr>
                <% } %>
            <% } %>
        </table>
        <div class="write-btn">
            <button type="button" onclick="location.href='Write.jsp';" class="btn">글쓰기</button>
        </div>
    </div>
</body>
</html>
