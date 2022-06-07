package mall.cart;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import util.JDBCUtil;

public class CartDAO {
	private CartDAO() {}
	
	private static CartDAO cartDAO = new CartDAO();
	
	public static CartDAO getInstance() {
		return cartDAO;
	}
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// 장바구니 등록
	public int insertCart(CartDTO cart) {
		String sql = "insert into cart(buyer, product_id, product_name, author, publishing_com, product_price, discount_rate,"
				+ " buy_price, buy_count, product_image) values(?,?,?,?,?,?,?,?,?,?)";
		int check = 0;
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, cart.getBuyer());
			pstmt.setInt(2, cart.getProduct_id());
			pstmt.setString(3, cart.getProduct_name());
			pstmt.setString(4, cart.getAuthor());
			pstmt.setString(5, cart.getPublishing_com());
			pstmt.setInt(6, cart.getProduct_price());
			pstmt.setInt(7, cart.getDiscount_rate());
			pstmt.setInt(8, cart.getBuy_price());
			pstmt.setInt(9, cart.getBuy_count());
			pstmt.setString(10, cart.getProduct_image());
			check = pstmt.executeUpdate();
		}catch (Exception e) {
			System.out.println("=> insertCart() 메소드 실행 에러");
			e.printStackTrace();
		}finally {
			JDBCUtil.close(conn, pstmt);
		}
		return check;
	}
	
	// 장바구니 목록 확인
	public List<CartDTO> getCartList(String buyer){
		String sql ="select * from cart where buyer = ?";
		List<CartDTO> cartList = new ArrayList<CartDTO>();
		try {
			conn = JDBCUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, buyer);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				CartDTO cart = new CartDTO();
				cart.setCart_id(rs.getInt("cart_id"));
				cart.setBuyer(rs.getString("buyer"));
				cart.setProduct_id(rs.getInt("product_id"));
				cart.setProduct_price(rs.getInt("product_price"));
				cart.setProduct_name(rs.getString("product_name"));
				cart.setAuthor(rs.getString("author"));
				cart.setPublishing_com(rs.getString("publishing_com"));
				cart.setDiscount_rate(rs.getInt("discount_rate"));
				cart.setDiscount_rate(rs.getInt("discount_rate"));
				cart.setBuy_price(rs.getInt("buy_price"));
				cart.setBuy_count(rs.getInt("buy_count"));
				cart.setProduct_image(rs.getString("product_image"));
				cartList.add(cart);
			}
		}catch(Exception e){
			System.out.println("=> getCartList() 메소드 실행 에러");
			e.printStackTrace();
		}finally {
			JDBCUtil.close(conn, pstmt, rs);
		}
		return cartList;
	}
	
	// 장바구니 주문 수량 수정 (각 상품별로)
	
	
	// 장바구니 삭제 (각 상품별로)
	
	// 장바구니 삭제 (선택한 상품 또는 전체 상품 
	
	// 장바구니 상품 종류 개수
	
	
	
	// 장바구니 주문 (각 상품별로)
	
	// 장바구니 주문(선택한 상품 또는 전체 상품)
	
}
