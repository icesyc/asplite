<!-- #include file="asplite/Config.asp" -->
<!-- #include file="session.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html;charset=gbk"/>
<meta name="Author" content="ice_berg16(寻梦的稻草人)"/>
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
		<a href="javascript:void(null)" onclick="showMenu('menu1',this)">常规设置</a>
	</div>
	<ul id="menu1">
		<li><a href="sysinfo.asp" target="main">系统信息</a></li>
		<li><a href="admin.asp?act=setpwd" target="main">密码修改</a></li>
		<li><a href="/" target="_top">返回网站</a></li>
		<li><a href="index.asp?act=logout" target="_top">退出系统</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu2',this)">新闻管理</a>
	</div>
	<ul id="menu2">
		<li><a href="news.asp?act=save" target="main">添加新闻</a></li>
		<li><a href="news.asp" target="main">新闻管理</a></li>
		<li><a href="sort.asp?tbl=news" target="main">分类管理</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu3',this)">产品管理</a>
	</div>
	<ul id="menu3">
		<li><a href="product.asp?act=save" target="main">添加产品</a></li>
		<li><a href="product.asp" target="main">产品管理</a></li>
		<li><a href="sort.asp?tbl=product" target="main">产品分类管理</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu6',this)">插件管理</a>
	</div>
	<ul id="menu6">
		<li><a href="link.asp" target="main">友情链接</a></li>
		<li><a href="message.asp" target="main">留言板</a></li>
		<li><a href="page.asp" target="main">图文页面</a></li>
		<li><a href="backup.asp" target="main">数据备份</a></li>
		<li><a href="explorer.asp" target="main">资源管理器</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu8',this)">帐户管理</a>
	</div>
	<ul id="menu8">
		<li><a href="admin.asp" target="main">帐户管理</a></li>
	</ul>
</div>
</div>
</body>
</html>