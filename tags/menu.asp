<!-- #include file="asplite/Config.asp" -->
<!-- #include file="session.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html;charset=gbk"/>
<meta name="Author" content="ice_berg16(Ѱ�εĵ�����)"/>
<link rel="stylesheet" href="style/global.css" type="text/css"/>
<script language="javascript">
function showMenu(menuID,obj)
{
	var menu =	document.getElementById(menuID);
	var target = obj;
	if( document.all )
		d = menu.currentStyle.display;
	else
		d = document.defaultView.getComputedStyle(menu,null).getPropertyValue("display");
	if ( d != "block")
	{
		menu.style.display = "block";
		target.style.backgroundImage = "url(style/images/min.gif)";

	}
	else
	{
		menu.style.display = "none";
		target.style.backgroundImage = "url(style/images/max.gif)";
	}
}
</script>
</head>

<body>
<div id="menu-box">
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu1',this)">��������</a>
	</div>
	<ul id="menu1">
		<li><a href="sysinfo.asp" target="main">ϵͳ��Ϣ</a></li>
		<li><a href="admin.asp?act=setpwd" target="main">�����޸�</a></li>
		<li><a href="/" target="_top">������վ</a></li>
		<li><a href="index.asp?act=logout" target="_top">�˳�ϵͳ</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu2',this)">���Ź���</a>
	</div>
	<ul id="menu2">
		<li><a href="news.asp?act=save" target="main">�������</a></li>
		<li><a href="news.asp" target="main">���Ź���</a></li>
		<li><a href="sort.asp?tbl=news" target="main">�������</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu3',this)">��Ʒ����</a>
	</div>
	<ul id="menu3">
		<li><a href="product.asp?act=save" target="main">��Ӳ�Ʒ</a></li>
		<li><a href="product.asp" target="main">��Ʒ����</a></li>
		<li><a href="sort.asp?tbl=product" target="main">��Ʒ�������</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu6',this)">�������</a>
	</div>
	<ul id="menu6">
		<li><a href="link.asp" target="main">��������</a></li>
		<li><a href="message.asp" target="main">���԰�</a></li>
		<li><a href="page.asp" target="main">ͼ��ҳ��</a></li>
		<li><a href="backup.asp" target="main">���ݱ���</a></li>
		<li><a href="explorer.asp" target="main">��Դ������</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu8',this)">�ʻ�����</a>
	</div>
	<ul id="menu8">
		<li><a href="admin.asp" target="main">�ʻ�����</a></li>
	</ul>
</div>
</div>
</body>
</html>