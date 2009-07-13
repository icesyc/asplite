<?php
include('session.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title> </title>
<meta http-equiv="content-type" content="text/html;charset=utf-8"/>
<meta name="Author" content="" >
<link rel="stylesheet" href="style/global.css" type="text/css" />
<script type="text/javascript" src="javascript/jquery.js" ></script>
<script type="text/javascript" src="javascript/jquery.util.js" ></script>
<script type="text/javascript" src="javascript/validator.js"></script>
<style>
div#editor {
	text-align:center;
}
#thumbPreview{
	border:1px solid #000;
}
#thumbPreview{
	width:100px;
	height:100px;
}
#thumbArea{
	margin-top:10px;
}
</style>
</head>
<body>
<div class="main-box">
<div class="head-dark-box">产品添加</div>
<div class="body-box tip-msg">
	提示: 带 <img src="style/images/star.gif" alt="*"/>  的项目为必填信息. 
</div>
<form class="white-box" action="control/product.php" method="post" validate="true" name="saveForm">
  <div>
		<label class="field"><img src="style/images/star.gif" alt="*"/> 产品名称 </label> 
		<input type="text" name="title" size="50" value="" maxlength="50" rule="required" tip="产品名称必须添写！" scroll="yes"/><p><label class="field"><img src="style/images/star.gif" alt="*"/> 链接地址 </label><input type="text" name="link" size="50" value="" maxlength="50" rule="required" tip="链接地址必须添写！" scroll="yes"/>&nbsp;<input type="checkbox" name="is_recmd" value="1" id="is_recmd"/>
		<label for="is_recmd">推荐</label>
	</div>
	<div>
		<label class="field">产品缩略图</label> 
		<input type="text" name="thumbnail" class="textbox" size="50" readonly="readonly" value=""/>
		<input type="button" class="button" value="选择图片" onclick="selectImage('thumbnail')"/>
	</div>
    <div>
		<label class="field">产品缩略图2</label> 
		<input type="text" name="thumbnail1" class="textbox" size="50" readonly="readonly" value=""/>
		<input type="button" class="button" value="选择图片" onclick="selectImage('thumbnail1')"/>
	</div>
	<div id="thumbArea" class="with-line">
		<label class="field">缩略图预览</label>		
		<img src="style/images/no_image.gif" id="thumbPreview"/>
	</div>
	<div><input type="hidden" id="content" name="content" value="" style="display:none" /><input type="hidden" id="content___Config" value="" style="display:none" /><iframe id="content___Frame" src="FCKeditor/editor/fckeditor.html?InstanceName=content&amp;Toolbar=Default" width="100%" height="400" frameborder="0" scrolling="no"></iframe></div>
	<div class="center">
		<input type="submit" value="提　交" class="button"/>
		<input type="button" value="返　回" class="button" onclick="history.back()"/>
		<input type="hidden" name="id" value=""/>
		<input type="hidden" name="act" value="save"/>
	</div>
</form>
</div>
<script type="text/javascript">
var is_recmd = "{is_recmd}";
var currentThumb = null;
document.saveForm.sort_id.value = "{sort_id}";
document.saveForm.is_recmd.checked = is_recmd == "1";
if(document.saveForm.thumbnail.value != "")
	document.getElementById('thumbPreview').src = document.saveForm.thumbnail.value;

//选择图片的回调函数
function SetUrl(url)
{
	document.saveForm[currentThumb].value = url;
	document.getElementById('thumbPreview').src = url;
}

//选择缩略图
function selectImage(o)
{
	currentThumb = o;
	oEditor = document.getElementById('content___Frame').contentWindow;
	OpenFileBrowser(oEditor.FCKConfig.ImageBrowserURL,
		oEditor.FCKConfig.ImageBrowserWindowWidth,
		oEditor.FCKConfig.ImageBrowserWindowHeight);
}

function OpenFileBrowser( url, width, height )
{
	// oEditor must be defined.
	
	var iLeft = ( oEditor.FCKConfig.ScreenWidth  - width ) / 2 ;
	var iTop  = ( oEditor.FCKConfig.ScreenHeight - height ) / 2 ;

	var sOptions = "toolbar=no,status=no,resizable=yes,dependent=yes" ;
	sOptions += ",width=" + width ;
	sOptions += ",height=" + height ;
	sOptions += ",left=" + iLeft ;
	sOptions += ",top=" + iTop ;

	// The "PreserveSessionOnFileBrowser" because the above code could be 
	// blocked by popup blockers.
	if ( oEditor.FCKConfig.PreserveSessionOnFileBrowser && oEditor.FCKBrowserInfo.IsIE )
	{
		// The following change has been made otherwise IE will open the file 
		// browser on a different server session (on some cases):
		// http://support.microsoft.com/default.aspx?scid=kb;en-us;831678
		// by Simone Chiaretta.
		var oWindow = oEditor.window.open( url, 'FCKBrowseWindow', sOptions ) ;
		
		if ( oWindow )
		{
			// Detect Yahoo popup blocker.
			try
			{
				var sTest = oWindow.name ; // Yahoo returns "something", but we can't access it, so detect that and avoid strange errors for the user.
				oWindow.opener = window ;
			}
			catch(e)
			{
				alert( oEditor.FCKLang.BrowseServerBlocked ) ;
			}
		}
		else
			alert( oEditor.FCKLang.BrowseServerBlocked ) ;
    }
    else
		window.open( url, 'FCKBrowseWindow', sOptions ) ;
}
</script>
</body>
</html>