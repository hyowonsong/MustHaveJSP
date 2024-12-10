# jsp 기반 회원제 게시판

## 🗓️ 프로젝트 개요

- **기간**: 2024.06.16 ~ 2024.06.25
- **주요 기능**:
    - 회원 관리 시스템 (회원가입, 로그인, 로그아웃, 세션관리)
    - 게시판 기능 (글 작성, 조회, 수정, 삭제, 페이징 처리)
- **기술 스택**:
    - 프론트엔드: `HTML`, `CSS`, `JavaScript`
    - 백엔드: `Java`, `JSP`, `Servlet`
    - 데이터베이스: `Oracle`
    - 서버: `Apache Tomcat`
    - 개발 도구: `Eclipse IDE`

---

## 🚩 프로젝트 배경

- 웹 개발 기초 기술 습득 및 실전 적용을 위한 개인 프로젝트
- JSP와 Servlet을 활용한 동적 웹 페이지 구현 능력 향상
- 데이터베이스 연동 및 CRUD 작업 실습
- 세션 관리를 통한 사용자 인증 시스템 구현 경험 획득

---

## 🗓️ DB 테이블

### 회원 테이블 생성
`member` 테이블을 생성합니다.

```sql
CREATE TABLE member (
    id VARCHAR2(10) NOT NULL,
    pass VARCHAR2(10) NOT NULL,
    name VARCHAR2(30) NOT NULL,
    regidate DATE DEFAULT SYSDATE NOT NULL,
    PRIMARY KEY (id)
);
```

### 게시판 테이블 생성
`board` 테이블을 생성합니다.

```sql
CREATE TABLE board (
    num NUMBER PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    content VARCHAR2(2000) NOT NULL,
    id VARCHAR2(10) NOT NULL,
    postdate DATE DEFAULT SYSDATE NOT NULL,
    visitcount NUMBER(6)
);
```

## 외래 키 설정
`board` 테이블에 외래 키 제약 조건을 추가합니다.

```sql
ALTER TABLE board
    ADD CONSTRAINT board_mem_fk FOREIGN KEY (id)
    REFERENCES member (id);
```

## 시퀀스 생성
`board` 테이블의 `num` 필드를 자동 증가시키기 위한 시퀀스를 생성합니다.

```sql
CREATE SEQUENCE seq_board_num 
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;
```

---

## 🛠️ 개발 과정 및 문제 해결

### 문제 1: 데이터베이스 커넥션 풀 구현

문제 상황:

- 데이터베이스 연결의 비효율적인 생성과 해제로 인한 성능 저하

해결 방법:

- JNDI를 이용한 DataSource 획득 및 커넥션 풀 구현
- 자원의 효율적인 관리를 위한 close() 메서드 구현

핵심 코드:

```java
public class DBConnPool {
    public Connection con;
    public Statement stmt;
    public PreparedStatement psmt;
    public ResultSet rs;

    public DBConnPool() {
        try {
            Context initCtx = new InitialContext();
            Context ctx = (Context)initCtx.lookup("java:comp/env");
            DataSource source = (DataSource)ctx.lookup("dbcp_myoracle");
            con = source.getConnection();
            System.out.println("DB 커넥션 풀 연결 성공");
        }
        catch (Exception e) {
            System.out.println("DB 커넥션 풀 연결 실패");
            e.printStackTrace();
        }
    }

    public void close() {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (psmt != null) psmt.close();
            if (con != null) con.close();
            System.out.println("DB 커넥션 풀 자원 반납");
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}

```

### 문제 2: 페이징 처리를 통한 대량 데이터 효율적 관리

문제 상황:

- 대량의 게시물 데이터를 한 번에 로드할 때 발생하는 성능 이슈
- 사용자 경험 저하 및 서버 부하 증가

해결 방법:

- SQL 쿼리에 ROWNUM을 활용한 페이징 처리 구현
- 페이지 번호에 따른 동적 쿼리 생성

핵심 코드:

```java
public List<BoardDTO> selectListPage(Map<String, Object> map) {
    List<BoardDTO> bbs = new Vector<BoardDTO>();

    String query = " SELECT * FROM ( "
                 + "    SELECT Tb.*, ROWNUM rNum FROM ( "
                 + "        SELECT * FROM board ";

    if (map.get("searchWord") != null) {
        query += " WHERE " + map.get("searchField")
               + " LIKE '%" + map.get("searchWord") + "%' ";
    }

    query += "      ORDER BY num DESC "
           + "     ) Tb "
           + " ) "
           + " WHERE rNum BETWEEN ? AND ?";

    try {
        psmt = con.prepareStatement(query);
        psmt.setString(1, map.get("start").toString());
        psmt.setString(2, map.get("end").toString());
        rs = psmt.executeQuery();

        while (rs.next()) {
            BoardDTO dto = new BoardDTO();
            // dto 객체에 데이터 설정
            bbs.add(dto);
        }
    }
    catch (Exception e) {
        System.out.println("게시물 조회 중 예외 발생");
        e.printStackTrace();
    }

    return bbs;
}
```

### 문제 3: 보안을 고려한 사용자 인증 및 세션 관리

문제 상황:

- 안전하지 않은 사용자 인증 방식
- XSS 공격 위험

해결 방법:

- 비밀번호 해싱 적용
- 세션 기반의 로그인 상태 관리 및 보안 강화

핵심 코드:

```java
// LoginProcess.jsp
if (memberDTO.getId() != null) {
    // 로그인 성공
    session.setAttribute("UserId", memberDTO.getId());
    session.setAttribute("UserName", memberDTO.getName());
    response.sendRedirect("LoginForm.jsp");
} else {
    // 로그인 실패
    request.setAttribute("LoginErrMsg", "로그인 오류입니다.");
    request.getRequestDispatcher("LoginForm.jsp").forward(request, response);
}

// Logout.jsp
session.invalidate();
response.sendRedirect("LoginForm.jsp");

// 입력 데이터 검증 (XSS 방지)
String safeInput = StringEscapeUtils.escapeHtml4(userInput);

```

---

---

## 🚀 프로젝트 성과 및 학습 내용

- **JSP와 서블릿을 활용한 동적 웹 페이지 개발**
- **JDBC를 통한 데이터베이스 연동 및 SQL 쿼리 작성**
- **세션 관리 및 사용자 인증 처리**
- **게시물 목록 페이징 처리 및 검색 기능 구현**
- **사용자 입력 검증 및 에러 처리 기술 습득**

