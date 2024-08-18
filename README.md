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

### 문제 1: 데이터베이스 동시 접근으로 인한 무결성 문제

문제 상황:

- 게시물 조회수 증가 기능에서 동시 접근 시 `visitcount` 필드 업데이트 오류 발생
- 조회수 중복 또는 부정확한 결과 초래

해결 방식:

- 데이터베이스 트랜잭션과 `synchronized` 블록 활용
- 원자성 보장 및 동시 요청 시 정확한 데이터 처리 구현

코드 예시:

```java
public synchronized void updateVisitCount(String num) {
    try {
        String sql = "UPDATE board SET visitcount = visitcount + 1 WHERE num = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, num);
        pstmt.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
```

### 문제 2: 페이지 처리 로직의 성능 저하

문제 상황:

- 전체 게시물 수 계산 기반 페이지 나누기로 인한 성능 저하
- 게시물 증가에 따른 페이지 계산 속도 감소

해결 방식:

- 게시물 수 사전 계산 및 캐싱 전략 도입
- `LIMIT` 및 `OFFSET` 쿼리 사용으로 데이터베이스 부하 감소
- 페이지 계산 로직 개선으로 페이지네이션 성능 향상

코드 예시:

```java
public List<BoardDTO> selectListPage(Map<String, Object> param) {
    List<BoardDTO> boardLists = new ArrayList<>();
    try {
        String sql = "SELECT * FROM board WHERE title LIKE ? ORDER BY num DESC LIMIT ?, ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + param.get("searchWord") + "%");
        pstmt.setInt(2, (Integer) param.get("start") - 1);
        pstmt.setInt(3, (Integer) param.get("end") - (Integer) param.get("start") + 1);
        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            BoardDTO dto = new BoardDTO();
            dto.setNum(rs.getString("num"));
            dto.setTitle(rs.getString("title"));
            // 기타 필드 설정
            boardLists.add(dto);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return boardLists;
}
```

### 문제 3: 보안 취약점 - SQL 인젝션

문제 상황:

- 사용자 입력의 직접 SQL 쿼리 삽입으로 인한 SQL 인젝션 취약점 발생
- 데이터베이스 보안 위협

해결 방식:

- PreparedStatement 사용으로 사용자 입력 안전 처리
- 쿼리 파라미터를 통한 입력값 바인딩
- SQL 인젝션 공격 방지

코드 예시:

```java
public BoardDTO selectView(String num) {
    BoardDTO dto = new BoardDTO();
    try {
        String sql = "SELECT * FROM board WHERE num = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, num);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            dto.setNum(rs.getString("num"));
            dto.setTitle(rs.getString("title"));
            // 기타 필드 설정
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return dto;
}
```

---

## 🚀 프로젝트 성과 및 학습 내용

- **JSP와 서블릿을 활용한 동적 웹 페이지 개발**
- **JDBC를 통한 데이터베이스 연동 및 SQL 쿼리 작성**
- **세션 관리 및 사용자 인증 처리**
- **게시물 목록 페이징 처리 및 검색 기능 구현**
- **사용자 입력 검증 및 에러 처리 기술 습득**

