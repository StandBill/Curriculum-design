<%@ page language="java" import="java.util.*,model.*,dao.*,dao.impl.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
	String uid = request.getSession().getAttribute("u_id").toString();
	UserDaoImpl user = new UserDaoImpl();
	String sql = "select t.t_id,t.name,c.col_name,ti.name,t.sex,t.reg_date,t.t_psw from teacher t,title ti,college c where t_id=? "+
				"and t.col_id=c.col_id AND t.title_id=ti.title_id";
	String[] ar = {uid};
	ArrayList<HashMap<Integer,Object>> teacher = user.getList(sql, ar);
	HashMap<Integer,Object> t = teacher.get(0);
 %>
<!DOCTYPE html>
<html lang="en">
<head>
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
    <style>
    	#student,#teacher{position:absolute;top:50px;left:65px;width:95%;height: 99%;}
    	
    </style>
</head>
<body>
	<nav class="navbar navbar-default navbar-static-top navbar-inverse">
	  <div class="container-fluid">
	    <!-- Brand and toggle get grouped for better mobile display -->
	    <div class="navbar-header">
	      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
	        <span class="sr-only">Toggle navigation</span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	      </button>
	      <a class="navbar-brand" href="teacher_html/index.jsp">教师端</a>
	    </div>
	
	    <!-- Collect the nav links, forms, and other content for toggling -->
	    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
	      <ul class="nav navbar-nav navbar-right">
	        <li class="dropdown">
	          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><%=request.getSession().getAttribute("u_name") %><span class="caret"></span></a>
	          <ul class="dropdown-menu">
	            <li><a href="javascript:void(0)"  data-toggle="modal" name="myModal_add" data-target="#myModal_add">关于我</a></li>
	            <li><a href="login_html/logout.jsp">退出登录</a></li>
	          </ul>
	        </li>
	      </ul>
	    </div>
	  </div>
	</nav>

     <div class="leftMenu">
      <ul class="ul_left">
          <li>
               <a id="select" onclick="setLiBgColor('select')" href="javascript:void(0)" target="_top" style="background-color:#232423;">
                   <img width="38" height="26" src="${pageContext.request.contextPath}/image/student.png"><br/>已开课程
               </a> 
           </li>
           <li>
               <a id="select_teacher" onclick="setLiBgColor('select_teacher')" href="javascript:void(0)" target="_top">
                   <img width="35" height="26" src="${pageContext.request.contextPath}/image/teacher.png"><br/>
                   添加课程
               </a> 
           </li>
	 </ul>
	</div>
	<div id="student">
       <iframe id="student_info" src="${pageContext.request.contextPath}/teacher_html/course.jsp" width="99%" height="98%" style="border:0"></iframe>
   </div>
   <div id="teacher" style="display:none">
       <iframe id="student_info" src="${pageContext.request.contextPath}/teacher_html/course_index.jsp" width="99%" height="98%" style="border:0"></iframe>
   </div>
	    

	<form action="AddServlet" method="post" id="add_course">
   		<div class="modal fade bs-example-modal-sm" id="myModal_add" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  <div class="modal-dialog modal-sm" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" id="myModalLabel">详细信息</h4>
		      </div>
		      <div class="modal-body">
					<div class="input-group input-group-lg">
						<table>
							<tr>
								<td>账号</td>
								<td><%=t.get(1) %></td>
								<td>姓名</td>
								<td><%=t.get(2) %></td>
							</tr>
							<tr>
								<td>学院</td>
								<td><%=t.get(3) %></td>
								<td>职称</td>
								<td><%=t.get(4) %></td>
							</tr>
							<tr>
								<td>性别</td>
								<td><%=t.get(5) %></td>
								<td>入校时间</td>
								<td>
									<%=t.get(6) %>
								</td>
							</tr>
							<tr>
								<td>登录密码</td>
								<td>
									<input type="text" name="psw" value="<%=t.get(7) %>" required/>
								</td>
								
							</tr>
							
						</table>
					</div>
					<input type="hidden" name="status" value="tea_up_psw" class="form-control"/>
		      </div>
		       
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
		        <input type="submit" class="btn btn-primary" value="更改"/>
		      </div>
		     
		    </div>
		  </div>
		</div>	
	</form>
</body>
<script type="text/javascript">
	$(function(){
		$("#select").click(function(){
			$("#teacher").hide();
			$("#student").show();
		});
		$("#select_teacher").click(function(){
			$("#teacher").show();
			$("#student").hide();
		})
	});
</script>
</html>

