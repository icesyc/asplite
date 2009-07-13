<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html;charset=utf-8"/>
<meta name="Author" content="" >
<link rel="stylesheet" href="/system/style/global.css" type="text/css"/>
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
		target.style.backgroundImage = "url(/system/style/images/min.gif)";

	}
	else
	{
		menu.style.display = "none";
		target.style.backgroundImage = "url(/system/style/images/max.gif)";
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
		<li><a href="main.php" target="main">常规设置</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu2',this)">新闻管理</a>
	</div>
	<ul id="menu2">
		<li><a href="news.php" target="main">新闻添加</a></li>
		<li><a href="news_list.php" target="main">新闻管理</a></li>
	</ul>
</div>
<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu6',this)">产品管理</a>
	</div>
	<ul id="menu6">
		<li><a href="product.php" target="main">添加产品</a></li>
		<li><a href="product_list.php" target="main">产品管理</a></li>
	</ul>
</div>

<div class="menu">
	<div class="menu-head">
		<a href="javascript:void(null)" onclick="showMenu('menu8',this)">帐号管理</a>
	</div>
	<ul id="menu8">
		<li><a href="admin.php" target="main">增加管理</a></li>
	</ul>
</div>
</div>
</body>
</html>