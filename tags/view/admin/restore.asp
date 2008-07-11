<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html;charset=GBK"/>
<meta name="Author" content="ice_berg16(寻梦的稻草人)"/>
<link rel="stylesheet" href="/system/style/global.css" type="text/css"/>
</head>
<body>
<div class="main-box">
	<div class="head-dark-box">
		回复留言
	</div>
	<form method="post" action="/system/message.asp?act=edit&id=<%=request("id")%>">
	<div class="white-box">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
  
  <tr>
    <td><div align="center"><%=request("ti")%></div></td>
  </tr>
  <tr>
    <td width="12%"><div align="center">
      <label>
      <textarea name="restore" cols="45" rows="9" id="restore"></textarea>
	  <input type="hidden" name="re_time" value="<%=now()%>">
      </label>
    </div></td>
    </tr>
  <tr>
    <td><div align="center">
      <label>
      <input type="submit" name="Submit" value="提交" />
&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </label>
      <label>
      <input type="reset" name="Submit2" value="重置" />
      </label>
    </div></td>
    </tr>
</table>

	</div>
	</form>
</div>
</body>
</html>
