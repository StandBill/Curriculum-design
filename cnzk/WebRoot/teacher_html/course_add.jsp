<%@ page language="java" import="java.util.*,database.*,dao.*,dao.impl.*,model.*,page.*,java.text.*" pageEncoding="utf-8"%>
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
	sql = "SELECT c.c_id,c.c_name,c.c_numbers,tt.week_begin,tt.week_end,tt.weekday,sec.sec_name,clr.name,ct.ct_name,d.name,c.period,c.credit "+
			"from course c,course_type ct,timetable tt,sem_course sc,section sec,classroom clr,time_classroom tclr,degress d,semester sem "+
			"where c.ct_id=ct.ct_id AND c.c_id=sc.c_id AND tt.time_id=sc.time_id AND tt.sec_id=sec.sec_id AND clr.clr_id=tclr.clr_id "+
			"and tt.time_id=tclr.time_id and sc.d_id=d.d_id AND sc.sem_id=sem.sem_id AND sem.sem_name=? and sc.t_id=? limit "+(currentPage - 1)*num+","+num;
	String []param={semester.substring(0, semester.length()-1),uid};
	course = user.getList(sql,param);
	count = db.getCounts("SELECT c.c_id,c.c_name,c.c_numbers,tt.week_begin,tt.week_end,tt.weekday,sec.sec_name,clr.name,ct.ct_name,d.name,c.period,c.credit "+
			"from course c,course_type ct,timetable tt,sem_course sc,section sec,classroom clr,time_classroom tclr,degress d,semester sem "+
			"where c.ct_id=ct.ct_id AND c.c_id=sc.c_id AND tt.time_id=sc.time_id AND tt.sec_id=sec.sec_id AND clr.clr_id=tclr.clr_id "+
			"and tt.time_id=tclr.time_id and sc.d_id=d.d_id AND sc.sem_id=sem.sem_id AND sem.sem_name=? and sc.t_id=?",param);
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
  
  <body onload="getData('section','add_sec',''),getData('degress','add_de',''),getData('course_type','add_ct',''),getData('classroom','add_place','')">
  <div>
    	<span style="font-family: 黑体; font-size: 14px; white-space: nowrap;">您的位置:&nbsp;&nbsp;添加课程信息</span>
    	<span style="font-family: 黑体; font-size: 14px; white-space: nowrap;float:right;">当前学期:<%=semester.substring(0, semester.length()-1) %>&nbsp;&nbsp;时间段:<%=start %>--<%=end %></span>
	    <div class="content_banner">
	        <span>搜索</span>
	    </div>
    </div>
    	<!--搜索框-->
    <div class="search">
        <form name="search" id="search" style="height: 60px;" action="#" method="post">
            <table style="width:100%">
                <tbody><tr><td style="width: 20px;">教室:</td>
                <td style="width: 30px; text-align: left;">
                    <input name="classroom" id="ser_id" type="text">
                </td>
                <td style="width: 20px;">课程:</td>
                <td style="width: 30px; text-align: left;"><input name="course" id="ser_name" type="text"></td>
                <td style="width: 35px;">星期:</td>
                <td style="width: 30px; text-align: left;">
                    <input name="date" id="ser_day" style="width: 80px;" type="text"></td>

                <td style="width: 30px;">
                    <button style="border-radius: 6px; border: 0px currentColor; border-image: none; width: 60px; height: 34px; color: white; 
                    font-size: 14px; background-color: #337AB7;"type="button" id="ser_btn">
                    查询</button>
                 </td>
                    <td style="width: 25px; text-align: center;">
                    <button type="button" class="btn btn-primary" data-toggle="modal" name="myModal_add" data-target="#myModal_add">
						  添加课程
					</button>
                    </td>
                </tr>
            </tbody></table>
        </form>
    </div>
    
     <form action="AddServlet" method="post" id="add_course" onsubmit="return checkContent('add','');">
    	<div class="modal fade bs-example-modal-sm" id="myModal_add" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
			  <div class="modal-dialog modal-sm" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        <h4 class="modal-title" id="myModalLabel">添加课程</h4>
			      </div>
			      <div class="modal-body">
						<div class="input-group input-group-lg">
							<table>
								<tr>
									<td>编号</td>
									<td><input type="text" name="c_id" class="form-control" required  onblur="getData('ex_course','',this.value)"/></td>
									<td>名称</td>
									<td><input type="text" name="c_name" id="c_name" required class="form-control"/></td>
								</tr>
								<tr>
									<td>类型</td>
									<td><select name="add_ct" id="add_ct"></select></td>
									<td>专业</td>
									<td><select name="add_de" id="add_de"></select></td>
								</tr>
								<tr>
									<td>学期</td>
									<td><select name="add_sem"><option><%=semester.substring(0, semester.length()-1) %></option></select></td>
									<td>星期</td>
									<td>
										<select name="weekday" id="add_weekday">
											<option>星期一</option>
											<option>星期二</option>
											<option>星期三</option>
											<option>星期四</option>
											<option>星期五</option>
										</select>
									</td>
								</tr>
								<tr>
									<td>开始周数</td>
									<td>
										<select name="add_begin" id="add_begin">
											<option>1</option>
											<option>2</option>
											<option>3</option>
											<option>4</option>
											<option>5</option>
											<option>6</option>
											<option>7</option>
											<option>8</option>
										</select>
									</td>
									<td>结束周数</td>
									<td><select name="add_end" id="add_end">
											<option>9</option>
											<option>10</option>
											<option>11</option>
											<option>12</option>
											<option>13</option>
											<option>14</option>
											<option>15</option>
											<option>16</option>
										</select>
									</td>
								</tr>
								<tr>
									<td>课时</td>
									<td><input type="text" name="period" id="period" required class="form-control" /></td>
									<td>学分</td>
									<td><input type="text" name="credit" id="credit" required class="form-control" /></td>
								</tr>
								<tr>
									<td>地点</td>
									<td><select name="add_place" id="add_place"></select></td>
									<td>节次</td>
									<td><select name="add_sec" id="add_sec"></select></td>
								</tr>
								<tr>
									<td>人数</td>
									<td><input type="text" name="c_numbers" id="c_numbers" required class="form-control" /></td>
									
								</tr>
							</table>
						</div>
						<input type="hidden" name="status" value="tea_add_course" class="form-control"/>
						
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
                <td>编号</td>
                <td>课程名称</td>
                <td>限选</td>
                <td>开始时间</td>
                <td>结束时间</td>
                <td>星期</td>
                <td>节次</td>
                <td>上课地点</td>
                <td>操作</td>
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
            			if(j>=c.size()-3) continue; 
            	 %>
                <td><%=c.get(j) %></td>
                 <%} %>
            	<td>
                <!-- Button trigger modal -->
				<button type="button" class="btn btn-primary" onclick="func('<%=update %>')" data-toggle="modal" name="myModal" data-target="#myModal">
				  修改
				</button>
                <a class="btn btn-warning btn-lg" href="AddServlet?status=tea_del_course&cid=<%=cid %>" onclick="if(!window.confirm('确定删除??')){return false;}">删除</a><br/>
                </td>
        	</tr>
        	<%} %>
            <tr>
                <td style="width: 20px; text-align: left;"><input name="btn_del" id="btn_del" style="border: 0px currentColor; border-image: none; width: 51px; height: 22px; color: white; font-family: 宋体; font-size: 12px; margin-left: 10px;display: none;  background-color: rgb(0, 168, 130);" onclick="window.confirm('确定删除??')" onload="del();" type="button" value="删除">
                </td>
                <td style="align: right;" colspan="8">
                   <div class="yema">
                        <a href="<%=request.getContextPath() %>/teacher_html/course_add.jsp?page=<%=(currentPage - 1)%>"><img src="image/before.png"></a>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">当前第<%=currentPage %>页</span>
                        <span style="font-family: 宋体; font-size: 12px; margin-left: 2px;">共<%=pageCount %>页</span>
                        <a href="<%=request.getContextPath() %>/teacher_html/course_add.jsp?page=<%=(currentPage + 1)%>"><img src="image/next.png"></a>
                    </div>
                </td>
            </tr>
        </table>
    </form>
    </div>
			
    <form action="AddServlet" method="get" id="update_course" onsubmit="return checkContent('edit','cid')">
	<div class="modal fade bs-example-modal-sm" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog modal-sm" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">修改课程信息</h4>
	      </div>
	      <div class="modal-body">
	       <div class="input-group input-group-lg">
				<table>
					<tr>
						<td>编号</td>
						<td  id="editcid"></td>
						<td>名称</td>
						<td><input type="text" name="c_name" id="e_name" required class="form-control"/></td>
					</tr>
					<tr>
						<td>类型</td>
						<td><select name="add_ct" id="edit_ct"></select></td>
						<td>专业</td>
						<td><select name="add_de" id="edit_de"></select></td>
					</tr>
					<tr>
						<td>学期</td>
						<td><select name="add_sem"><option><%=semester.substring(0, semester.length()-1) %></option></select></td>
						<td>星期</td>
						<td>
							<select name="weekday" id="edit_weekday">
								<option>星期一</option>
								<option>星期二</option>
								<option>星期三</option>
								<option>星期四</option>
								<option>星期五</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>开始周数</td>
						<td>
							<select name="add_begin" id="edit_begin">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
							</select>
						</td>
						<td>结束周数</td>
						<td><select name="add_end" id="edit_end">
								<option>9</option>
								<option>10</option>
								<option>11</option>
								<option>12</option>
								<option>13</option>
								<option>14</option>
								<option>15</option>
								<option>16</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>课时</td>
						<td><input type="text" name="period" id="editperiod" required class="form-control" /></td>
						<td>学分</td>
						<td><input type="text" name="credit" id="editcredit" required class="form-control" /></td>
					</tr>
					<tr>
						<td>地点</td>
						<td><select name="add_place" id="edit_place"></select></td>
						<td>节次</td>
						<td><select name="add_sec" id="edit_sec"></select></td>
					</tr>
					<tr>
						<td>人数</td>
						<td><input type="text" name="c_numbers" id="edit_numbers" required class="form-control" /></td>
						
					</tr>
				</table>
				<input type="hidden" name="c_id" />
				<input type="hidden" name="status" value="tea_up_course"/>
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
  		var c_name = arr[0];
  		var clr_id = arr[1];
		var begin = arr[2];
		var end = arr[3];
		var clr_name = arr[4];
		var c_id = arr[5];
		var myModal = document.getElementById("myModal");
		
		var tds = myModal.getElementsByTagName("td");
		var inputs = myModal.getElementsByTagName("input");
		tds[1].innerHTML = c_name;
		inputs[0].value = arr[1];
		inputs[1].value = arr[10];
		inputs[2].value = arr[11];
		inputs[3].value = arr[2];
		inputs[4].value = arr[0];
		$("select#edit_weekday").val(arr[5]);
		$("select#edit_begin").val(arr[3]);
		$("select#edit_end").val(arr[4]);
		$("select#edit_place").val(arr[7]);
		$("select#edit_sec").val(arr[6]);
		$("select#edit_ct").val(arr[8]);
		$("select#edit_de").val(arr[9]);
  	}
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
	function checkContent(type,data){
		var begin = $("#"+type+"_begin").val();
		var end = $("#"+type+"_end").val();
		var weekday = $("#"+type+"_weekday").val();
		var section = $("#"+type+"_sec").val();
		var place = $("#"+type+"_place").val();
		
		var xhr,txt;
		if(window.XMLHttpRequest){
			xhr = new XMLHttpRequest();
		}else if(window.ActiveXObject){
			xhr = new ActiveXOject("Microsoft.XMLHTTP");
		}
		xhr.onreadystatechange=function(){
			if(xhr.readyState==4&&xhr.status==200){
				txt = xhr.responseText;
			}
		}
		xhr.open("POST","AJServlet",false);
		xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		if(data==""){
			xhr.send("status=ex_clr&begin="+begin+"&end="+end+"&weekday="+weekday+
			"&section="+section+"&clr="+place+"&cid=");
		}else if(data=="cid"){
			xhr.send("status=ex_clr&begin="+begin+"&end="+end+"&weekday="+weekday+
			"&section="+section+"&clr="+place+"&cid="+$("#editcid").text());
		}
		
		if(txt=="ok"){
			return true;
		}else{
			alert(txt);
			return false;
		}
	}
	$("#ser_btn").click(function(){
		var id = $("#ser_id").val();
		var name = $("#ser_name").val();
		var day = $("#ser_day").val();
		if(id!=""&&name==""){
			$("#tb_content tr").not(":first,:last").hide().filter(":contains("+id+")").show();
		}else if(id==""&&name!=""){
			$("#tb_content tr").not(":first,:last").hide().filter(":contains("+name+")").show();
		}else if(day!=""){
			$("#tb_content tr").not(":first,:last").hide().filter(":contains("+day+")").show();
		}else if(id==""&&name==""){
			$("#tb_content tr").show();
		}
		$("#ser_id").val("");
		$("#ser_name").val("");
		$("#ser_day").val("");
	});
  </script>
</html>