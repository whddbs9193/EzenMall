package mall.bank;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import util.JDBCUtil;

public class BankDAO {
	
	private BankDAO() {}
	
	private static BankDAO instance = new BankDAO();
	
	public static BankDAO getInstance() {
		return instance;
	}
	
	// DB 연결 변수
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// 카드 추가
	
	// 카드 수정
	
	// 카드 삭제
	
	// 카드 전체 보기
	public List<BankDTO> getBankList(String member_id){
		String sql="select * from bank where member_id = ?";
		List<BankDTO> bankList = new ArrayList<BankDTO>();
		BankDTO bank = null;
		
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				bank = new BankDTO();
				bank.setCard_no(rs.getString("card_no"));
				bank.setCard_com(rs.getString("card_com"));
				bank.setMember_id(rs.getString("member_id"));
				bank.setMember_name(rs.getString("member_name"));
				bankList.add(bank);
			}
		}catch (Exception e) {
			System.out.println("=> getBankList() 에러");
			e.printStackTrace();
		}finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return bankList;
	}
}
