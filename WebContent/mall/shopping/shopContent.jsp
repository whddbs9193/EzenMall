<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manager.product.*, mall.member.*, java.text.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 상세</title>
<style>
.container{width: 1200px; margin: 0 auto; }
.d_kind{margin: 20px 0;}
.d_kind a{text-decoration: none; color: black; font-size: 18px; color:#32708d; font-weight: bold;}
.d_kind a:hover{text-shadow: 1px 1px 1px lightgray;}
/* 구역1: 상품이미지, 왼쪽 상단  */
.s1{width:50%; float:left; text-align: center;}
.small_imgs{margin:20px;}
.small_imgs img{margin: 0 10px;}

/* 구역2: 오른쪽 상단, 상품 기본 정보, 버튼 */
.s2{width:44%; float:left; background: #f8f9fa; padding:30px 30px 0 30px; border-radius: 2%;}
.s2 > div{margin-bottom: 30px;}
.s2_d1{font-size: 1.5em; font-weight: bold; color: #1e9faa;}
.s2_d2{font-size: 0.9em; color: gray;}
.s2 .ss{display: inline-block; width: 100px; font-size: 0.9em; color: gray;}
.s2_d3 span:nth-child(2){font-weight: bold; color: gray;}
.s2_d4 span:nth-child(2), .s2_d5 span:nth-child(2) {color:#c84557;}
.s2_d4 b{font-size:1.5em;}
.s2_d6 span:not(.ss){font-size: 0.9em; color: gray;}
.s2_d6 b{font-size: 1.05em; color: #1e94be;}
.s2_d7 span:nth-child(2){font-size: 0.9em; color: gray;}
.btns{margin-top: 30px; text-align: center;}
.btns input[type='button'] {width: 240px; height: 60px; border: 0; font-size: 1.1em;}
.btns #btn_cart{background: #2f9e77; color: #fff; margin-right: 10px;}
.btns #btn_cart:hover{background: #fff; color: #2f9e77; border: 2px solid #2f9e77; font-weight: bold;}
.btns #btn_buy{background: #1e9faa; color: #fff; margint-left: 10px;}
.btns #btn_buy:hover{background: #fff; color: #1e9faa; border: 2px solid #1e9faa; font-weight: bold;}

/* 구역3: 하단, 상품 내용, 상품 리뷰 */
.t_line{border: 1px solid lightgray; margin: 30px 0; clear:both;}
.s3_c1{background: #7bb0db; padding: 10px; border-radius: 5px; margin-bottom: 40px;}
.s3_c1 span{display: inline-block; width: 120px; height: 30px; padding: 10px;  margin: 0 20px; border: 2px solid #7bb0db;
text-align: center; line-height: 30px; border-radius: 5px; color: #fff; font-size: 1.05em; cursor: pointer;}
.s3_c1 span:hover{ border: 2px solid #fff; text-shadow: 1px 1px 1px darkgray;}
.s3_c2{line-height: 35px; text-align: justify; padding:20px;}

</style>
<script>
	document.addEventListener("DOMContentLoaded", function(){
		// 이미지 변화 효과
		let big_img = document.querySelector(".big_img");
		let thumb = document.querySelector(".thumb");
		thumb.addEventListener("click", function(){
			big_img.src = thumb.src;
		})
	})
</script>
<%
String memberId = (String)session.getAttribute("memberId");
int product_id = Integer.parseInt(request.getParameter("product_id"));

DecimalFormat df = new DecimalFormat("#,###,###");

// 상품DB 연결, 질의
ProductDAO productDAO = ProductDAO.getInstance();
ProductDTO product = productDAO.getProduct(product_id);

// 회원 DB 연결, 질의 - 세션의 여부 확인(로그인)
MemberDAO memberDAO = null;
MemberDTO member = null;
String name = null;
String address = null;
String local = null;
String d_day = null;
if(memberId != null){
	memberDAO = MemberDAO.getInstance();
	member = memberDAO.getMember(memberId);
	name = member.getName();
	address = member.getAddress();
	local = address.substring(0,2); // 주소에서 2글자만 추출
	
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
	d_day = month + "월" + date + "일(" + weekday[week] +")요일 ";
	// System.out.println("배송일: " + month + "월" + date + "일(" + weekday[week] + "요일)");
	
}


// 상품 분류별 상품명 설정
String product_kindName = "";
String product_kind = product.getProduct_kind();
switch(product_kind){
case "110": product_kindName = "소설/시"; break;
case "120": product_kindName = "에세이"; break;
case "210": product_kindName = "역사"; break;
case "220": product_kindName = "예술"; break;
case "230": product_kindName = "종교"; break;
case "240": product_kindName = "사회"; break;
case "250": product_kindName = "과학"; break;
case "310": product_kindName = "경제/경영"; break;
case "320": product_kindName = "자기계발"; break;
case "410": product_kindName = "여행"; break;
case "420": product_kindName = "만화"; break;
case "510": product_kindName = "잡지"; break;
case "610": product_kindName = "어린이"; break;
case "620": product_kindName = "가정/살림"; break;
case "630": product_kindName = "육아"; break;
case "710": product_kindName = "건강/취미"; break;
case "720": product_kindName = "요리"; break;
case "810": product_kindName = "IT 모바일"; break;
case "910": product_kindName = "수험서/자격증"; break;
case "920": product_kindName = "참고서"; break;
}

// 출판일 출력 설정
String p_date = product.getPublishing_date();
String publishing_date = p_date.substring(0,4) + "년 " + p_date.substring(5,7) + "월 " + p_date.substring(8,10) + "일"; 

// 판매가 계산
int price = product.getProduct_price();
int d_rate = product.getDiscount_rate();
int sale_price = price - (price * d_rate/100);
%>
</head>
<body>
<div class="container">
	<jsp:include page="../common/shopTop.jsp" />
	<div class="d_kind"><a href="shopAll.jsp#t_kind">홈</a>&ensp;>&ensp;<a href="shopAll.jsp?product_kind=<%=product_kind %>#t_kind"><%=product_kindName %></a></div>
	<div class="detail">
		<%-- 구역1: 상품이미지, 왼쪽 상단 --%>
		<div class="s1">
			<div class="big_img"><img src="/images_ezenmall/<%=product.getProduct_image() %>" width="450" height="600"></div>
			<div class="small_imgs">
				<img src="/images_ezenmall/<%=product.getProduct_image() %>" width="60" height="80" class="thumb">
				<img src="../../icons/t01.png" width="60" height="80" class="thumb">
				<img src="../../icons/t02.png" width="60" height="80" class="thumb">
				<img src="../../icons/t03.png" width="60" height="80" class="thumb">
			</div>
		</div>
		<%-- 구역2: 오른쪽 상단, 상품 기본 정보, 버튼 --%>
		<form action="" method="post" name="">
		<div class="s2">
			<div class="s2_d1"><%=product.getProduct_name() %></div>
			<div class="s2_d2">
				<span><%=product.getAuthor() %>&emsp;|&emsp;<%=product.getPublishing_com() %>&emsp;|&emsp;<%=publishing_date %></span>
			</div>
			<div class="s2_d3"><span class="ss">정가</span><span><%=df.format(price) %>원</span></div>
			<div class="s2_d4"><span class="ss">판매가</span><span><b><%=df.format(sale_price) %></b>원</span></div>
			<div class="s2_d5"><span class="ss">할인율</span><span><b><%=product.getDiscount_rate() %></b>%</span></div>
			<div class="s2_d6"><span class="ss">배송안내</span><br><br>
				<%if(memberId != null){ %>
				<span><b><%=name %></b> 님의 주소로 <b><%=d_day %></b>까지 배송됩니다.</span><br><br>
				<span>주소 : <b><%=address %></b></span>
				<%}else{ %>
				<span>
					배송일은 서울은 익일, 경기는 2일, 지방은 3일, 제주 및 도서 지역은 평균 5일이 소요됩니다.<br><br>
					단, 토, 일요일은 배송 업무를 하지 않습니다.
				</span>
				<%} %>
			</div>
			<div class="s2_d7"><span class="ss">배송비</span><span>무료</span></div>
			<div class="btns">
				<input type="button" value="장바구니" id="btn_cart">
				<input type="button" value="바로 구매" id="btn_buy">
			</div>
		</div>
		</form>
		<hr class="t_line">
		<%-- 구역3: 하단, 상품 내용, 상품 리뷰 --%>
		<div class="s3">
			<div class="s3_c1"><span class="ss1">상세설명</span><span class="ss2">리뷰</span><span class="ss3">상품문의</span><span class="ss4">교환/반품</span></div>
			<div class="s3_c2"><%=product.getProduct_content() %></div>
			<div class="s3_c3"></div>
		</div>
	</div>
	<hr class="t_line">
	<jsp:include page="../common/shopBottom.jsp" />
</div>
</body>
</html>