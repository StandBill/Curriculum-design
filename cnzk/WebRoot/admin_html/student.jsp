<%@ page language="java" import="java.util.*,model.*,database.*,dao.*,dao.impl.*,page.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
	String pageStr = request.getParameter("page"); 
	DBOperator db = new DBOperator();
	int count;
	int num = 10;
	int currentPage = 1; 
	if (pageStr != null&&!pageStr.equals("0")) 
		currentPage = Integer.parseInt(pageStr); 
	Map<Integer,Object> s = new HashMap<Integer,Object>();
	UserDaoImpl admin = new UserDaoImpl();
	String sql="";
	ArrayList<HashMap<Integer,Object>> student;
	sql = "SELECT s.s_id,s.name,cl.col_name,d.name,c.name,s.grade,s.reg_date,s.sex FROM student s,class c,degress d,college cl "+
			"WHERE s.cl_id=c.cl_id AND d.d_id=c.d_id AND d.col_id=cl.col_id and cl.col_id=c.col_id and '2'=? limit "+(currentPage - 1)*num+","+num;
	String []param={"2"};
	student = admin.getList(sql,param);
	count = db.getCounts("SELECT s.s_id,s.name,cl.col_name,d.name,c.name,s.grade,s.reg_date,s.sex FROM student s,class c,degress d,college cl "+
			"WHERE s.cl_id=c.cl_id AND d.d_id=c.d_id AND d.col_id=cl.col_id and cl.col_id=c.col_id and '2'=?",param);
	int pageCount = count % num==0?count/num:count/num+1;
	PageUtil pUtil = new PageUtil(5, count, currentPage); 
	currentPage = pUtil.getCurrentPage();
	
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" href="css/style.css" type="text/css" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-2.1.3.js"></script>
	<link href="<%=request.getContextPath() %>/css/jquery-ui.css" rel="stylesheet">
	<link href="<%=request.getContextPath() %>/bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="<%=request.getContextPath() %>/bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
	<!--[if lt IE 9]>
      <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="<%=request.getContextPath() %>/laydate/laydate.js"></script>
    <script src="<%=request.getContextPath() %>/js/new_model_funcs.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/js/user_model2_checkbox.js" type="text/javascript"></script>
	<style>
    	.modal-body td{width:200px;height:40px;text-align:center;}
		.modal-body td select{width:200px;height:30px;text-align:center;}
		.modal-body td input[type=text]{width:200px;height:30px;text-align:center;}
    </style>
  </head>
  
  <body onload="getData('college','col',''),getData('degress','de',''),getData('class','cl','')">
    <div>
   	 <span style="font-family: 黑体; font-size: 14px; white-space: nowrap;">您的位置:&nbsp;&nbsp;系统人员信息管理</span>
    </div>
    <div class="content_banner">
        <span>搜索</span>
    </div>

    <!--搜索框-->
    <div class="search">
        <form name="search" id="search" style="height: 60px;" action="#" method="post">
            <table style="width:100%">
                <tbody><tr><td style="width: 20px;">账号:</td>
                <td style="width: 35px; text-align: left;"><input name="id" id="ser_id" type="text"></td>
                <td style="width: 20px;">姓名:</td>
                <td style="width: 35px; text-align: left;">
                    <input name="name" id="ser_name" type="text">
                </td>
                <td style="width: 20px;">学院</td>
				<td style="width: 20px;"><select id="ser_col" name="col" onchange="getData('degress','de',this.value)"></select></td>
                <td style="width: 20px;">专业</td>
				<td style="width: 20px;"><select id="ser_de" name="de"></select></td>
                <td style="width: 30px;">
                    <button id="ser_btn" style="border-radius: 6px; border: 0px currentColor; border-image: none; width: 60px; height: 34px; color: white; 
                    font-size: 14px; background-color: #337AB7;" type="button" title="默认查询全部">
                    查询</button>
                 </td>
                   
                    <td style="width: 25px; text-align: center;">
                    	<button type="button" class="btn btn-primary" data-toggle="modal" name="myModal_add" data-target="#myModal_add">
						  添加
						</button>
                    </td>
                </tr>
            </tbody></table>
        </form>
        	
    </div>
     <form action="AddServlet" method="post" id="add_student">
    <div class="modal fade bs-example-modal-sm" id="myModal_add" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog modal-sm" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">添加学生</h4>
	      </div>
	      <div class="modal-body">
				<div class="input-group input-group-lg">
					<table>
						<tr>
							<td>学生编号</td>
							<td><input type="text" name="id" class="form-control"/></td>
						</tr>
						<tr>
							<td>学生姓名</td>
							<td><input type="text" name="stu_name" id="stu_name" class="form-control"/></td>
						</tr>
						<tr>
							<td>学院</td>
							<td><select id="add_col" name="col" onchange="getData('degress','de',this.value)"></select></td>
						</tr>
						<tr>
							<td>专业</td>
							<td><select id="add_de" name="de" onclick="getData('class','cl',this.value)"></select></td>
						</tr>
						<tr>
							<td>班级</td>
							<td><select id="add_cl" name="cl"></select></td>
						</tr>
						<tr>
							<td>年级</td>
							<td><select id="grade" name="grade">
									<option>大一</option>
									<option>大二</option>
									<option>大三</option>
									<option>大四</option>
								</select></td>
						</tr>
						<tr>
							<td>性别</td>
							<td>
								<input type="radio" name="sex" value="male" checked="checked"/>男
								<input type="radio" name="sex" value="female"/>女
							</td>
						</tr>
						<tr>
							<td>注册时间</td>
							<td><input type="text" name="date" id="date" class="form-control" onclick="laydate()" /></td>
						</tr>
					</table>
				</div>
				<input type="hidden" name="status" value="ad_add_stu" class="form-control"/>
				
	      </div>
	       
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	        <input type="submit" class="btn btn-primary" value="提交" />
	      </div>
	     
	    </div>
	  </div>
	</div>	
	</form>
    <div style="width:100%;height:80%;overflow-y: auto;">
    <form id="form_content" name="form_content" method="post" action="#">
        <table id="tb_content">
            <tr>
                <td>学号</td>
                <td>姓名</td>
                <td>学院</td>
                <td>专业</td>
                <td>班级</td>
                <td>年级</td>
                <td>注册时间</td>
                <td>操作</td>
            </tr>
            <!--数据放10行-->
            <%
            	for(int i = 0;i < student.size();i ++){
            		s = student.get(i);
            		String update = "";
            		String sid = s.get(1).toString();
            %>
            <tr>
            	<%
            		for(int j = 1;j <= s.size();j ++){
            			update += s.get(j)+",";
            			if(j==s.size()) continue; 
            	 %>
                <td><%=s.get(j) %></td>
                 <%} %>
                <td>
                <!-- Button trigger modal -->
				<button type="button" class="btn btn-primary" onclick="func('<%=update %>')" data-toggle="modal" name="myModal" data-target="#myModal">
				  修改
				</button>
                <a class="btn btn-warning btn-lg" href="AddServlet?status=ad_del_stu&sid=<%=sid %>" onclick="if(!window.confirm('确定删除??')){return false;}">删除</a><br/>
                </td>
            </tr>
            
		 	<%} %>
		 	
            <tr>
                <td style="align: right;" colspan="8">
                    <div class="yema">
                        <a href="<%=request.getContextPath() %>/admin_html/student.jsp?page=<%=(currentPage - 1)%>"><img src="image/before.png"></a>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">当前第<%=currentPage %>页</span>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">共<%=pageCount %>页</span>
                        <a href="<%=request.getContextPath() %>/admin_html/student.jsp?page=<%=(currentPage + 1)%>"><img src="image/next.png"></a>
                    </div>
                </td>
            </tr>
        </table>
    </form>
    </div>
		
     <form action="AddServlet" method="get" id="update_student">
	<div class="modal fade bs-example-modal-sm" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog modal-sm" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">修改学生信息</h4>
	      </div>
	      <div class="modal-body">
		       <div class="input-group input-group-lg">
					<table>
						<tr>
							<td>学生编号</td>
							<td></td>
						</tr>
						<tr>
							<td>学生姓名</td>
							<td><input type="text" name="stu_name" id="edit_name" class="form-control"/></td>
						</tr>
						<tr>
							<td>学院</td>
							<td><select id="edit_col" name="col" onchange="getData('degress','de',this.value)"></select></td>
						</tr>
						<tr>
							<td>专业</td>
							<td><select id="edit_de" name="de" onclick="getData('class','cl',this.value)"></select></td>
						</tr>
						<tr>
							<td>班级</td>
							<td><select id="edit_cl" name="cl"></select></td>
						</tr>
						<tr>
							<td>年级</td>
							<td>
								<select id="edit_grade" name="edit_grade">
									<option>大一</option>
									<option>大二</option>
									<option>大三</option>
									<option>大四</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>性别</td>
							<td>
								<input type="radio" name="sex" value="male" checked="checked"/>男
								<input type="radio" name="sex" value="female"/>女
							</td>
						</tr>
						<tr>
							<td>注册时间</td>
							<td><input type="text" name="date" id="eidt_date" class="form-control" onclick="laydate()" /></td>
						</tr>
					</table>
					<input type="hidden" name="status" value="ad_up_stu"/>
					<input type="hidden" name="s_id" id="student_id" />
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
</body>
<script>
  	function func(update){
  		var arr = new Array();
  		arr = update.split(",");
		var myModal = document.getElementById("myModal");
		var tds = myModal.getElementsByTagName("td");
		var inputs = myModal.getElementsByTagName("input");
		tds[1].innerHTML = arr[0];
		inputs[0].value = arr[1];
		inputs[3].value = arr[6];
		inputs[5].value = arr[0];
		$("select#edit_col").val(arr[2]);
		$("select#edit_de").val(arr[3]);
		$("select#edit_cl").val(arr[4]);
		$("select#edit_grade").val(arr[5]); 
		$(":radio[name=sex][value="+arr[7]+"]").attr("checked","checked");
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
	$("#ser_col").change(function(){
		if($(this).val()=="全校级"){
			$("#tb_content tr").show();
		}else{
			$("#tb_content tr").not(":first,:last").hide().filter(":contains("+$(this).val()+")").show();
		}
	});
	$("#ser_de").change(function(){
		if($(this).val()=="全校"){
			$("#tb_content tr").show();
		}else{
			$("#tb_content tr").not(":first,:last").hide().filter(":contains("+$(this).val()+")").show();
		}
	});
	$("#ser_btn").click(function(){
		var id = $("#ser_id").val();
		var name = $("#ser_name").val();
		var col = $("#ser_col").val();
		var de = $("#ser_de").val();
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
