<%@ page language="java" import="java.util.*,database.*,dao.*,dao.impl.*,model.*,page.*,java.text.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<% 
	UserDaoImpl user = new UserDaoImpl();
	String ma = user.getName("select ma_status from status order by sem_id desc limit 0,1");
	String pb = user.getName("select pub_status from status order by sem_id desc limit 0,1");
	String start = user.getName("select start from status order by sem_id desc limit 0,1");
	String end = user.getName("select end from status order by sem_id desc limit 0,1");
	Date current = new Date();
	SimpleDateFormat ft = new SimpleDateFormat("YYYY-MM-dd");
	String now = ft.format(current); 
	
%>
<!DOCTYPE HTML>
<html lang="en">
  <head>
  	<meta charset="utf-8">
   <base href="<%=basePath%>">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-2.1.3.js"></script>
	<link href="${pageContext.request.contextPath}/css/jquery-ui.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
	<!--[if lt IE 9]>
      <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/laydate/laydate.js"></script>
    <script src="${pageContext.request.contextPath}/js/new_model_funcs.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/js/user_model2_checkbox.js" type="text/javascript"></script>
  </head>
  
  <body>
  	<%if(ma.equals("否,")&&pb.equals("否,")){ %>
  	<jsp:include page="course_unopen.jsp"></jsp:include>
  	<%}else if(ma.equals("是,")&&pb.equals("是,")&&now.compareTo(end.substring(0, end.length()-1))==-1
  	&&now.compareTo(start.substring(0, start.length()-1))>=0){ %>
  	 <jsp:include page="course_add.jsp"></jsp:include> 
  	<%}else{ %>
  	<jsp:include page="course_unopen.jsp"></jsp:include>  
  	<%} %>
  </body>
</html>
