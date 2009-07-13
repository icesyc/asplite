<?php
include_once(dirname(__FILE__)."/libs/init.class.php");
	
	$arr = array();
	$arr['title'] = ADDRESS_NAME."<p>";
	$arr['host']  = "服务器IP地址：".$_SERVER['REMOTE_ADDR']."<p>";
	$arr['Protocol'] = "当前协议：".$_SERVER['SERVER_PROTOCOL']."<p>";
	$arr['login'] = "登陆用户：管理员<p>";
	
	//取出相关配置信息
	if( @ini_get( "file_uploads" ) )
		{
			$fileUpload = "允许 | 文件:".ini_get( "upload_max_filesize" )." | 表单：".ini_get( "post_max_size" );
		}
		else
		{
			$fileUpload = "<span class=\"red-font\">禁止</span>";
		}

	$arr['fileUpload'] = "相关配置信息:".$fileUpload."<p>";
	
		//检测是否支持GD库
		if( function_exists( "gd_info" ) )
		{
		    $gi = gd_info();
		    $gdInfo = "GD版本: " . $gi["GD Version"];
		}
		else
		{
		    $gdInfo = "不支持GD库";
		}
	
	$arr['edition'] = $gdInfo."<p>";

$tpl = new smarty;
$tpl -> assign("arr",$arr);
$tpl -> display("main.htm");


?>
