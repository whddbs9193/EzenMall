<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="mall.bank.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카드 등록</title>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");
String memberId = (String)session.getAttribute("memberId");
if(memberId == null){
	out.print("<script>alert('로그인을 해주세요');");
	out.print("location='../logon/memberLoginForm.jsp';</script>");
	return;
}
%>
<jsp:useBean id="bank" class="mall.bank.BankDTO" />
<jsp:setProperty property="*" name="bank"/>
<%
String cart_id = null;
String product_id = null;
String buy_count = null;

cart_id = request.getParameter("cart_id");
product_id = request.getParameter("product_id");
buy_count = request.getParameter("buy_count");


BankDAO bankDAO = BankDAO.getInstance();
bankDAO.insertBank(bank);

if(cart_id != null){
	response.sendRedirect("../buy/buyForm.jsp?cart_id=" + cart_id);
}else if(product_id != null){
	response.sendRedirect("../buy/buyForm2.jsp?product_id=" + product_id + "&buy_count="+buy_count);
}


%>
</body>
</html>