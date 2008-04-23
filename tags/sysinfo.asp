<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/FileSystem.asp" -->
<!-- #include file="session.asp" -->
<%
'系统环境信息

Dim fso, folder, db, websize, dbsize
Set fso = newFS
Set folder = fso.getFolder(Server.MapPath(IIF(Config.appRoot = "", "/", Config.appRoot)))
websize = sizeCount(folder.Size)
Set db = fso.getFile(Config.dbPath)
dbsize = sizeCount(db.Size)
Set fso		= Nothing
Set folder  = Nothing
Set db		= nothing
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html;charset=GBK"/>
<meta name="Author" content="ice_berg16(寻梦的稻草人)"/>
<link rel="stylesheet" href="style/global.css" type="text/css"/>
<style>
.list-table{
	width:100%;
	border-top:2px solid #6BBAEF;
	font-size:12px;
	font-family:verdana, sans-serif;
	color:#00309C;
}
.list-table td{
	padding:10px;
	border-bottom:1px solid #C6E7FF;
}
</style>
</head>
<body>
<div class="main-box">
	<div class="head-dark-box">
		服务器信息
	</div>
	<div class="white-box">
		<table class="list-table" cellspacing="0">
			<tr>
				<td>服务器环境:</td>
				<td><%=Request.ServerVariables("SERVER_SOFTWARE")%></td>
			</tr>
			<tr>
				<td>服务器域名:</td>
				<td><%=Request.ServerVariables("SERVER_NAME")%></td>
			</tr>
			<tr>
				<td>服务器IP地址:</td>
				<td><%=Request.ServerVariables("LOCAL_ADDR")%></td>
			</tr>
			<tr>
				<td>网站使用空间</td>
				<td><%=websize%></td>
			</tr>
			<tr>
				<td>数据库占用空间:</td>
				<td><%=dbsize%></td>
			</tr>
		</table>
	</div>
</div>
</body>
</html>