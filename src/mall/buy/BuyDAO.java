package mall.buy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BuyDAO {
	
	private BuyDAO(){}
	
	private static BuyDAO instance = new BuyDAO();
	
	public static BuyDAO getInstance() {
		return instance;
	}
	
	// DB 연결 변수
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// 구매목록 추가
	
	// 구마수정 -> 수량수정
	
	// 구매목록 삭제
	
	// 구매목록 보기
}
