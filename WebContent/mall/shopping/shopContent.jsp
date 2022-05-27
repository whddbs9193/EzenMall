<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manager.product.*,mall.member.*, mall.review.*,java.text.*, java.util.*" %>
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
.big_img{transition: 0.5s}
.big_img:hover{transform: scale(1.01);}
.small_imgs{margin:20px;}
.small_imgs .thumb{margin: 0 10px; cursor: pointer; transition: 0.5s;}
.small_imgs .thumb:hover{ transform: scale(1.05);}

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
.btns{margin-top: 65px; text-align: center;}
.btns input[type='button'] {width: 240px; height: 60px; border: 0; font-size: 1.1em; cursor: pointer;}
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

.s3_c3 .s3_review{line-height:30px; text-align: justify; padding:20px; width:100%; height:200px;}
.s3_review .r1{width: 75%; float: left;}
.s3_review .r2{width: 20%; float: right;}
.s3_review .r1, .s3_review .r2{border: 1px solid black;}
/* 하단- 페이징 영역 */
#paging{text-align: center; margin-top: 20px; clear: both;}
#pBox{display: inline-block; width: 22px; height: 22px; padding: 5px; margin: 5px;}
#pBox:hover{background: #f1617d; color: white; font-weight: bold; border-radius: 50%;}
.pBox_c{ background: #f1617a; color: white; font-weight: 900; border-radius: 50%;}
.pBox_b{ font-weight: bold;}
.main_end{margin: 60px 0 20px;}
</style>
<script>
	document.addEventListener("DOMContentLoaded", function(){
		// 이미지 변화 효과
		let big_img = document.querySelector(".big_img");
		let thumb_imgs = document.querySelectorAll(".thumb");
		
		for(let thumb of thumb_imgs){
			thumb.addEventListener("click", function(){
				big_img.src = thumb.src;
			})
		}
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

//################## 페이지(paging) 처리###################
//페이징(paging) 처리를 위한 변수 선언
int pageSize = 5; //1페이지에 5건의 게시글을 보여줌.
String pageNum = request.getParameter("pageNum"); // 페이지 번호
if(pageNum == null) pageNum = "1";  // 페이지가 없다면 첫페이지이다

int currentPage = Integer.parseInt(pageNum);  // 현재 페이지
int startRow = (currentPage -1) * pageSize +1;  // 현재 페이지의 첫번째 행
int endRow = currentPage * pageSize; // 현재 페이지의 마지막 행
//#######################################################

// 리뷰 DB연결, 
ReviewDAO reviewDAO = ReviewDAO.getInstance();
List<ReviewDTO> reviewList = reviewDAO.getReviewList(startRow, pageSize, product_id);
int cnt = reviewDAO.getReviewCount(product_id);

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

// 개인 쇼핑몰에서 이미지가 5장이고, 1번만 not null이고, 나머지는  nothing.jpg가 저장되어 있다고 가정할 때
/*
String product_image1 = product.getProduct_image1();
if(product.getProduct_image2().equals("nothing.jpg")) prodcut.setProduct_image2(product_image1);
if(product.getProduct_image3().equals("nothing.jpg")) prodcut.setProduct_image3(product_image1);
if(product.getProduct_image4().equals("nothing.jpg")) prodcut.setProduct_image4(product_image1);
*/
%>
</head>
<body>
<div class="container">
	<jsp:include page="../common/shopTop.jsp" />
	<div class="d_kind"><a href="shopAll.jsp#t_kind">홈</a>&ensp;>&ensp;<a href="shopAll.jsp?product_kind=<%=product_kind %>#t_kind"><%=product_kindName %></a></div>
	<div class="detail">
		<%-- 구역1: 상품이미지, 왼쪽 상단 --%>
		<div class="s1">
			<div><img src="/images_ezenmall/<%=product.getProduct_image() %>" width="450" height="600" class="big_img"></div>
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
			<div class="s2_d6"><span class="ss">배송안내</span><br>
				<%if(memberId != null){ %>
				<span><b><%=name %></b> 님의 주소로 <b><%=d_day %></b>까지 배송됩니다.</span><br>
				<span>주소 : <b><%=address %></b></span>
				<%}else{ %>
				<span>
					배송일은 서울은 익일, 경기는 2일, 지방은 3일, 제주 및 도서 지역은 평균 5일이 소요됩니다.<br>
					단, 토, 일요일은 배송 업무를 하지 않습니다.
				</span>
				<%} %>
			</div>
			<div class="s2_d7"><span class="ss">배송비</span>
				<span>
					무료<br>
					제주도: 3,000원 / 도서산간: 3,000원
				</span>
			</div>
			<div class="btns">
				<input type="button" value="장바구니" id="btn_cart">
				<input type="button" value="바로 구매" id="btn_buy">
			</div>
		</div>
		</form>
		<hr class="t_line">
		<%-- 구역3: 하단, 상품 내용, 상품 리뷰 --%>
		<div class="s3" id="s3">
			<div class="s3_c1"><span class="ss1">상세설명</span><span class="ss2">상품리뷰</span><span class="ss3">상품문의</span><span class="ss4">교환/반품</span></div>
			<div class="s3_c2"><%=product.getProduct_content() %></div>
			<div class="s3_c3">
			<%for(ReviewDTO review : reviewList){ %>
				<div class="s3_review">
					<div class="r1">
						<div><%=review.getSubject() %></div>
						<div><%=review.getContent() %></div>
					</div>
					<div class="r2">
						<div>작성자: <%=review.getMember_id() %></div>
						<div>등록일: <%=review.getRegDate() %></div>
						<div>조회수: <%=review.getReadcount() %></div>
					</div>
				</div>
				<%} %>
				<%-- 하단 : 페이징 처리 --%>
				<div id="paging">
				<%
				if(cnt > 0){
					int pageCount = cnt / pageSize + (cnt%pageSize==0 ? 0 : 1); // 전체 페이지수  266/ 10 + (266%10 == 0 ? 0 : 1)
					int startPage = 1; // 시작 페이지 번호
					int pageBlock = 5; // 페이징의 개수
					
					// 시작 페이지 설정       235 -> currentPage   ex) (235 / 10) * 10 + 1 -> 231 startPage -- 10으로 나누어 떨어지지 않으면
					// 230 currentpage -> (230/10) * 10 + 1 -> 221 , startPage -- 10으로 나누어 떨어지면
					if(currentPage%5 != 0) startPage = (currentPage/5) * 5 + 1;
					else startPage = (currentPage/5 - 1) * 5 + 1; 
					
					// 끝 페이지 설정   231 + 10 - 1  -> 240 endPage -- 10으로 나누어 떨어지지 않으면
					// 221 + 10 -1 -> 230, endPage
					int endPage = startPage + pageBlock - 1;
					if(endPage > pageCount) endPage = pageCount; // -> 266이 마지막글이면  261번부터 270번 사이에 존재 해야하지만 테이블엔 270이 없으니
					// 260/10 * 10 + 1 -> 261 startPage    261 + 10 -1 이면 270 endPage가 되지만! 270은 없기에 pageCount = 266이기에 endPage에 266을 넣는다
					// 즉 startPage 는 261, endPage는 266이된다.
					
					// 맨 처음 페이지 이동 처리
					if(startPage >  5){
						out.print("<a href='shopContent.jsp?pageNum=1&product_kind="+product_kind+"&product_id="+product_id+"#s3'><div id = 'pBox' class='pBox_b' title='첫 페이지'>"+ "〈〈" + "</div></a>");
					}
					
					// 이전 페이지 처리
					if(startPage >  5){
						out.print("<a href='shopContent.jsp?pageNum="+ (currentPage-5) + "&product_kind="+product_kind+ "&product_id="+product_id+"#s3'title='이전 5페이지'><div id = 'pBox' class='pBox_b'>"+ "〈 " + "</div></a>");
					}
					// 페이징 블럭 출력 처리
					for(int i=startPage ; i <= endPage; i++){
						if(currentPage == i){ // 선택된 페이지 현재 페이지일 때
							out.print("<div id='pBox' class='pBox_c'>"+ i +"</div>");
						}else{ // 다른 페이지일 때 -> 이동에 대한 링크 설정
							out.print("<a href='shopContent.jsp?pageNum=" + i + "&product_kind="+product_kind+"&product_id="+product_id+"#s3'><div id='pBox'>"+ i +"</div></a>");
						}
					}
					// 다음 페이지 처리
					if(endPage < pageCount){
						int movePage = currentPage + 5;
						if(movePage > pageCount) movePage = pageCount;
						out.print("<a href='shopContent.jsp?pageNum="+ movePage +"&product_kind="+product_kind+"&product_id="+product_id+"#s3'title='다음 5페이지'><div id = 'pBox' class='pBox_b'>"+ " 〉" + "</div></a>");
					}
					// 맨 끝 페이지 이동 처리
					if(endPage < pageCount){
						out.print("<a href='shopContent.jsp?pageNum="+ pageCount + "&product_kind="+product_kind+"&product_id="+product_id+"#s3'title='끝페이지'><div id = 'pBox' class='pBox_b' >"+ " 〉〉" + "</div></a>");
					}
				}
				%>
			</div>
		</div>
	</div>
	<hr class="t_line">
	<jsp:include page="../common/shopBottom.jsp" />
</div>
</body>
</html>