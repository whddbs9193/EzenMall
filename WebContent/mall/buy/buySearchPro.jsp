<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 목록 검색(기간)</title>
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

String period1 = request.getParameter("period1");
String period2 = request.getParameter("period2");



Calendar c = Calendar.getInstance();
int year = c.get(Calendar.YEAR);
int month = c.get(Calendar.MONTH) + 1;
int date = c.get(Calendar.DATE);
String now = year + "-" + (month < 10 ? "0"+month : month) + "-" + date;
System.out.println("now: " + now);

//now, one_week, two_week, one_month, two_month, three_month, six_month, one_year, two_year
String[] sep = {"day","day","day", "month","month","month","month","year","year"}; 
int[] p1 = {0, -7,-14,-1,-2,-3,-6,-1,-2};
String[] days = new String[9];

for(int i=0; i<p1.length; i++){
	c = Calendar.getInstance();
	switch(sep[i]){
	case "day": c.add(Calendar.DATE, p1[i]); break;
	case "month": c.add(Calendar.MONTH, p1[i]); break;
	case "year": c.add(Calendar.YEAR, p1[i]); break;
	}
	year = c.get(Calendar.YEAR);
	month = c.get(Calendar.MONTH) + 1;
	date = c.get(Calendar.DATE);
	days[i] = year + "-" + (month < 10 ? "0"+month : month) + "-" + (date < 10 ? "0" : date);
	System.out.println("days["+ i + "]" + days[i]);
}

%>
</body>
</html>