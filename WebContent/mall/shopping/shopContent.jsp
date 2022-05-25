<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manager.product.*" %>
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
.s2{width:50%; float:left;}
.s2 > div{margin-bottom: 30px;}
.s2_d1{font-size: 1.5em; font-weight: bold;}
.s2_d2{font-size: 0.9em; color: gray;}
.s2 .ss{display: inline-block; width: 100px; font-size: 0.9em; color: gray;}
/* 구역3: 하단, 상품 내용, 상품 리뷰 */
.s3{clear: both;}

</style>
<script>

</script>
<%
String memberId = (String)session.getAttribute("memberId");
int product_id = Integer.parseInt(request.getParameter("product_id"));
ProductDAO productDAO = ProductDAO.getInstance();
ProductDTO product = productDAO.getProduct(product_id);

SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일");
DecimalFormat df = new DecimalFormat("#,###,###");

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
	<div class="d_kind"><a href="">홈</a>&ensp;>&ensp;<a href=""><%=product_kindName %></a></div>
	<div class="detail">
		<%-- 구역1: 상품이미지, 왼쪽 상단 --%>
		<div class="s1">
			<div class="big_img"><img src="/images_ezenmall/<%=product.getProduct_image() %>" width="450" height="600"></div>
			<div class="small_imgs">
				<img src="/images_ezenmall/<%=product.getProduct_image() %>" width="60" height="80">
				<img src="/images_ezenmall/<%=product.getProduct_image() %>" width="60" height="80">
				<img src="/images_ezenmall/<%=product.getProduct_image() %>" width="60" height="80">
				<img src="/images_ezenmall/<%=product.getProduct_image() %>" width="60" height="80">
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
			<div class="s2_d4"><span class="ss">판매가</span><span><%=df.format(sale_price) %>원</span></div>
			<div class="s2_d5"><span class="ss">할인율</span><span><%=product.getDiscount_rate() %></span>%</div>
			<div class="s2_d6"><span class="ss">배송안내</span><span></span></div>
			<div class="s2_d7"><span class="ss">배송비</span>무료</div>
			<div class="btns">
				<input type="button" value="장바구니" id="btn_cart">
				<input type="button" value="바로 구매" id="btn_buy">
			</div>
		</div>
		</form>
		<%-- 구역3: 하단, 상품 내용, 상품 리뷰 --%>
		<div class="s3">
		
		</div>
	</div>
	<jsp:include page="../common/shopBottom.jsp" />
</div>
</body>
</html>