<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="mall.member.*, mall.cart.*, mall.bank.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 확인폼</title>
<style>
/* 상단 d1 */
.container{width: 1200px; margin: 0 auto;}
.d1{width: 43%; padding:15px; margin: 15px 45px; float:right; display: inline-block;}
.d1 .s1{font-size: 1.1em; font-weight: bold; margin-right: 30px;}
.d1 .s2, .d1 .s3{display:inline-block; width:150px; text-align:center; padding: 6px 17px; border:1px solid gray; font-weight: bold; font-size: 0.8em; border-radius: 15px;}
.d1 .s2{background: #333; color:#fff; z-index: 1; position: relative;}
.d1 .s3{background: #fff; color:#333; margin-left: -30px; z-index:-1; position: relative;}
/* 상단 d2 */
.d2{width: 34%; padding:15px; margin: 5px 45px; float: left; display: inline-block; text-align: left;}
.d_line{clear:both; width:90%; border: 1px solid lightgray;}

/* 중단 - d3, 구매정보 확인 (장바구니 또는 상품상세) */
.d3 table{width: 90%; border:1px solid gray; border-collapse: collapse; margin: 0 auto; font-size: 0.9em; 
border-left: none; border-right: none; clear: both;}
.d3 .t1 tr{height: 40px;}
.d3 .t1 td, .d3 .t1 th{border-top: 1px solid #f1f3f5; border-bottom: 1px solid #f1f3f5; border-left: none; border-right: none;}
.d3 .t1 th{background: #f1f3f5;}
.d3 .t1 td{text-align: center;}
.d3 .t1 tr:last-child th{font-weight: normal;}
.d3 .t1 input[type=number]{width: 60px;}
.left{text-align: left; padding-left: 10px;}
.right{text-align: right; padding-right: 10px;}
.center{text-align: center;}
</style>
<script>

</script>
</head>
<body>
<%
// buyForm.jsp -> 구매정보 확인폼(구매 여부를 결정하는 폼), buyList.jsp -> 구매 목록 폼(최종 구매 확인)
request.setCharacterEncoding("utf-8");

String memberId = (String)session.getAttribute("memberId");
if(memberId == null){
	out.print("<script>alert('로그인을 해주세요');");
	out.print("location='../logon/memberLoginForm.jsp';</script>");
	return;
}

// cartList.jsp에서 넘어오는 cart_id를 확인, 배열로 저장 -> 리스트로 저장
String cart_id_str = request.getParameter("cart_id");
String[] cart_id_arr = cart_id_str.split(",");
List<Integer> cart_id_list = new ArrayList<Integer>();
for(String c : cart_id_arr){
	cart_id_list.add(Integer.parseInt(c));
}

// 카트 확인
/* System.out.println("카트 배열: " + Arrays.toString(cart_id_arr));
System.out.println("카트 리스트: " + cart_id_list); */

// Cart DB 연동 -> cartList에서 넘어오는 정보
CartDAO  cartDAO = CartDAO.getInstance();
List<CartDTO> cartList = cartDAO.getCartList(cart_id_list);

// cartList 확인
/*
for(CartDTO c : cartList){
	System.out.println(c);
}
*/

//Bank DB 연동
BankDAO bankDAO = BankDAO.getInstance();
List<BankDTO> bankList = bankDAO.getBankList(memberId);

// Member DB 연동
MemberDAO memberDAO = MemberDAO.getInstance();
MemberDTO member = memberDAO.getMember(memberId);

String address = member.getAddress();
String local = address.substring(0,2); // 주소에서 2글자만 추출

int n = 0; // 추가되는 날짜
Calendar c = Calendar.getInstance();
int w = c.get(Calendar.DAY_OF_WEEK); // 요일1~7, 1:일, 2:월, 3:화, 4:수, 5:목, 6:금, 7:토

switch(local){
case "서울": 
	if(w >= 2 && w<=5) ++n;
	else if(w == 6 || w == 7) n += 3;
	else if(w == 7) n += 2;
	break;
case "경기":
	if(w >= 2 && w<= 4) n += 2;
	else if(w >=5 && w <= 7) n += 4;
	else if(w == 1) n += 3;
	break;
case "제주":
	n += 7;
	break;
default: // 지방
	if(w == 2 || w == 3) n += 3;
	else if(w >= 4 && w <= 7) n += 5;
	else if(w == 1) n += 4;
	break;
}

// 추가된 일수를 더한 날짜
c.add(Calendar.DATE, n);
int month = c.get(Calendar.MONTH) + 1;  // 0~11로 표현, 1을 더해서 보정
int date = c.get(Calendar.DATE);
int week = c.get(Calendar.DAY_OF_WEEK); // 1~7표현
String[] weekday = {"index0","일","월","화","수","목","금","토"};

// 배송일 확인
String d_day = month + "월" + date + "일(" + weekday[week] +")요일 ";

%>
<div class="container">
	<jsp:include page="../common/shopTop.jsp"></jsp:include>
	<div class="buyForm">
		<div class="d1">
			<span class="s1">EZENMALL 배송</span>
			<span class="s2">당일/하루/일반 배송</span>
			<span class="s3">아침배송</span>
		</div>
		<div class="d2">
			<img src="../../icons/progress02.png" width="400" height="60">
		</div>
		<hr class="d_line">
		<div class="d3"> <!-- 카트 정보 -->
			<table class="t1">
				<tr>
					<th colspan="2">상품정보</th>
					<th>정가</th>
					<th>판매가</th>
					<th>구매수량</th>
					<th>합계</th>
					<th>배송일</th>
				</tr>
				<%for(CartDTO cart : cartList){%>
					<tr>
						<td width="10%"><img src="/images_ezenmall/<%=cart.getProduct_image() %>" width="60" height="90"></td>
						<td width="40%">
							<span><%=cart.getProduct_name() %></span><br>
							<span><%=cart.getAuthor() %> | <%=cart.getPublishing_com() %></span>
						</td>
						<td width="10%"><span><%=cart.getProduct_price() %></span></td>
						<td width="10%"><span><%=cart.getBuy_price() %></span></td>
						<td width="10%"><span><input type="number" name="buy_count" value="<%=cart.getBuy_count()%>"></span></td>
						<td width="10%"><span><%=cart.getBuy_price() * cart.getBuy_count() %></span></td>
						<td width="10%"><span><%=d_day %></span></td>
					</tr>
				<%} %>
			</table>
		</div>
		<div class="d4"> <!-- 구매 총 정보 -->
		
		</div>
		<div class="d5"> <!-- 배송지 정보  -->
		
		</div>
		<div class="d6"> <!-- 주문자 정보 -->
		
		</div>
		
	</div>
	<jsp:include page="../common/shopBottom.jsp"></jsp:include>
</div>
</body>
</html>