<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 쇼핑몰 상단 페이지 : 쇼핑몰의 모든 페이지 상단에 포함되는 페이지 --%>
<style>
@import url('https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Dongle:wght@300&family=Nanum+Pen+Script&family=Permanent+Marker&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Koulen&family=Nanum+Pen+Script&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Koulen&family=Nanum+Pen+Script&family=Permanent+Marker&display=swap');
/* 전체 레이아웃 */
.top a{text-decoration: none; }
.t_box1, .t_box2, .t_box3, .t_box4{display:inline-block; padding: 2%;}
.t_box1, .t_box3{width: 65%;}
.t_box2, .t_box4{width: 25%;}
/* 구역1(상단 좌측) 타이틀, 검색 */
.t_box1 .m_title{font-family: 'Permanent Marker', cursive; font-size: 3em;}
.t_box1 .s_title{font-family: 'Nanum Pen Script', cursive; font-size: 1.5em;}
/* 구역2(상단 우츨) 회원정보, 구매정보, 장바구니정보 */
.t_box2 .t_b2_img1:hover{content: url('../../icons/user2.png');}
.t_box2 .t_b2_img2:hover{content: url('../../icons/buy2.png');}
.t_box2 .t_b2_img3:hover{content: url('../../icons/cart2.png');}

/* 구역3(하단 좌측) 메인메뉴(하위메뉴) */
.t_box3{ }
.t_box3 div{display: inline-block; padding: 10px; margin-right:10px; color: #a6615a; font-weight: bold; font-family: 'Dongle', sans-serif; font-size: 2em;}
.t_box3 .m_menu0{padding: 2px; position: relative; top: 8px;}
.t_box3 .m_menu_img:hover{content: url('../../icons/menu2.png');}
.t_box3 .sub{display: none;}
.t_box3 .main:hover .t_box3 .sub{display: block;}

/* 구역4(하단 우측) 로그인, 회원가입, 고객센터 */

</style>
<script>

</script>
<div class="top">
	<div class="t_box1"> <%-- 구역1(상단 좌측): 타이틀, 검색--%>
		<div class="m_title"><a href="../shopping/shopAll.jsp">EZENMALL</a></div>
		<div class="s_title">책과 함께 인생의 지혜를...</div>
		<div class="t_search">
			<form action="" method="post" name="searchForm">
				<input type="search" name="keyword" id="keyword">
				<button type="submit"></button>
			</form>
		</div>
	</div>
	<div class="t_box2"> <%-- 구역2(상단 우측): 회원정보, 구매정보, 장바구니정보 --%>
		<a><img src="../../icons/user1.png" width="30" title="회원정보" class="t_b2_img1"></a>
		<a><img src="../../icons/buy1.png" width="30" title="구매정보" class="t_b2_img2"></a>
		<a><img src="../../icons/cart1.png" width="30" title="장바구니정보" class="t_b2_img3"></a>
	</div>	
	<div class="t_box3"> <%-- 구역3(하단 좌측): 메인메뉴(하위메뉴) --%>
		<div class="m_menu0"><a href="#"><img src="../../icons/menu1.png" width="25" class="m_menu_img"></a></div>
		<div class="m_menu1"><a href="#">소설/시</a></div>     <%-- 100번대 main --%>
		<div class="s_menu1 sub">
			<div>소설/시</div>
			<div>에세이</div>
		</div>
		<div class="m_menu2 main"><a href="#">인문</a></div>		  <%-- 200번대 main --%>
		<div class="s_menu2 sub">
			<div>역사</div>
			<div>예술</div>
			<div>종교</div>
			<div>사회</div>
			<div>과학</div>
		</div>
		<div class="m_menu3 main"><a href="#">경제/자기계발</a></div> <%-- 300번대 main --%>
		<div class="s_menu3 sub">
			<div>경제/경영</div>
			<div>자기계발</div>
		</div>
		<div class="m_menu4 main"><a href="#">여행/잡지</a></div>	  <%-- 400,500번대 main --%>
		<div class="s_menu4 sub">
			<div>여행</div>
			<div>만화</div>
			<div>잡지</div>
		</div>
		<div class="m_menu5 main"><a href="#">가정/건강</a></div>	  <%-- 600,700번대 main --%>
		<div class="s_menu5 sub">
			<div>어린이</div>
			<div>육아</div>
			<div>가정/살림</div>
			<div>요리</div>
		</div>
		<div class="m_menu6 main"><a href="#">IT/수험서</a></div>	  <%-- 800,900번대 main --%>
		<div class="s_menu6 sub">
			<div>IT 모바일</div>
			<div>수험서/자격증</div>
			<div>참고서</div>
		</div>
	</div>
	<div class="t_box4"> <%-- 구역4(하단 우측): 로그인, 회원가입 --%>
		<a href="#"><span>로그인</span></a>
		<a href="#"><span>회원가입</span></a>
		<a href="#"><span>고객센터</span></a>
	</div>
</div>