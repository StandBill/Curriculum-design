<%@ page language="java" import="java.util.*,model.*,dao.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>admin</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css" />

    <link href="${pageContext.request.contextPath}/css/jquery-ui.css" rel="stylesheet">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-2.1.3.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/laydate/laydate.js"></script>
    <script src="${pageContext.request.contextPath}/js/new_model_funcs.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/js/user_model2_checkbox.js" type="text/javascript"></script>
    <style>
    	#student,#teacher{position:absolute;top:50px;left:80px;width:100%;width: 93%;height: 89%;}
    </style>
</head>
<body>
	<div class="topMenu">
       <table class="tb_top">
           <tr>
               <td style="width: 60px;text-align: left">
                   <span>管理员</span>
               </td>
               <td style="width: 20px;"></td>
               <td style="width: 30px;">
                   <img src="${pageContext.request.contextPath}/image/cuttingLine.png"/>
               </td>
               <td style="width: 20px;background-color: #013334;">
                <a href="index.jsp" target="_top" id="person_info">
                    <img src="${pageContext.request.contextPath}/image/message.png" style="width: 35px;height: 31px"/>
                    <br/><span>人员信息</span></a>

               </td>
               <td style="width: 20px;">
                <a href="setting_index.jsp" target="_top" id="advice_info">
                    <img src="${pageContext.request.contextPath}/image/advice.png" style="width: 35px;height: 31px;"/>
                    <br/><span>选课设置</span></a>
                    
               </td>
               <td style="width: 30px;">
                   <img src="${pageContext.request.contextPath}/image/cuttingLine.png"/>
               </td>
               <td  style="width: 60px;text-align: right;padding-right: 33px">
                  <p><%=request.getSession().getAttribute("u_name") %></p>
                  <p><a href="${pageContext.request.contextPath}/login_html/logout.jsp" id="logout">退出</a></p>
              </td>
          </tr>

         </table>
     </div>

      <div class="leftMenu">
       <ul class="ul_left">
           <li>
               <a id="select" onclick="setLiBgColor('select')" href="javascript:void(0)" target="_top" style="background-color:#232423;">
                   <img width="38" height="26" src="../image/student.png"><br/>
                   学生
               </a> 
           </li>
           <li>
               <a id="select_teacher" onclick="setLiBgColor('select_teacher')" href="javascript:void(0)" target="_top">
                   <img width="35" height="26" src="../image/teacher.png"><br/>
                   教师
               </a> 
           </li>
   		</ul>
	</div>
	<div id="student">
        <iframe id="student_info" src="student.jsp" width="99%" height="98%" style="border:0"></iframe>
    </div>
     <div id="teacher" style="display:none;">
        <iframe id="teacher_info" src="teacher_info.jsp" width="99%" height="98%" style="border:0"></iframe>
    </div> 
	
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

