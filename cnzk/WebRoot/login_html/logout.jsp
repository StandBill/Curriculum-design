<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">

</head>

<body>
	<%
   Enumeration<String> names = session.getAttributeNames();

  while (names.hasMoreElements()) 
	{
		String element =(String)names.nextElement();
		session.removeAttribute(element);
	}
    %>
    <script type="text/javascript">
    	top.window.location.href="<%=request.getContextPath()%>/login_html/login.jsp";
    </script>
</body>
</html>
