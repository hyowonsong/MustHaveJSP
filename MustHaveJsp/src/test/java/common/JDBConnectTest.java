package common;

import org.springframework.mock.web.MockServletContext;

import javax.servlet.ServletContext;

public class JDBConnectTest {
    public static void main(String[] args) {
        // 기본 생성자 테스트
        testDefaultConstructor();

        // 인수 생성자 1 테스트
        testParameterizedConstructor1();

        // 인수 생성자 2 테스트
        testParameterizedConstructor2();
    }

    // 기본 생성자 테스트
    public static void testDefaultConstructor() {
        System.out.println("=== 기본 생성자 테스트 ===");
        JDBConnect db = new JDBConnect();
        db.close();
    }

    // 인수 생성자 1 테스트
    public static void testParameterizedConstructor1() {
        System.out.println("=== 인수 생성자 1 테스트 ===");
        String driver = "oracle.jdbc.OracleDriver";
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String id = "musthave";
        String pwd = "1234";
        JDBConnect db = new JDBConnect(driver, url, id, pwd);
        db.close();
    }

    // 인수 생성자 2 테스트
    public static void testParameterizedConstructor2() {
        System.out.println("=== 인수 생성자 2 테스트 ===");
        MockServletContext application = new MockServletContext();
        application.addInitParameter("OracleDriver", "oracle.jdbc.OracleDriver");
        application.addInitParameter("OracleURL", "jdbc:oracle:thin:@localhost:1521:xe");
        application.addInitParameter("OracleId", "musthave");
        application.addInitParameter("OraclePwd", "1234");

        JDBConnect db = new JDBConnect(application);
        db.close();
    }
}
