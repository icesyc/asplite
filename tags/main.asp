<!-- #include file="asplite/Config.asp" -->
<!-- #include file="session.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html;charset=GBK"/>
<meta name="Author" content="ice_berg16(Ѱ�εĵ�����)" >
<link rel="stylesheet" href="style/global.css" type="text/css"/>
</head>
<body>
<div class="main-box">
	<div class="head-dark-box">
		��ӭʹ��<%=Config.appName%>
	</div>
	<div class="body-box">
		<span class="red"><%=Session("user_name")%></span> ����, ��ӭ����,���ϴεĵ�¼ʱ���� <span class="red"><%=Session("last_visit")%></span>.
		<p>�������˵����в���.</p>
	</div>
</div>
</body>
</html>
