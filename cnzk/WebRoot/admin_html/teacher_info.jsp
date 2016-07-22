<%@ page language="java" import="java.util.*,model.*,database.*,dao.*,page.*,dao.impl.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/stu_course_sys";
%>
<%
	String pageStr = request.getParameter("page"); 
	DBOperator db = new DBOperator();
	int count;
	int num = 10;
	int currentPage = 1; 
	if (pageStr != null&&!pageStr.equals("0")) 
		currentPage = Integer.parseInt(pageStr); 
	Map<Integer,Object> t = new HashMap<Integer,Object>();
	UserDaoImpl admin = new UserDaoImpl();
	String sql="";
	ArrayList<HashMap<Integer,Object>> teacher;
	sql = "SELECT t.t_id,t.name,c.col_name,ti.name,t.reg_date,t.sex from teacher t,college c,title ti where t.title_id=ti.title_id "+
			"AND c.col_id=t.col_id and '2'=? limit "+(currentPage - 1)*num+","+num;
	String []param={"2"};
	teacher = admin.getList(sql,param);
	count = db.getCounts("SELECT t.t_id,t.name,c.col_name,ti.name,t.reg_date,t.sex from teacher t,college c,title ti where t.title_id=ti.title_id "+
						"AND c.col_id=t.col_id and '2'=?",param);
	int pageCount = count % num==0?count/num:count/num+1;
	PageUtil pUtil = new PageUtil(5, count, currentPage); 
	currentPage = pUtil.getCurrentPage();
	
 %>
<!DOCTYPE HTML>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <base href="<%=basePath%>">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.12.3.min.js"></script>
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
    	.modal-body td{width:200px;height:40px;text-align:center;}
		.modal-body td select{width:200px;height:30px;text-align:center;}
		.modal-body td input[type=text]{width:200px;height:30px;text-align:center;}
    </style>
    <title>admin</title>
  </head>
  
  <body onload="getData('college','college',''),getData('title','title','')">
   
    <div>
    <span style="font-family: '黑体'; font-size: 14px; white-space: nowrap;">您的位置:&nbsp;&nbsp;系统人员信息管理</span>
    <div class="content_banner">
        <span>搜索</span>
    </div>

    <!--搜索框-->
    <div class="search">
        <form name="search" id="search" style="height: 60px;" action="#" method="post">
            <table style="width:100%">
                <tr>
	                <td style="width: 20px;">账号:</td>
	                <td style="width: 30px; text-align: left;"><input name="ser_id" id="ser_id" type="text"></td>
	                <td style="width: 20px;">姓名:</td>
	                <td style="width: 30px; text-align: left;"><input name="name" id="ser_name" type="text"></td>
	                <td style="width: 20px;">学院:</td>
	                <td style="width: 50px; text-align: left;"><select id="ser_college" name="college"></select></td>
	                <td style="width: 20px;">职称:</td>
	                <td style="width: 50px; text-align: left;"><select id="ser_title" name="title"></select></td>
	                <td style="width: 35px;">注册日期:</td>
	                <td style="width: 40px; text-align: left;">
	                    <input name="date" id="date" style="width: 70px;" onclick="laydate()" type="text" readonly="readonly">
	                    <img width="16" height="16" style="margin: 0px 0px 0px -25px; vertical-align: middle;" src="image/calendar.png">
	                </td>
	                <td style="width: 30px;">
	                    <button style="border-radius: 6px; border: 0px currentColor; border-image: none; width: 60px; height: 34px; color: white; 
	                    font-size: 14px; background-color: #337AB7;" type="button" id="ser_btn">查询</button>
	                </td>
                    <td style="width: 25px; text-align: center;">
                    <button type="button" class="btn btn-primary" data-toggle="modal" name="myModal_add" data-target="#myModal_add">
						  添加
					</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    
     <form action="AddServlet" method="post" id="add_teacher">
    <div class="modal fade bs-example-modal-sm" id="myModal_add" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog modal-sm" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">添加教师</h4>
	      </div>
	      <div class="modal-body">
				<div class="input-group input-group-lg">
					<table>
						<tr>
							<td>编号</td>
							<td><input type="text" name="id" class="form-control"/></td>
						</tr>
						<tr>
							<td>姓名</td>
							<td><input type="text" name="t_name" id="t_name" class="form-control"/></td>
						</tr>
						<tr>
							<td>系别</td>
							<td><select id="add_college" name="college"></select></td>
						</tr>
						<tr>
							<td>职称</td>
							<td><select id="add_title" name="title"></select></td>
						</tr>
						<tr>
							<td>性别</td>
							<td>
								<input type="radio" name="sex" value="male" checked="checked"/>男
								<input type="radio" name="sex" value="female"/>女
							</td>
						</tr>
						<tr>
							<td>入校时间</td>
							<td><input type="text" name="date" id="add_date" class="form-control" onclick="laydate()" /></td>
						</tr>
					</table>
				</div>
				<input type="hidden" name="status" value="ad_add_tea" class="form-control"/>
				
	      </div>
	       
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	        <input type="submit" class="btn btn-primary" value="提交"/>
	      </div>
	     
	    </div>
	  </div>
	</div>	
	</form>
    
    <div style="width:100%;height:80%;overflow-y: auto;">
    <form id="form_content" name="form_content" method="post" action="#">
        <table id="tb_content">
            <tr>
                <td>账号</td>
                <td>姓名</td>
                <td>学院</td>
                <td>职称</td>
                <td>入校时间</td>
                <td>操作</td>
            </tr>
            <!--数据放10行-->
           <% 
            	 for(int i = 0;i < teacher.size();i ++){
            		t = teacher.get(i);
            		String tid = t.get(1).toString(); 
            		String update = "";
            %> 
            <tr>
                <%
            		for(int j = 1;j <= t.size();j ++){
            			update += t.get(j)+","; 
            			if(j == t.size()) continue;
            	 %>
                <td><%=t.get(j) %></td>
                 <%} %>
                <td>
                <button type="button" class="btn btn-primary" onclick="func('<%=update %>')" data-toggle="modal" id="" name="myModal" data-target="#myModal">
				  修改
				</button>
                <a class="btn btn-warning btn-lg" href="AddServlet?status=ad_del_tea&tid=<%=tid %>" onclick="if(!window.confirm('确定删除??')){return false;}">删除</a><br/>
                </td>
            </tr>
            <%} %>
            
        
            <tr>
               
                <td style="align: right;" colspan="6">
                   <div class="yema">
                        <a href="<%=request.getContextPath() %>/admin_html/teacher_info.jsp?page=<%=(currentPage - 1)%>"><img src="image/before.png"></a>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">当前第<%=currentPage %>页</span>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">共<%=pageCount %>页</span>
                        <a href="<%=request.getContextPath() %>/admin_html/teacher_info.jsp?page=<%=(currentPage + 1)%>"><img src="image/next.png"></a>
                    </div> 
                </td>
            </tr>
        </table>
    </form>
    </div>
</div>
  </body>
 
       <form action="AddServlet" method="get" id="update_student">
		<div class="modal fade bs-example-modal-sm" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  <div class="modal-dialog modal-sm" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" id="myModalLabel">修改教师信息</h4>
		      </div>
		      <div class="modal-body">
		       <div class="input-group input-group-lg">
					<table>
						<tr>
							<td>编号</td>
							<td></td>
						</tr>
						<tr>
							<td>姓名</td>
							<td><input type="text" name="t_name" id="tt_name" class="form-control"/></td>
						</tr>
						<tr>
							<td>系别</td>
							<td><select id="edit_college" name="college"></select></td>
						</tr>
						<tr>
							<td>职称</td>
							<td><select id="edit_title" name="title"></select></td>
						</tr>
						<tr>
							<td>性别</td>
							<td>
								<input type="radio" name="sex" value="male"/>男
								<input type="radio" name="sex" value="female"/>女
							</td>
						</tr>
						<tr>
							<td>入校时间</td>
							<td><input type="text" name="date" id="edit_date" class="form-control" onclick="laydate()" /></td>
						</tr>
					</table>
					<input type="hidden" name="status" value="ad_up_tea"/>
					<input type="hidden" name="t_id" id="student_id"/>
				</div>
					
		      </div>
		       
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
		        <input type="submit" class="btn btn-primary" value="保存" />
		      </div>
		     
		    </div>
		  </div>
		</div>	
	</form>
<script>
  	function func(update){
  		var arr = new Array();
  		arr = update.split(",");
		var myModal = document.getElementById("myModal");
		var tds = myModal.getElementsByTagName("td");
		var inputs = myModal.getElementsByTagName("input");
		tds[1].innerHTML = arr[0];
		inputs[0].value = arr[1];
		inputs[3].value=arr[4];
		inputs[5].value=arr[0];
		
		$("select#edit_college").val(arr[2]);
		$("select#edit_title").val(arr[3]);
		$(":radio[name=sex][value="+arr[5]+"]").attr("checked","checked");
  	}
  	function getData(item,obj,data){
  		$("select[name="+obj+"]").each(function(){
			$(this).empty();
		});
		var xhr;
		if(window.XMLHttpRequest){
			xhr = new XMLHttpRequest();
		}else if(window.ActiveXObject){
			xhr = new ActiveXOject("Microsoft.XMLHTTP");
		}
		xhr.onreadystatechange=function(){
			if(xhr.readyState==4&&xhr.status==200){
				var txt = xhr.responseText.split(",");
				for(var i = 0;i < txt.length;i++){
					$("select[name="+obj+"]").each(function(){
						$(this).append("<option value='"+txt[i]+"'>"+txt[i]+"</option>");
					});
				}
			}
		}
		xhr.open("POST","AJServlet",true);
		xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xhr.send("status="+item+"&data="+data);
	}
	$("#ser_college").change(function(){
		if($(this).val()=="全校级"){
			$("#tb_content tr").show();
		}else{
			$("#tb_content tr").not(":first").hide().filter(":contains("+$(this).val()+")").show();
		}
	});
	$("#ser_title").change(function(){
		$("#tb_content tr").not(":first,:last").hide().filter(":contains("+$(this).val()+")").show();
	});
	$("#ser_btn").click(function(){
		var id = $("#ser_id").val();
		var name = $("#ser_name").val();
		if(id!=""&&name==""){
			$("#tb_content tr").not(":first,:last").hide().filter(":contains("+id+")").show();
		}else if(id==""&&name!=""){
			$("#tb_content tr").not(":first,:last").hide().filter(":contains("+name+")").show();
		}else if(id==""&&name==""){
			$("#tb_content tr").show();
		}
		$("#ser_id").val("");
		$("#ser_name").val("");
	});
  </script>
</html>
