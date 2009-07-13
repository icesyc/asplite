<?php
include_once('session.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>新闻管理</title>
<meta http-equiv="content-type" content="text/html;charset=utf-8"/>
<link rel="stylesheet" href="style/global.css" type="text/css"/>
<script type="text/javascript" src="javascript/jquery.js"></script>
<script type="text/javascript" src="javascript/jquery.util.js"></script>
</head>
<body>
<div class="main-box">
	<div class="head-dark-box">
		新闻管理
	</div>
	<form method="get" action="news.php">
	<div class="white-box">
		<table class="list-table" cellspacing="0">
			<tr class='head-light-box'>
				<td width="4%">&nbsp;</td>
				<td>标题</td>
				<td>时间</td>
				<td>操作</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="id[]" value="1" /></td>
				<td><a href="#" target="_blank">标题信息</a></td>
				<td>时间</td>
				<td>
					[<a href="news_edit.php?act=edit&id=">修改</a>]
					[<a href="news.php?act=delete&id=" onclick="return confirm('确定删除吗！')">删除</a>]
				</td>
			</tr>
			<tr>
				<td align="right" colspan="4" id="pager">
				</td>
			</tr>
			<tr class="head-light-box">
				<td colspan="4">
				<input type="checkbox" onclick="$(':checkbox').checkAll(this.checked)" id="ckall"/>	
				&nbsp;&nbsp;选择: <input type="image" src="style/images/delete.gif" alt="确定删除吗！" onclick="return confirm('确定删除吗！')"/>	
				&nbsp;<input type="image" src="style/images/top.gif" onclick="this.form.act='recmd'"/>	
				&nbsp;<input type="image" src="style/images/down.gif" onclick="this.form.act.value='cancelRecmd'"/>	
				<input type="hidden" name="act" value="delete"/>				</td>
			</tr>
		</table>
	</div>
	</form>
</div>
</body>
</html>
