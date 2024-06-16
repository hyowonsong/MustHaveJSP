package model1.board;

import static org.junit.Assert.*;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.*;
import java.util.*;
import javax.servlet.ServletContext;
import org.mockito.Mockito;
import model1.board.BoardDAO;
import model1.board.BoardDTO;

public class BoardDAOTest {
    private BoardDAO boardDAO;
    private ServletContext mockContext;

    @Before
    public void setUp() {
        // Mock ServletContext
        mockContext = Mockito.mock(ServletContext.class);
        Mockito.when(mockContext.getInitParameter("JDBCDriver")).thenReturn("com.mysql.cj.jdbc.Driver");
        Mockito.when(mockContext.getInitParameter("ConnectionURL")).thenReturn("jdbc:mysql://localhost:3306/yourdatabase");
        Mockito.when(mockContext.getInitParameter("DBUser")).thenReturn("yourusername");
        Mockito.when(mockContext.getInitParameter("DBPass")).thenReturn("yourpassword");

        boardDAO = new BoardDAO(mockContext);
    }

    @After
    public void tearDown() {
        boardDAO.close();
    }

    @Test
    public void testSelectCount() {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("searchField", "title");
        paramMap.put("searchWord", "test");
        int count = boardDAO.selectCount(paramMap);
        System.out.println("Total Count: " + count);
        assertTrue(count >= 0);  // Ensure we get a non-negative count
    }

    @Test
    public void testSelectList() {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("searchField", "title");
        paramMap.put("searchWord", "test");
        List<BoardDTO> list = boardDAO.selectList(paramMap);
        assertNotNull(list);  // Ensure the list is not null
        for (BoardDTO dto : list) {
            System.out.println(dto.getTitle());
        }
    }

    @Test
    public void testInsertWrite() {
        BoardDTO dto = new BoardDTO();
        dto.setTitle("JUnit Test Title");
        dto.setContent("JUnit Test Content");
        dto.setId("testuser");
        int result = boardDAO.insertWrite(dto);
        assertEquals(1, result);  // Ensure one row is inserted
    }

    @Test
    public void testSelectView() {
        String num = "1";  // Adjust based on your database
        BoardDTO dto = boardDAO.selectView(num);
        assertNotNull(dto);  // Ensure we get a non-null result
        System.out.println("Title: " + dto.getTitle());
    }

    @Test
    public void testUpdateVisitCount() {
        String num = "1";  // Adjust based on your database
        boardDAO.updateVisitCount(num);
        // Verify the visit count is increased (could be done by re-querying and checking the count)
    }

    @Test
    public void testUpdateEdit() {
        BoardDTO dto = new BoardDTO();
        dto.setNum("1");  // Adjust based on your database
        dto.setTitle("Updated Title");
        dto.setContent("Updated Content");
        int result = boardDAO.updateEdit(dto);
        assertEquals(1, result);  // Ensure one row is updated
    }

    @Test
    public void testDeletePost() {
        BoardDTO dto = new BoardDTO();
        dto.setNum("1");  // Adjust based on your database
        int result = boardDAO.deletePost(dto);
        assertEquals(1, result);  // Ensure one row is deleted
    }
}
