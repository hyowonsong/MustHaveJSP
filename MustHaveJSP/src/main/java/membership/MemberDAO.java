package membership;

import common.JDBConnect;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class MemberDAO extends JDBConnect {

    // 명시한 데이터베이스로의 연결이 완료된 MemberDAO 객체를 생성합니다.
    public MemberDAO(String drv, String url, String id, String pw) {
        super(drv, url, id, pw);
    }

    // 명시한 아이디/패스워드와 일치하는 회원 정보를 반환합니다.
    public MemberDTO getMemberDTO(String uid, String upass) {
        MemberDTO dto = new MemberDTO();  // 회원 정보 DTO 객체 생성
        String query = "SELECT * FROM member WHERE id=? AND pass=?";  // 쿼리문 템플릿

        try {
            // 쿼리 실행
            psmt = con.prepareStatement(query); // 동적 쿼리문 준비
            psmt.setString(1, uid);    // 쿼리문의 첫 번째 인파라미터에 값 설정
            psmt.setString(2, upass);  // 쿼리문의 두 번째 인파라미터에 값 설정
            rs = psmt.executeQuery();  // 쿼리문 실행

            // 결과 처리
            if (rs.next()) {
                // 쿼리 결과로 얻은 회원 정보를 DTO 객체에 저장
                dto.setId(rs.getString("id"));
                dto.setPass(rs.getString("pass"));
                dto.setName(rs.getString("name"));
                dto.setRegidate(rs.getString("regidate"));
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        return dto;  // DTO 객체 반환
    }

    // 새로운 회원을 데이터베이스에 삽입하는 메서드
    public boolean insertMember(MemberDTO dto) {
        boolean result = false;
        String query = "INSERT INTO member (id, pass, name) VALUES (?, ?, ?)";

        try {
            PreparedStatement psmt = con.prepareStatement(query);
            psmt.setString(1, dto.getId());
            psmt.setString(2, dto.getPass());
            psmt.setString(3, dto.getName());

            int rows = psmt.executeUpdate();
            if (rows > 0) {
                result = true; // 삽입 성공
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }
}
