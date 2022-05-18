<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manager.product.*, java.util.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <%-- 파일폼 사용할때 쓰는 라이브러리 --%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> <%-- 파일폼 사용할때 쓰는 라이브러리 --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 정보 삭제 처리</title>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");

String pageNum = request.getParameter("pageNum");
int product_id = Integer.parseInt(request.getParameter("product_id"));
ProductDAO productDAO = ProductDAO.getInstance();
productDAO.deleteProduct(product_id);
response.sendRedirect("productList.jsp?pageNum=" + pageNum);
%>
</body>
</html>