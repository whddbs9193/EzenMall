<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="manager.product.*, java.util.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <%-- 파일폼 사용할때 쓰는 라이브러리 --%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> <%-- 파일폼 사용할때 쓰는 라이브러리 --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록 처리</title>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");

// 폼의 입력 정보 획득
// 파일업로드 폼 -> cos.jar 라이브러리의 MultipartRequest 클래스를 사용
// request, 업로드 폴더, 파일의 최대크기, encType, 파일명 중복 정책
// 
String realFolder = "c:/images_ezenmall"; // 이미지가 저장되는 경로
int maxSize = 1024 * 1024 * 5; //5MB 파일의 최대크기 지정
String encType = "utf-8"; // 인코딩 방법
String fileName = "";
MultipartRequest multi = null;

try{
	multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());
	
	Enumeration<?> files = multi.getFileNames();
	while(files.hasMoreElements()){ //파일즈 다음에 값이 있다면
		String name = (String)files.nextElement();
		fileName = multi.getFilesystemName(name); //업로드된 파일 이름
	}
	
}catch(Exception e){
	System.out.println("productRegisterPro.jsp 파일" + e.getMessage());
	e.printStackTrace();
}

// 폼에서 넘어오는 10개의 필드 값을 획득 - 제외)reg_date
String product_kind = multi.getParameter("product_kind");
String product_name = multi.getParameter("product_name");
int product_price = Integer.parseInt(multi.getParameter("product_price"));
int product_count = Integer.parseInt(multi.getParameter("product_count"));
String author = multi.getParameter("author");
String publishing_com = multi.getParameter("publishing_com");
String publishing_date = multi.getParameter("publishing_date");
//String product_image = multi.getParameter("product_image"); // 여기에는 이름을 얻을 수 없음.
String product_content = multi.getParameter("product_content");
int discount_rate = Integer.parseInt(multi.getParameter("discount_rate"));

// ProductDTO 객체 생성하고 setter 메소드를 사용하여 값을 설정 
ProductDTO product = new ProductDTO();
product.setProduct_kind(product_kind);
product.setProduct_name(product_name);
product.setProduct_price(product_price);
product.setProduct_count(product_count);
product.setAuthor(author);
product.setPublishing_com(publishing_com);
product.setPublishing_date(publishing_date);
product.setProduct_image(fileName); // 업로드한 파일의 실제 이름
product.setProduct_content(product_content);
product.setDiscount_rate(discount_rate);

// System.out.println("product 객체 확인" + product.toString());

// DB 연결, product 테이블에 상품 추가 처리
ProductDAO productDAO = ProductDAO.getInstance();
productDAO.insertProduct(product);
response.sendRedirect("productList.jsp");
%>

</body>
</html>