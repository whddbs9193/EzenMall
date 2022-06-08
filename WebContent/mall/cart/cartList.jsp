<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="mall.member.*,mall.cart.*, java.util.*, java.text.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니 목록</title>
<style>
#container{width: 1200px; margin: 0 auto;}
.cart_list{width: 100%}
/* 상단 d1 */
.d1{width: 43%; padding:15px; margin: 15px 45px; float:left; display: inline-block;}
.d1 .s1{font-size: 1.1em; font-weight: bold; margin-right: 30px;}
.d1 .s2, .d1 .s3{display:inline-block; width:150px; text-align:center; padding: 6px 17px; border:1px solid gray; font-weight: bold; font-size: 0.8em; border-radius: 15px;}
.d1 .s2{background: #333; color:#fff; z-index: 1; position: relative;}
.d1 .s3{background: #fff; color:#333; margin-left: -30px; z-index:-1; position: relative;}
/* 상단 d2 */
.d2{width: 34%; padding:15px;margin: 5px 45px; float: right; display: inline-block; text-align: right;}
.d_line{clear:both; width:90%; border: 1px solid lightgray;}
/* 상단 d3 */
.d3 {width: 90%; padding: 15px; margin: 5px 45px; float:left;}
.d3 input[type=checkbox]{ zoom: 1.6; margin-right: 5px; float: left;}
.d3 lable{font-size: 0.9em; margin-right: 20px;}
.d3 input[type=button] {width: 80px; height: 30px; border: none; border-radius: 3px; color:#fff; font-weight: bold; cursor: pointer;}
.d3 #btn_buy_select{ background: #32708d; border: 1px solid #32708d; margin-right: 5px;}
.d3 #btn_delete_select { background: #99424f; border: 1px solid #99424f; }

/* 중단 - 상품 정보 테이블 */
.t_cart_list{width: 90%; border:1px solid gray; border-collapse: collapse; margin: 0 auto; font-size: 0.9em; 
border-left: none; border-right: none; clear: both;}
.t_cart_list tr{height: 40px;}
.t_cart_list td, .t_cart_list th{border-top: 1px solid #f1f3f5; border-bottom: 1px solid #f1f3f5; border-left: none; border-right: none;}
.t_cart_list th{background: #f1f3f5;}
.t_cart_list td{}
.t_cart_list tr:last-child th{font-weight: normal;}
.left{text-align: left; padding-left: 10px;}
.right{text-align: right; padding-right: 10px;}
.center{text-align: center;}
.td0{text-align: center; font-weight: bold; font-size:1.1em; padding: 30px 0;}
.td1 .ck_cart_one{zoom: 1.5;}
.td3 .s1{ font-weight: bold; color: #1e94be;}
.td3 .s2{font-size:0.9em; color: gray;}
.td3 .s3{font-size:0.9em; color: gray; text-decoration: line-through;}
.td3 .s4, .td3 .s5{font-weight: bold; color: #c84557;}
.td4 input[type="number"] {width:45px; margin-bottom: 5px;}
.td5{font-size: 1.1em; color:#c84557; }
/* number 화살표 항상 보이는 효과 */
.td4 input[type=number]::-webkit-inner-spin-button, 
.td4 input[type=number]::-webkit-outer-spin-button {-webkit-appearance: "Always Show Up/Down Arrows"; opacity: 1;}
.td4 input[type="submit"] {width: 53px; height: 25px; border:1px solid gray; background:  #fff; border-radius: 2px; font-size: 0.8em; cursor: pointer;}
.td7 input[type="button"] {width: 80px; height: 30px; border: none; border-radius: 3px; color:#fff; font-weight: bold; cursor: pointer;}
.td7 .btn_buy_one{background: #1e94be; margin-bottom: 5px;}
.td7 .btn_delete_one{background: #c84557; border: 1px solid #c84557;}

/* 하단 d4  */
.d4 {width: 90%; padding: 15px; margin: 0 45px;}
.d4 span{font-size: 0.9em; font-weight: bold; color: gray; margin-right: 10px;}
.d4 input[type=button] {width: 80px; height: 30px; border: none; border-radius: 3px; color:#fff; font-weight: bold; cursor: pointer;}
.d4 #btn_buy_select2{ background: #32708d; border: 1px solid #32708d; margin-right: 5px;}
.d4 #btn_delete_select2{ background: #99424f; border: 1px solid #99424f; }

/* 하단 - 총상품금액 테이블 */
.t_cart_tot{width: 90%; border:1px solid gray; border-collapse: collapse; margin: 0 auto; font-size: 0.9em; 
border: 1px solid #196ab3; clear: both; background: #e6f0fa;}
.t_cart_tot tr{height: 100px;}
.t_cart_tot td, .t_cart_tot th{}
.t_cart_tot tr:first-child th:last-of-type { background: #d4e3f1;}
.t_cart_tot span{font-size: 1.5em; display: inline-block; margin-top: 5px;}
.t_cart_tot tr:first-child th:nth-of-type(5){ color: #196ab3;}
.t_cart_tot tr:first-child th:nth-of-type(7){ color: #a13b66;}

.t_cart_tot tr:nth-child(2) {font-size: 0.6em; }
.t_cart_tot tr:nth-child(2) span{font-weight: nomal;}
.t_cart_tot tr:nth-child(2) span b{color: #a13b66;}
.t_cart_tot tr:nth-child(2) th{border-top: 1px solid #196ab3;}

/* 하단 - 배송지 테이블 */
.t_cart_address{width: 90%; border:1px solid gray; border-collapse: collapse; margin: 0 auto; font-size: 0.9em; clear: both;
margin: 20px auto;}
.t_cart_address tr{height: 80px;}
.t_cart_address td, .t_cart_address th{border: 1px solid #dee2e6;}
.t_cart_address th{background: #f1f3f5;}
.t_cart_address td input{margin-top: 10px;}
.t_cart_address td{padding-left: 10px;}
.t_cart_address th input{ margin-top: 20px;}
.t_cart_address input[type=button]{width: 80px; height: 30px; background: #fff; border:1px solid lightgray; border-radius: 3px;
padding: 5px; font-size:0.9em;}

/* 하단 - 주문 */
.d5{width: 90%; padding: 15px; margin: 0 45px 30px; text-align: center;}
.d5 input[type=button]{width: 150px; height: 50px; font-size: 1.05em; font-weight: bold; color: #fff; cursor:pointer; border-radius: 5px;}
.d5 #btn_buy_select3{background: #3a85c8; border: 1px solid #3a85c8;}
.d5 #btn_shop{background: #2f9e77; border: 1px solid #2f9e77;}
.d_line2{clear:both; width:100%; border: 1px solid lightgray; margin-bottom: 20px;}
</style>
<script>
	document.addEventListener("DOMContentLoaded",function(){
		// 구매 수량 제한 효과(1~100)
		let buy_counts = document.querySelectorAll(".buy_count");
		for(let buy_count of buy_counts){
			buy_count.addEventListener("keyup", function(){
				if(buy_count.value < 1 ){
					buy_count.value = 1;
				}else if(buy_count.value > 100){
					buy_count.value = 100;
				}
			})
		}
		
		// 각 상품별 삭제 버튼 처리(1개 상품)
		let cart_ids = document.getElementsByName("cart_id");
		let btn_delete_ones = document.querySelectorAll(".btn_delete_one");
		for(let i=0; i<btn_delete_ones.length; i++){
			btn_delete_ones[i].addEventListener("click",function(){
				location = 'cartDeletePro.jsp?cart_id=' + cart_ids[i].value;
			})
		}
		
		// 각 상품별 주문 버튼 처리(1개)
		let btn_buy_ones = document.querySelectorAll(".btn_buy_one");
		for(let i = 0; i < btn_buy_ones.length; i++){
			btn_buy_ones[i].addEventListener("click",function(){
				location = '../buy/buyForm.jsp?cart_id=' + cart_ids[i].value;
			})
		}
		
		////////////////////////////////
		// 전체 선택 체크박스
		let ck_count = 0;
		let ck_cart_ones = document.querySelectorAll(".ck_cart_one");
		let ck_cart_all = document.getElementById("ck_cart_all");
		
		ck_cart_all.addEventListener("change",function(){
			if(ck_cart_all.checked == true){ // 전체 선택을 체크하였을 때 -> 하위의 모든 체크박스를 선택
				ck_count = ck_cart_ones.length;
				for(let i = 0; i < ck_cart_ones.length; i++){
					ck_cart_ones[i].checked = true;
				}
			
			}else{ // 전체 선택을 해제해였을 때 -> 하위의 모든 체크박스를 해제
				ck_count = 0;
				for(let i=0; i<ck_cart_ones.length; i++){
					ck_cart_ones[i].checked = false;
				}
			}
		})
		
		// 각 상품별 체크박스 중에서 해제된 것이 있다면 전체 선택 체크박스를 헤제
		// 각 상품별 체크박스가 모두 체크되었다면 전체 선택 체크박스를 선택
		for(let i = 0; i<ck_cart_ones.length; i++){
			ck_cart_ones[i].addEventListener("change",function(){
				if(ck_cart_ones[i].checked == false ){
					ck_cart_all.checked = false;
					--ck_count;
				}else if(ck_cart_ones[i].checked == true ){
					++ck_count;
				}
				
				if(ck_count == ck_cart_ones.length){
					ck_cart_all.checked = true;
				}
			})
		}
	})
</script>
</head>
<body>
<%

String memberId = (String)session.getAttribute("memberId");
if(memberId == null){
	out.print("<script>alert('로그인을 해주세요');");
	out.print("location='../logon/memberLoginForm.jsp';</script>");
}
SimpleDateFormat sdf = new SimpleDateFormat("MM월 dd일");
DecimalFormat df = new DecimalFormat("#,###,###");

// 회원 DB 연결 질의 -> 주소 정보 활용
MemberDAO memberDAO = MemberDAO.getInstance();
MemberDTO member = memberDAO.getMember(memberId);

String address = member.getAddress();



String local = address.substring(0,2); // 주소에서 2글자만 추출

// 배송 날짜 계산과 포맷
// 규칙1. 서울: 다음날 배송, 경기: 2일 안에 배송, 지방: 3일 안에 배송, 제주도 : 5일 안에 배송.
// 규칙2. 토요일, 일요일 제외
// 현재날짜와 시간, 요일 판단, 주소 판단

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
// System.out.println("배송일: " + month + "월" + date + "일(" + weekday[week] + "요일)");

// 장바구니 DB 연결 질의
CartDAO cartDAO = CartDAO.getInstance();
List<CartDTO> cartList = cartDAO.getCartList(memberId);
int cartListCount = cartDAO.getCartListCount(memberId);

// 상품 가격(정가), 할인율, 할인가격(판매가)
int product_price = 0;
int discount_rate = 0;
int buy_price = 0;
int buy_count = 0;
int p_sum = 0; // 각 상품의 합계
int p_tot = 0; // 주문 상품의 총합계

int p_sum2 = 0; // 각 상품의 합계(원가)
int p_tot2 = 0; // 주문 상품의 총합계(원가)

int d_count = 0; // 실제 할인된 금액
int p_sum3 = 0; // 각 상품의 실제 할인된 금액의 합계
int p_tot3 = 0; // 주문 상품의 실제 할인된 금액의 총합계

int k_count = 0; // 주문 상품의 종류
int p_count = 0; // 주문 상품의 총개수
// 장바구니 확인
/*
for(CartDTO cart : cartList){
	System.out.println(cart);
}
*/
%>
<div id="container">
	<jsp:include page="../common/shopTop.jsp" />
	<div class="cart_list">
		<div class="d1">
			<span class="s1">EZENMALL 배송</span>
			<span class="s2">당일/하루/일반 배송</span>
			<span class="s3">아침배송</span>
		</div>
		<div class="d2">
			<img src="../../icons/progress01.PNG" width="300" height="45">
		</div>
		<hr class="d_line">
		
		<div class="d3">
			<input type="checkbox" name="ck_cart_all" id="ck_cart_all"><lable for="ck_cart_all">전체 선택</lable>
			<input type="button" value="주문" id="btn_buy_select">
			<input type="button" value="삭제" id="btn_delete_select">
		</div>
		<table class="t_cart_list">
			<tr>
				<th colspan="3">상품정보</th>
				<th>수량</th>
				<th>상품금액</th>
				<th>배송정보</th>
				<th>주문</th>
			</tr>
			<%if(cartListCount == 0){ %>
			<tr><td colspan="7" class="td0">장바구니에 상품이 없습니다.</td></tr>
			<%} else {%>
			<%for(CartDTO cart : cartList) {
				product_price = cart.getProduct_price();
				discount_rate = cart.getDiscount_rate();
				buy_price = cart.getBuy_price();
				buy_count = cart.getBuy_count();
				p_sum = buy_price * buy_count; // 각 상품의 합계(할인가격 * 주문수량)
				p_tot += p_sum;               // 총합계(할인가격의 총합계)
				
				p_sum2 = product_price * buy_count; // 각 상품의 합계 (원가)
				p_tot2 += p_sum2; // 총합계(원가)
				
				p_sum3 = product_price * discount_rate / 100 * buy_count; //각 상품의 할인된 가격, 10000 * 10 / 100
				p_tot3 += p_sum3;        // 각 상품의 할인된 가격의 총합계
				
				++k_count;  //주문 상품 종류
				p_count += buy_count; // 주문 상품 총개수
			%>
			<form action="cartUpdatePro.jsp" method="post" name="cartForm">
			<input type="hidden" name="cart_id" value="<%= cart.getCart_id()%>">
			<input type="hidden" name="product_id" value="<%=cart.getBuy_count() %>">
			<tr>
				<td class="center td1" width="3%"><input type="checkbox" name="ck_cart_one" class="ck_cart_one"></td>
				<td class="center td2" width="8%"><img src="/images_ezenmall/<%=cart.getProduct_image()%>" width="60" height="90"></td>
				<td class="left td3" width="48%">
					<span class="s1"><%=cart.getProduct_name() %></span><br>
					<span class="s2"><%=cart.getAuthor() %> | <%=cart.getPublishing_com() %></span><br>
					<span class="s3"><%=df.format(product_price) %>원</span> | <span class="s4"><%=df.format(buy_price) %>원</span> (<span class="s5"><%=discount_rate %>%할인</span>)
				</td>
				<td class="center td4" width="8%">
					<input type="number" name="buy_count" value="<%=buy_count%>" class="buy_count" min="1" max="100"><br>
					<input type="submit" name="btn_count" value="변경">
				</td>
				<td class="right td5" width="9%"><%=df.format(p_sum) %>원</td>
				<td class="center td6" width="12%"><%=d_day %><br>도착예정</td>
				<td class="center td7" width="12%">
					<input type="button" name="btn_buy_one" value="주문" class="btn_buy_one"><br>
					<input type="button" name="btn_delete_one" value="삭제" class="btn_delete_one">
			</tr>
			</form>
			<%} }%>
			<tr>
				<th colspan="7">EZENMALL 배송 상품 총 금액 : <b><%=df.format(p_tot) %></b> 원(+배송비 0원)</th>
			</tr>
		</table>
		<div class="d4">
			<span>선택한 상품</span>
			<input type="button" value="주문" id="btn_buy_select2">
			<input type="button" value="삭제" id="btn_delete_select2">
		</div>
		<table class="t_cart_tot">
			<tr>
				<th>총 상품금액<br><span class="s1"><%=df.format(p_tot) %></span>원</th>
				<th><img src="../../icons/plus.PNG" width="40"></th>
				<th>총 추가금액<br><span class="s2"><%=0 %></span>원</th>
				<th><img src="../../icons/minus.PNG" width="40"></th>
				<th>총 할인금액<br><span class="s3"><%=0 %></span>원</th>
				<th><img src="../../icons/equal.PNG" width="40"></th>
				<th>최종 결제금액<br><span class="s4"><%=df.format(p_tot) %></span>원</th>
			</tr>
			<tr>
				<th colspan="7">
					<span>정가 <b><%=df.format(p_tot2) %> 원</b> 에서<b> <%=df.format(p_tot3) %> 원</b> 할인</span><br>
					<span>총 주문수량: <%=k_count %>종 (<%=p_count %>개)</span>
				</th>
			</tr>
		</table>
		<table class="t_cart_address">
			<tr>
				<th>배송일 안내<br><input type="button" value="배송안내"></th>
				<td>배송지 : <%=address %><input type="button" value="배송지 변경">
			</tr>
		</table>
		<div class="d5">
			<input type="button" value="주문하기" id="btn_buy_select3">&ensp;&ensp;
			<input type="button" value="쇼핑계속하기" id="btn_shop">
		</div>
		<hr class="d_line2">
	</div>
	<jsp:include page="../common/shopBottom.jsp" />
</div>
</body>
</html>