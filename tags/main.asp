<!-- #include file="asplite/Config.asp" -->
<!-- #include file="session.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html;charset=GBK"/>
<meta name="Author" content="ice_berg16(寻梦的稻草人)" >
<link rel="stylesheet" href="style/global.css" type="text/css"/>
</head>
<body>
<div class="main-box">
	<div class="head-dark-box">
		欢迎使用<%=Config.appName%>
	</div>
	<div class="body-box">
		<span class="red"><%=Session("user_name")%></span> 您好, 欢迎回来,您上次的登录时间是 <span class="red"><%=Session("last_visit")%></span>.
		<p>请点击左侧菜单进行操作.</p>
	</div>
</div>
</body>
</html>
