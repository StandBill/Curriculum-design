<%@ page language="java" import="java.util.*,database.*,dao.*,dao.impl.*,model.*,page.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<% 	
	String uid = request.getSession().getAttribute("u_id").toString();
	String pageStr = request.getParameter("page"); 
	DBOperator db = new DBOperator();
	int count;
	int num = 8;
	int currentPage = 1; 
	if (pageStr != null&&!pageStr.equals("0")) 
		currentPage = Integer.parseInt(pageStr); 
	Map<Integer,Object> c = new HashMap<Integer,Object>();
	UserDaoImpl user = new UserDaoImpl();
	String semester = user.getName("select sem_name from semester ORDER BY sem_id desc LIMIT 0,1");
	String start = user.getName("select start from status ORDER BY sem_id desc LIMIT 0,1");
	String end = user.getName("select end from status ORDER BY sem_id desc LIMIT 0,1");
	String sql="";
	ArrayList<HashMap<Integer,Object>> course;
	sql = "SELECT sem.sem_id,sem.sem_name,c.c_id,c.c_name,c.c_numbers,sc.chosen,(c.c_numbers-sc.chosen),tt.week_begin,tt.week_end,tt.weekday,sec.sec_name,clr.name,ct.ct_name,d.name,"+
			"c.period,c.credit from course c,course_type ct,timetable tt,sem_course sc,section sec,classroom clr,time_classroom tclr,degress d,semester sem "+
			"where c.ct_id=ct.ct_id AND c.c_id=sc.c_id AND tt.time_id=sc.time_id AND tt.sec_id=sec.sec_id AND clr.clr_id=tclr.clr_id "+
			"and tt.time_id=tclr.time_id and sc.d_id=d.d_id AND sc.sem_id=sem.sem_id and sc.t_id=? order by sem.sem_id desc limit "+(currentPage - 1)*num+","+num;
	String []param={uid};
	course = user.getList(sql,param);
	count = db.getCounts("SELECT sem.sem_id,sem.sem_name,c.c_id,c.c_name,c.c_numbers,sc.chosen,(c.c_numbers-sc.chosen),tt.week_begin,tt.week_end,tt.weekday,sec.sec_name,clr.name,ct.ct_name,d.name,"+
			"c.period,c.credit from course c,course_type ct,timetable tt,sem_course sc,section sec,classroom clr,time_classroom tclr,degress d,semester sem "+
			"where c.ct_id=ct.ct_id AND c.c_id=sc.c_id AND tt.time_id=sc.time_id AND tt.sec_id=sec.sec_id AND clr.clr_id=tclr.clr_id "+
			"and tt.time_id=tclr.time_id and sc.d_id=d.d_id AND sc.sem_id=sem.sem_id and sc.t_id=? order by sem.sem_id desc",param);
	int pageCount = count % num==0?count/num:count/num+1;
	PageUtil pUtil = new PageUtil(5, count, currentPage); 
	currentPage = pUtil.getCurrentPage();
	
%>
<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'course.jsp' starting page</title>
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
		
	</style>
  </head>
  
  <body onload="getData('semester','ser_sem','')">
    <div>
    	<span style="font-family: 黑体; font-size: 14px; white-space: nowrap;">您的位置:&nbsp;&nbsp;已开课程信息</span>
    	<span style="font-family: 黑体; font-size: 14px; white-space: nowrap;float:right;">当前学期:<%=semester.substring(0, semester.length()-1) %>&nbsp;&nbsp;时间段:<%=start %>--<%=end %></span>
	    <div class="content_banner">
	        <span>搜索</span>
	    </div>
    </div>
    	<!--搜索框-->
    <div class="search">
        <form name="search" id="search" style="height: 60px;" action="#" method="post">
            <table style="width:100%">
            <tbody><tr>
                <td style="width: 35px;">学期:</td>
                <td style="width: 30px; text-align: left;">
                    <select id="ser_sem" name="ser_sem"></select>
                </td>
                <td style="width: 20px;">课程:</td>
                <td style="width: 30px; text-align: left;"><input name="course" id="ser_name" type="text"></td>

                <td style="width: 30px;">
                    <button style="border-radius: 6px; border: 0px currentColor; border-image: none; width: 60px; height: 34px; color: white; 
                    font-size: 14px; background-color: #337AB7;"type="button" id="ser_btn">
                    查询</button>
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
                <td>编号</td>
                <td>课程名称</td>
                <td>限选</td>
                <td>已选</td>
                <td style="width:141px;">操作</td>
            </tr>
            <%
            	for(int i = 0;i < course.size();i ++){
            		c = course.get(i);
            		String update = "";
            		String cid = c.get(1).toString();
            %>
            <tr>
            	<%
            		for(int j = 1;j <= c.size();j ++){
            			update += c.get(j)+",";
            			if(j>=c.size()-9) continue; 
            	 %>
                <td><%=c.get(j) %></td>
                 <%} %>
            	<td>
                <!-- Button trigger modal -->
				<button type="button" class="btn btn-primary" onclick="func('<%=update %>')" data-toggle="modal" name="myModal" data-target="#myModal">
				  详情
				</button>
                </td>
        	</tr>
        	<%} %>
            <tr>
                <td style="align: right;" colspan="7">
                   <div class="yema">
                        <a href="<%=request.getContextPath() %>/teacher_html/course.jsp?page=<%=(currentPage - 1)%>"><img src="image/before.png"></a>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">当前第<%=currentPage %>页</span>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">共<%=pageCount %>页</span>
                        <a href="<%=request.getContextPath() %>/teacher_html/course.jsp?page=<%=(currentPage + 1)%>"><img src="image/next.png"></a>
                    </div>
                </td>
            </tr>
        </table>
    </form>
    </div>
			
	<div class="modal fade bs-example-modal-sm" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog modal-sm" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">课程信息</h4>
	      </div>
	      <div class="modal-body">
	       <div class="input-group input-group-lg">
				<table>
					<tr>
						<td>学期编号</td>
						<td></td>
						<td>学期</td>
						<td></td>
					</tr>
					<tr>
						<td>编号</td>
						<td></td>
						<td>名称</td>
						<td></td>
					</tr>
					<tr>
						<td>限选人数</td>
						<td></td>
						<td>已选人数</td>
						<td></td>
					</tr>
					<tr>
						<td>可选人数</td>
						<td></td>
						<td>开始周数</td>
						<td></td>
					</tr>
					<tr>
						<td>结束周数</td>
						<td>
						</td>
						<td>星期</td>
						<td>
						</td>
					</tr>
					<tr>
						<td>节次</td>
						<td></td>
						<td>地点</td>
						<td></td>
					</tr>
					<tr>
						<td>类型</td>
						<td></td>
						<td>专业</td>
						<td></td>
					</tr>
					<tr>
						<td>课时</td>
						<td></td>
						<td>学分</td>
						<td></td>
					</tr>
				</table>
			</div>
				
	      </div>
	       
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	      </div>
	     
	    </div>
	  </div>
	</div>
  </body>
  <script>
  	function func(update){
  		var arr = new Array();
  		arr = update.split(",");
		var myModal = document.getElementById("myModal");
		var tds = myModal.getElementsByTagName("td");
		for(var i = 0;i < tds.length;i ++){
			tds[i*2+1].innerHTML = arr[i];
		}
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
	$("#ser_sem").change(function(){
		$("#tb_content tr").not(":first,:last").hide().filter(":contains("+$(this).val()+")").show();
	});
	$("#ser_btn").click(function(){
		var name = $("#ser_name").val();
		if(name!=""){
			$("#tb_content tr").not(":first,:last").hide().filter(":contains("+name+")").show();
		}else{
			$("#tb_content tr").show();
		}
		$("#ser_name").val("");
	});
  </script>
</html>
