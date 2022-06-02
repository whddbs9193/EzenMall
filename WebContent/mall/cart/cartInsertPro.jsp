<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="mall.cart.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니 등록</title>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");

String memberId = (String)session.getAttribute("memberId");
if(memberId == null){
	out.print("<script>alert('로그인을 해주세요');");
	out.print("location='../logon/memberLoginForm.jsp';</script>");
}
%>
<jsp:useBean id="cart" class="mall.cart.CartDTO" />
<jsp:setProperty property="*" name="cart"/>

<% 
// 카트 정보 확인
//System.out.println(cart);

// DB 연결, 질의
CartDAO cartDAO = CartDAO.getInstance();
int check = cartDAO.insertCart(cart);

out.print("<script>");
if(check == 0){
	out.print("alert('장바구니 추가에 실패하였습니다.');history.back();");
}else{
	out.print("location='cartList.jsp'");
}
out.print("</script>");
%>
</body>
</html>