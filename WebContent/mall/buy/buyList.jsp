<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="mall.buy.*,java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>최종구매확인폼</title>
<style>
.container{width: 1200px; margin: 0 auto;}
.d1{width: 43%; padding:15px; margin: 15px 45px; float:right; display: inline-block;}
.d1 .s1{font-size: 1.1em; font-weight: bold; margin-right: 30px;}
.d1 .s2, .d1 .s3{display:inline-block; width:150px; text-align:center; padding: 6px 17px; border:1px solid gray; font-weight: bold; font-size: 0.8em; border-radius: 15px;}
.d1 .s2{background: #333; color:#fff; z-index: 1; position: relative;}
.d1 .s3{background: #fff; color:#333; margin-left: -30px; z-index:-1; position: relative;}
.d_line{clear: both;}
/* 상단 - d2 */
.d2{ width: 35%; padding: 15px; margin: 5px 45px; float: left; display: inline-block; text-align: left;}
.d_line{ clear: both; width: 90%; border: 1px solid lightgray;}


/* 중단 -d3 (검색)*/
.d3{ width: 95%; text-align: right;}
.d3 .d3_1{ font-size: 1.1em; font-weight: bold; color: #32708d; text-align: right;}
.d3 .d3_2{margin-top: 10px; }
.d3 .d3_2 a{text-decoration: none; color: #32708d; font-size: 0.9em; font-weight: bold; text-align: center;
display: inline-block; width: 60px; height: 18px; padding: 5px; border: 1px solid #32708d; border-radius: 5px; }
.d3 .d3_3 {margin-top: 10px;}
.d3 input[type=date] {width: 150px; height: 22px; margin: 0 10px;}
.d3 input[type=button]{width: 50px; height: 25px; border: none; background: #32708d; color: #fff; font-size: 0.9em;
border-radius: 5px; cursor: pointer; }

/* 중단 - d4(구매목록) */
.d4{margin-bottom: 50px;}
.d4 .t1{width: 90%; border:1px solid gray; border-collapse: collapse; margin: 0 auto; font-size: 0.9em; 
border-left: none; border-right: none; clear: both;}
.d4 .t1 tr{height: 40px;}
.d4 .t1 td, .d4 .t1 th{border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6; border-left: none; border-right: none;}
.d4 .t1 th{background: #1e94be; color:#fff; text-shadow: 1px 1px 1px gray;}
.left{text-align: left; padding-left: 10px;}
.right{text-align: right; padding-right: 30px;}
.center{text-align: center; padding: 5px;}
.t1 .s1 a{text-decoration: none; color: gray; font-weight: bold;}
.t1 .s2 a{text-decoration: none; color: #1e94be; font-weight: bold;}
.t1 .s2 .s22{color: red; font-weight: bold;}
.t1 .s3 {color: #99424f; font-weight: bold; font-size: 1.05em;}
.t1 .s4 {color: #1e9faa; font-weight: bold;}
.t1 .s5 {color: #1e94be; font-weight: bold;}
.t1 .s6, .t1 .s7{margin-top: 5px;}
.t1 .s6 input, .t1 .s7 input{ width: 80px; height: 28px; border-radius: 3px; border:none; font-weight: bold; font-size: 0.85em;
cursor: pointer;}
.t1 .s6 input{background: #32708d; color: #fff; }
.t1 .s7 input{background: #2f9e77; color: #fff; }

</style>
<script>
	document.addEventListener("DOMContentLoaded",function(){
		let preiod1 = document.getElementById("period1");
		let preiod2 = document.getElementById("period2");
		
		let btn_search = document.getElementById("btn_search");
		btn_search.addEventListener("click", function(){
			location = "buySearchPro.jsp?period1=" + period1.value + "&period2=" + period2.value;
		})
	})
</script>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");
String memberId = (String)session.getAttribute("memberId");

if(memberId == null){
	out.print("<script>alert('로그인을 해주세요.')");
	out.print("location='../logon/memberLoginForm.jsp'</script>");
	return;
}
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
DecimalFormat df = new DecimalFormat("#,###,###");

BuyDAO buyDAO = BuyDAO.getInstance();
List<BuyDTO> buyList = buyDAO.getBuyList(memberId);

/* for(BuyDTO buy : buyList){
	System.out.println("buylist : " + buy);
} */

int tot1 = 0, tot2 = 0, cnt=0;
String order_id = "";

%>

<div class="container">
	<jsp:include page="../common/shopTop.jsp" />
	<div class="buyList">
		<div class="d1">
			<span class="s1">EZENMALL 배송</span>
			<span class="s2">당일/하루/일반 배송</span>
			<span class="s3">아침배송</span>
		</div>
		<div class="d2">
			<img src="../../icons/progress03.png" width="400" height="60">
		</div>
		<hr class="d_line">
		<div class="d3"> <!-- 날짜별 구매정보 검색 -->
			<div class="d3_1">구매 목록 검색</div>
			<div class="d3_2">
				<a href="buySearchPro.jsp?period1=one_day&period2=now">오늘</a>
				<a href="buySearchPro.jsp?period1=one_week&period2=now">1주일</a>
				<a href="buySearchPro.jsp?period1=two_week&period2=now">2주일</a>
				<a href="buySearchPro.jsp?period1=one_month&period2=now">1개월</a>
				<a href="buySearchPro.jsp?period1=two_month&period2=now">2개월</a>
				<a href="buySearchPro.jsp?period1=three_month&period2=now">3개월</a>
				<a href="buySearchPro.jsp?period1=six_month&period2=now">6개월</a>
				<a href="buySearchPro.jsp?period1=one_year&period2=now">1년</a>
				<a href="buySearchPro.jsp?period1=two_month&period2=now">2년</a>
			</div>
			<div class="d3_3">
				<input type="date" id="period1"> ~ <input type="date" id="period2">
				<input type="button" value="검색" id="btn_search">
			</div>
		</div>
		
		<hr class="d_line">
		<div class="d4"> <!-- 구매 정보 -->
			<table class="t1">
				<tr>
					<th width="20%">주문일자(주문번호)</th>
					<th colspan="2" width="45%">주문상품</th>
					<th width="10%">주문금액</th>
					<th width="10%">배송비</th>
					<th width="15%">주문상태</th>
				</tr>
				<%if(buyList.size() == 0){ %>
				<tr><td colspan="6" class="center">구매 내역이 없습니다.</td></tr>
				<%} else {
				for(BuyDTO buy : buyList){ 
					tot1 = buy.getBuy_price() * buy.getBuy_count();
					tot2 += tot1;
					String buy_id = buy.getBuy_id();
					cnt = buyDAO.getBuyIdCount(buy_id);
					
					// 같은 구매번호는 1건만 표시
					if(!order_id.equals(buy_id)) {
						order_id = buy_id;
				%>
				<tr>
					<td class="center">
						<span class="s1"><a href="buyDetail.jsp?buy_id=<%=buy.getBuy_id() %>"><%=sdf.format(buy.getBuy_date()) %><br>(<%=buy.getBuy_id() %>)</a></span>
					</td>
					<td width="8%" class="left">
						<a href="buyDetail.jsp?buy_id=<%=buy.getBuy_id() %>"><img src="/images_ezenmall/<%=buy.getProduct_image() %>" width="60" height="90"></a>
					</td>
					<td width="37%" class="left">
						<span class="s2"><a href="buyDetail.jsp?buy_id=<%=buy.getBuy_id() %>"><%=buy.getProduct_name() %> </a><span class="s22"> (총 <%=cnt %>종)</span></span>
					</td>
					<td class="right"><span class="s3"><%=df.format(buy.getBuy_price() * buy.getBuy_count()) %>원</span></td>
					<td class="center"><span class="s4">무료</span></td>
					<td class="center">
						<div class="s5"><%=buy.getDelivery_state() %></div>
						<div class="s6"><input type="button" class="btn_delivery" value="배송조회"></div>
						<div class="s7"><input type="button" class="btn_review" value="리뷰작성"></div>
					</td>
				</tr>
				<%} } }%>
			</table>
		</div>
		<br>
 	<jsp:include page="../common/shopBottom.jsp" />
	</div>
</div>
</body>
</html>