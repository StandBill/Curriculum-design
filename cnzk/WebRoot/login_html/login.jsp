<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->

    <title>Login</title>
	<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-2.1.3.js"></script>
	<link href="<%=request.getContextPath() %>/css/jquery-ui.css" rel="stylesheet">
    <!-- Bootstrap core CSS -->
    <link href="<%=request.getContextPath() %>/bootstrap-3.3.5-dist/css/bootstrap.min.css" rel="stylesheet">
	<script type="text/javascript" src="<%=request.getContextPath() %>/bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
    <!-- Custom styles for this template -->
    <link href="<%=request.getContextPath() %>/css/signin.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="js/ie8-responsive-file-warning.js"></script><![endif]-->

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <div class="container">

      <form class="form-signin" action="<%=request.getContextPath() %>/LoginServlet" method="post">
        <h2 class="form-signin-heading">Login</h2>
        
        <label for="u_name" class="sr-only">Email address</label>
        <input type="text" name="u_name" id="u_name" class="form-control" placeholder="username" required autofocus>
        <label for="u_psw" class="sr-only">Password</label>
        <input type="password" id="u_psw" name="u_psw" class="form-control" placeholder="Password" required>
        <div class="checkbox">
          <label>
            <input type="checkbox" id="ck" value="remember-me"> Remember me
          </label>
          <select name="status" id="status">
  			<option value="admin">admin</option>
  			<option value="student">student</option>
  			<option value="teacher">teacher</option>
  			</select>
        </div>
        <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button><br>
		${sessionScope.error}
      </form>
    </div> <!-- /container -->


  </body>
  <script>
  	$(function(){
  		var num = localStorage.getItem("lg_num");
  		var psw = localStorage.getItem("lg_psw");
  		var sel = localStorage.getItem("lg_status");
  		
  		if(num!=null&&psw!=null&&sel!=null){
	  		$("#u_name").val(num);
	  		$("#u_psw").val(psw);
	  		$("#status").val(sel);
  		}
  		$("#ck").click(function(){
  			if(this.checked){
  				localStorage.setItem("lg_num", $("#u_name").val());
	  			localStorage.setItem("lg_psw", $("#u_psw").val());
	  			localStorage.setItem("lg_status", $("#status").find(":selected").val());
  			}else{
  				localStorage.removeItem("lg_num");
	  			localStorage.removeItem("lg_psw");
	  			localStorage.removeItem("lg_status");
  			}
  		});
  		
  	})
  	
  </script>
</html>
