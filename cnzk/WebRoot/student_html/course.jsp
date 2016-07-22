<%@ page language="java" import="java.util.*,database.*,dao.*,dao.impl.*,model.*,page.*,java.text.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<% 
	String pageStr = request.getParameter("page"); 
	DBOperator db = new DBOperator();
	String uid = request.getSession().getAttribute("u_id").toString();
	int count;
	int num = 8;
	int currentPage = 1; 
	if (pageStr != null&&!pageStr.equals("0")) 
		currentPage = Integer.parseInt(pageStr); 
	UserDaoImpl user = new UserDaoImpl();
	String semester = user.getName("select sem_name from semester ORDER BY sem_id desc LIMIT 0,1");
	String start = user.getName("select start from status ORDER BY sem_id desc LIMIT 0,1");
	String end = user.getName("select end from status ORDER BY sem_id desc LIMIT 0,1");
	String did = user.getName("select cl.d_id from student s,class cl where s.cl_id=cl.cl_id AND s.s_id='"+uid+"'");
	String sql="";
	ArrayList<HashMap<Integer,Object>> course;
	Map<Integer,Object> c = new HashMap<Integer,Object>();
	sql = "SELECT c.c_id,c.c_name,ct.ct_name,t.name,cc.cc_id,sc.sum,sc.chosen,tt.week_begin,tt.week_end,tt.weekday,sec.sec_name,clr.name,t.t_id "+
		"FROM stu_tea_course stc,stu_course_class_classroom sccc,stu_course_class scc,course_class cc,course_type ct,course c,teacher t,sem_course sc,"+
		"classroom clr,section sec,timetable tt WHERE stc.cc_id=cc.cc_id AND sccc.cc_id=cc.cc_id AND scc.cc_id=cc.cc_id AND ct.ct_id=c.ct_id AND "+
		"c.c_id=sc.c_id AND t.t_id=sc.t_id AND sc.time_id=tt.time_id AND tt.sec_id=sec.sec_id AND stc.sc_id=sc.sc_id AND sec.sec_id=cc.sec_id AND "+
		"sccc.clr_id=clr.clr_id AND scc.s_id=? and stc.s_id=sccc.s_id AND stc.s_id=scc.s_id AND sccc.s_id=scc.s_id limit "+(currentPage - 1)*num+","+num;
	String []param={uid};
	course = user.getList(sql,param);
	count = db.getCounts("SELECT c.c_id,c.c_name,ct.ct_name,t.name,cc.cc_id,sc.sum,sc.chosen,tt.week_begin,tt.week_end,tt.weekday,sec.sec_name,clr.name,t.t_id "+
		"FROM stu_tea_course stc,stu_course_class_classroom sccc,stu_course_class scc,course_class cc,course_type ct,course c,teacher t,sem_course sc,"+
		"classroom clr,section sec,timetable tt WHERE stc.cc_id=cc.cc_id AND sccc.cc_id=cc.cc_id AND scc.cc_id=cc.cc_id AND ct.ct_id=c.ct_id AND "+
		"c.c_id=sc.c_id AND t.t_id=sc.t_id AND sc.time_id=tt.time_id AND tt.sec_id=sec.sec_id AND stc.sc_id=sc.sc_id AND sec.sec_id=cc.sec_id AND "+
		"sccc.clr_id=clr.clr_id AND scc.s_id=? and stc.s_id=sccc.s_id AND stc.s_id=scc.s_id AND sccc.s_id=scc.s_id",param);
	int pageCount = count % num==0?count/num:count/num+1;
	PageUtil pUtil = new PageUtil(5, count, currentPage); 
	currentPage = pUtil.getCurrentPage();
	String ma = user.getName("select ma_status from status order by sem_id desc limit 0,1");
	String pb = user.getName("select pub_status from status order by sem_id desc limit 0,1");
	Date current = new Date();
	SimpleDateFormat ft = new SimpleDateFormat("YYYY-MM-dd");
	String now = ft.format(current);
%>
<!DOCTYPE HTML>
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>正选结果</title>
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
		#tb_content a:link{color:#7CBFF5;cursor:pointer; }
		#tb_content a:visited{color:#7CBFF5;cursor:pointer; }
		#tb_content a:hover{color:red;cursor:pointer; }
	</style>
  </head>
  
  <body>
    <div>
    	<span style="font-family: 黑体; font-size: 14px; white-space: nowrap;">您的位置:&nbsp;&nbsp;正选结果</span>
    	<span style="font-family: 黑体; font-size: 14px; white-space: nowrap;float:right;">当前学期:<%=semester.substring(0, semester.length()-1) %>&nbsp;&nbsp;时间段:<%=start %>--<%=end %></span>
	    <div class="content_banner">
	        <span>搜索</span>
	    </div>
    </div>
    	<!--搜索框-->
    <div class="search">
        <form name="search" id="search" style="height: 60px;" action="#" method="post">
            <table style="width:100%">
                <tr>
	                <td style="width: 20px;">类型:</td>
	                <td style="width: 20px;"><select name="add_ct" id="add_ct"></select></td>
	                <td style="width: 20px;">教室:</td>
	                <td style="width: 30px; text-align: left;"><input name="classroom" id="ser_id" type="text"></td>
	                <td style="width: 20px;">课程:</td>
	                <td style="width: 30px; text-align: left;">
	                    <input name="date" id="ser_name" style="width: 80px;" type="text">
	                </td>
	
	                <td style="width: 30px;">
	                    <button style="border-radius: 6px; border: 0px currentColor; border-image: none; width: 60px; height: 34px; color: white; 
	                    font-size: 14px; background-color: #337AB7;"type="button" id="ser_btn">
	                    查询</button>
                 </td>
                </tr>
           </table>
        </form>
    </div>
    	
 	<div style="width:100%;height:80%;overflow-y: auto;">
    <form id="form_content" name="form_content" method="post" action="#">
        <table id="tb_content">
            <tr>
            	<td style="width:20px;"></td>
                <td>课程编号</td>
                <td>课程名称</td>
                <td>类型</td>
                <td>任课教师</td>
                <td>上课班级</td>
                <td>限选</td>
                <td>已选</td>
                <td>地点</td>
            </tr>
            <%
            	for(int i = 0;i < course.size();i ++){
            		c = course.get(i);
            		String update = "";
            		String tt = "";
            		String cc = "";
            		String tid = c.get(13).toString();
            		String cid = c.get(1).toString();
            		
            		String tpsql = "SELECT c.c_id,c.c_name,c.c_numbers,c.period,c.credit,ct.ct_name from course c,course_type ct "+
									"where c.ct_id=ct.ct_id and c.c_id=?";
					String []tparr1 = {cid};
					String []tparr2 = {tid};
            		ArrayList<HashMap<Integer,Object>> tp1 = user.getList(tpsql, tparr1);
					Map<Integer,Object> mp1 = tp1.get(0);
					for(int k =1;k <= mp1.size();k++){
						cc += mp1.get(k)+",";
					}
					
					String tpsql2 = "SELECT t.t_id,t.name,t.reg_date,c.col_name,ti.name,t.sex from teacher t,college c,title ti "+
									"WHERE t.col_id=c.col_id AND t.title_id=ti.title_id and t.t_id=?";
					
            		ArrayList<HashMap<Integer,Object>> tp2 = user.getList(tpsql2, tparr2);
					Map<Integer,Object> mp2 = tp2.get(0);
					for(int k =1;k <= mp2.size();k++){
						tt += mp2.get(k)+",";
					}
            %>
            <tr>
            	<td><input type="checkbox" value="<%=c.get(1)%>"/></td>
            	<%
            		for(int j = 1;j <= c.size();j ++){
            			update += c.get(j)+",";
            			if(j>=c.size()-5) continue;
            			else if(j==2){ 
            	 %>
            	<td><a href="javascript:void(0)" onclick="show('<%=cc %>','scourse')" data-toggle="modal" data-target="#scourse"><%=c.get(2) %></a></td>
                <%}else if(j==4){ %>
                <td><a href="javascript:void(0)" onclick="show('<%=tt %>','teacher')" data-toggle="modal" data-target="#teacher"><%=c.get(4) %></a></td>
                <%}else{ %>
                <td><%=c.get(j) %></td>
                 <%} }%>
                <td>[<%=c.get(8) %>-<%=c.get(9) %>周]&nbsp;<%=c.get(10) %>[<%=c.get(11) %>]<%=c.get(12) %></td>
            	
        	</tr>
        	<%} %>
            <tr>
            	<%if(ma.equals("是,")&&pb.equals("是,")&&now.compareTo(end.substring(0, end.length()-1))==-1
  					&&now.compareTo(start.substring(0, start.length()-1))>=0){ %>
			  	<td><a id="delbtn" href="javascript:void(0)" onclick="del()">退选</a></td>
            	<%}else{ %>
            	<td></td>
			  	<%} %>
                <td style="align: right;" colspan="8">
                   <div class="yema">
                        <a href="<%=request.getContextPath() %>/student_html/course.jsp?page=<%=(currentPage - 1)%>"><img src="image/before.png"></a>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">当前第<%=currentPage %>页</span>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">共<%=pageCount %>页</span>
                        <a href="<%=request.getContextPath() %>/student_html/course.jsp?page=<%=(currentPage + 1)%>"><img src="image/next.png"></a>
                    </div>
                </td>
            </tr>
        </table>
    </form>
    </div>
	<div class="modal fade bs-example-modal-sm" id="scourse" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
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
							<td>编号</td>
							<td></td>
							<td>名称</td>
							<td></td>
						</tr>
						<tr>
							<td>限选人数</td>
							<td></td>
							<td>课时</td>
							<td></td>
						</tr>
						<tr>
							<td>学分</td>
							<td></td>
							<td>类型</td>
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
		
		<div class="modal fade bs-example-modal-sm" id="teacher" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		  <div class="modal-dialog modal-sm" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" id="myModalLabel">教师信息</h4>
		      </div>
		      <div class="modal-body">
		       <div class="input-group input-group-lg">
					<table>
						<tr>
							<td>账号</td>
							<td></td>
							<td>姓名</td>
							<td></td>
						</tr>
						<tr>
							<td>入校时间</td>
							<td></td>
							<td>学院</td>
							<td></td>
						</tr>
						<tr>
							<td>职称</td>
							<td></td>
							<td>性别</td>
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
	 function del(){
		var str="";
		var ipt = document.getElementsByTagName("input");
		for(var i in ipt){
			if(ipt[i].type=="checkbox"){
				if(ipt[i].checked){
					str+= "'"+ipt[i].value+"',";
				}
			}
		}
		if(str==""){
			alert("请选择退选课程..");
			return false;
		}else{
			if(!window.confirm("确定退选选定课程??")){
				return false;
			}else{
		  		$("#delbtn").attr("href","AddServlet?status=stu_del_course&cid="+str);
		  		return true;
			}
		}
	}
	function show(update,type){
		var arr = new Array();
  		arr = update.split(",");
  		var myModal = document.getElementById(type);
  		
		
		var tds = myModal.getElementsByTagName("td");
		var ipts = myModal.getElementsByTagName("input");
		
		for(var i = 0;i < tds.length;i ++){
			tds[i*2+1].innerHTML = arr[i];
		} 
	}
	$("#add_ct").change(function(){
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
	window.onload = getData('course_type','add_ct','');
	function getData(item,obj,data){
  		if(obj==""){
	  		if(data!=""){
				var xhr;
				if(window.XMLHttpRequest){
					xhr = new XMLHttpRequest();
				}else if(window.ActiveXObject){
					xhr = new ActiveXOject("Microsoft.XMLHTTP");
				}
				xhr.onreadystatechange=function(){
					if(xhr.readyState==4&&xhr.status==200){
						if(xhr.responseText=="ok"){
						}else{
							alert(xhr.responseText);
						}
					}
				}
				xhr.open("POST","AJServlet",true);
				xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
				xhr.send("status="+item+"&cid="+data);
			}else{}
  		}else{
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
  		
	}
 </script>
</html>
