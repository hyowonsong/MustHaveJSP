# MustHaveJSP

이 스크립트는 새로운 유저 생성, 테이블 생성, 시퀀스 생성 및 더미 데이터를 삽입하는 작업을 포함한 Oracle 데이터베이스 설정을 위한 스크립트입니다. 아래의 단계를 따라 스크립트를 실행하세요.

## 1. 새로운 유저 생성
`musthave`라는 이름의 유저를 `1234`라는 비밀번호로 생성합니다.

```sql
CREATE USER musthave IDENTIFIED BY 1234;
```

## 2. 권한 부여
새로 생성한 유저에게 필요한 권한을 부여합니다.

```sql
GRANT connect, resource TO musthave;
```

## 3. 새 유저로 접속
새로 생성한 유저로 Oracle 데이터베이스에 접속합니다.

```sql
CONN musthave/1234;
```

## 4. 테이블 목록 조회
기존에 존재하는 테이블 목록을 확인합니다.

```sql
SELECT * FROM tab;
```

## 5. 기존 테이블 삭제 (선택 사항)
기존에 존재하는 테이블 및 시퀀스를 삭제하려면 아래 명령어를 사용하세요.

```sql
DROP TABLE member;
DROP TABLE board;
DROP SEQUENCE seq_board_num;
```

## 6. 테이블 생성

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

## 7. 외래 키 설정
`board` 테이블에 외래 키 제약 조건을 추가합니다.

```sql
ALTER TABLE board
    ADD CONSTRAINT board_mem_fk FOREIGN KEY (id)
    REFERENCES member (id);
```

## 8. 시퀀스 생성
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

## 9. 더미 데이터 입력

### 회원 테이블에 데이터 입력
`member` 테이블에 더미 데이터를 입력합니다.

```sql
INSERT INTO member (id, pass, name) VALUES ('musthave', '1234', '머스트해브');
```

### 게시판 테이블에 데이터 입력
`board` 테이블에 더미 데이터를 입력합니다.

```sql
INSERT INTO board (num, title, content, id, postdate, visitcount) 
    VALUES (seq_board_num.NEXTVAL, '제목1입니다', '내용1입니다', 'musthave', SYSDATE, 0);
```

## 10. 트랜잭션 커밋
변경 사항을 커밋합니다.

```sql
COMMIT;
```
