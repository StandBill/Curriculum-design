<%@ page language="java" import="java.util.*,model.*,database.*,dao.*,dao.impl.*,page.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
	String pageStr = request.getParameter("page"); 
	DBOperator db = new DBOperator();
	int count;
	int num = 8;
	int currentPage = 1; 
	if (pageStr != null&&!pageStr.equals("0")) 
		currentPage = Integer.parseInt(pageStr); 
	Map<Integer,Object> s = new HashMap<Integer,Object>();
	UserDaoImpl admin = new UserDaoImpl();
	String sql="";
	ArrayList<HashMap<Integer,Object>> semester;
	sql = "SELECT s.sem_id,s.sem_name,s2.ma_status,s2.pub_status,s2.start,s2.end FROM semester s,status s2 "+
			"WHERE s.sem_id=s2.sem_id and '2'=? ORDER BY s.sem_id desc limit "+(currentPage - 1)*num+","+num;
	String []param={"2"};
	semester = admin.getList(sql,param);
	count = db.getCounts("SELECT s.sem_id,s.sem_name,s2.ma_status,s2.pub_status,s2.start,s2.end FROM semester s,status s2 "+
			"WHERE s.sem_id=s2.sem_id and '2'=? ORDER BY s.sem_id desc",param);
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
    <title>admin</title>
    <style>
    	.modal-body td{width:200px;height:40px;text-align:center;}
		.modal-body td select{width:200px;height:30px;text-align:center;}
		.modal-body td input[type=text]{width:200px;height:30px;text-align:center;}
    </style>
  </head>
  
  <body onload="getData('semester','ser_sem')">
   	
     <div>
   	 	<span style="font-family: '黑体'; font-size: 14px; white-space: nowrap;">您的位置:&nbsp;&nbsp;选课设置</span>
    </div>
    <div class="content_banner">
        <span>搜索</span>
    </div>

    <!--搜索框-->
    <div class="search">
        <form name="search" id="search" style="height: 60px;" action="#" method="post">
            <table style="width:100%">
                <tbody><tr><td style="width: 20px;">学期:</td>
                <td style="width: 35px; text-align: left;">
                    <select id="ser_sem"></select>
                </td>
                <td style="width: 20px;">公选课开放:</td>
                <td style="width: 50px; text-align: left;">
                    <input type="radio" name="ser_public" value="是"/>是
					<input type="radio" name="ser_public" value="否" checked="checked"/>否
                </td>
                
                <td style="width: 25px;">专业课开放:</td>
                <td style="width: 50px; text-align: left;">
                	<input type="radio" name="ser_major" value="是"/>是
					<input type="radio" name="ser_major" value="否" checked="checked"/>否
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
            </tbody></table>
        </form>
    </div>
    <div style="width:100%;height:80%;overflow-y: auto;">
    <form id="form_content" name="form_content" method="post" action="#">
        <table id="tb_content">
            <tr>
                <td>学期编号</td>
                <td>学期</td>
                <td>公选课是否开放</td>
                <td>专业课是否开放</td>
                <td>开始时间</td>
                <td>结束时间</td>
                <td>操作</td>
            </tr>
            <!--数据放10行-->
            <%
            	for(int i = 0;i < semester.size();i ++){
            		s = semester.get(i);
            		String update = "";
            		String semid = s.get(1).toString();
            %>
            <tr>
            	<%
            		for(int j = 1;j <= s.size();j ++){
            			update += s.get(j)+","; 
            	 %>
                <td><%=s.get(j) %></td>
                 <%} %>
                <td>
                <!-- Button trigger modal -->
				<button type="button" class="btn btn-primary" onclick="func('<%=update %>')" data-toggle="modal" id="" name="myModal" data-target="#myModal">
				  修改
				</button>
                <a class="btn btn-warning btn-lg" href="AddServlet?status=ad_del_sem&sem_id=<%=semid %>" onclick="if(!window.confirm('确定删除??')){return false;}">删除</a><br/>
                </td>
            </tr>
		 	<%} %>
		 	
            <tr>
                <td style="align: right;" colspan="7">
                    <div class="yema">
                        <a href="${pageContext.request.contextPath}/admin_html/course_setting.jsp?page=<%=(currentPage - 1)%>"><img src="image/before.png"></a>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">当前第<%=currentPage %>页</span>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">共<%=pageCount %>页</span>
                        <a href="${pageContext.request.contextPath}/admin_html/course_setting.jsp?page=<%=(currentPage + 1)%>"><img src="image/next.png"></a>
                    </div>
                </td>
            </tr>
        </table>
    </form>
    </div>
    <form action="AddServlet" method="get" id="update_semester">
    <div class="modal fade bs-example-modal-sm" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog modal-sm" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">修改学期信息</h4>
	      </div>
	      <div class="modal-body">
	       <div class="input-group input-group-lg">
				<table>
					<tr>
						<td>编号</td>
						<td></td>
					</tr>
					<tr>
						<td>学期</td>
						<td><input type="text" name="add_sem" id="edit_sem" class="form-control"/></td>
					</tr>
					
					<tr>
						<td>公选课</td>
						<td>
							<input type="radio" name="public" value="是"/>是
							<input type="radio" name="public" value="否" checked="checked"/>否
						</td>
					</tr>
					<tr>
						<td>专业课</td>
						<td>
							<input type="radio" name="major" value="是"/>是
							<input type="radio" name="major" value="否" checked="checked"/>否
						</td>
					</tr>
					<tr>
						<td>起始时间</td>
						<td><input type="text" name="date1" id="editdate1" class="form-control" onclick="laydate()" /></td>
					</tr>
					<tr>
						<td>结束时间</td>
						<td><input type="text" name="date2" id="editdate2" class="form-control" onclick="laydate()" /></td>
					</tr>
				</table>
				<input type="hidden" name="status" value="ad_up_sem"/>
				<input type="hidden" name="sem_id" id="sem_id" />
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
    
    
    <form action="AddServlet" method="post" id="add_semster">
    <div class="modal fade bs-example-modal-sm" id="myModal_add" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog modal-sm" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">添加学期信息</h4>
	      </div>
	      <div class="modal-body">
				<div class="input-group input-group-lg">
					<table>
						<tr>
							<td>编号</td>
							
							<td><input type="text" name="id" class="form-control"/></td>
						</tr>
						<tr>
							<td>学期</td>
							<td><input type="text" name="add_sem" id="add_sem" class="form-control"/></td>
						</tr>
						
						<tr>
							<td>公选课</td>
							<td>
								<input type="radio" name="public" value="是"/>是
								<input type="radio" name="public" value="否" checked="checked"/>否
							</td>
						</tr>
						<tr>
							<td>专业课</td>
							<td>
								<input type="radio" name="major" value="是"/>是
								<input type="radio" name="major" value="否" checked="checked"/>否
							</td>
						</tr>
						<tr>
							<td>起始时间</td>
							<td><input type="text" name="date1" id="date1" class="form-control" onclick="laydate()" /></td>
						</tr>
						<tr>
							<td>结束时间</td>
							<td><input type="text" name="date2" id="date2" class="form-control" onclick="laydate()" /></td>
						</tr>
					</table>
				</div>
				<input type="hidden" name="status" value="add_semester" class="form-control"/>
	      </div>
	       
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	        <input type="submit" class="btn btn-primary" value="提交" />
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
		$(tds[1]).html(arr[0]);
		inputs[8].value = arr[0];
		inputs[0].value = arr[1];
		$(":radio[name='major'][value="+arr[2]+"]").attr("checked","checked");
		$(":radio[name='public'][value="+arr[3]+"]").attr("checked","checked");
		inputs[5].value = arr[4];
		inputs[6].value = arr[5];   
  	}
  	function getData(item,obj){
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
					$("#"+obj).append("<option value='"+txt[i]+"'>"+txt[i]+"</option>");
				}
			}
		}
		xhr.open("POST","AJServlet",true);
		xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xhr.send("status="+item);
	}
  	$("#ser_sem").change(function(){
		$("#tb_content tr").not(":first,:last").hide().filter(":contains("+$(this).val()+")").show();
	});
	$("#ser_btn").click(function(){
		/* if(id!=""&&name==""){
			$("#tb_content tr").not(":first").hide().filter(":contains("+id+")").show();
		}else if(id==""&&name!=""){
			$("#tb_content tr").not(":first").hide().filter(":contains("+name+")").show();
		}else if(id==""&&name==""){ */
			$("#tb_content tr").show();
		/* }
		$("#ser_id").val("");
		$("#ser_name").val(""); */
	});
  </script>
</html>
