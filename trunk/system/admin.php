<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>帐号管理</title>
<meta http-equiv="content-type" content="text/html;charset=utf-8"/>
<meta name="Author" content="" >
<link rel="stylesheet" href="style/global.css" type="text/css"/>
<script type="text/javascript" src="javascript/jquery.js"></script>
<script type="text/javascript" src="javascript/jquery.util.js"></script>
<script type="text/javascript" src="javascript/validator.js"></script>
</head>
<body>
<div class="main-box">
	<div class="head-dark-box">
		添加帐号
	</div>
	<form method="post" class="body-box" action="control/admin.php" validate="true">
		用户名:
		<input type="text" name="adminname" size="15" rule="alphaNumber" tip="用户名不能为空!"/>
		密　码：
		<input type="password" name="password" size="15" rule="required" tip="密　码不能为空!"/>
		<input type="submit" class="button" value="添加帐号" />
		<input type="hidden" name="act" value="save"/>
	</form>
	<div class="head-dark-box">
	帐户管理
	</div>
	<div class="body-box tip-msg">
		删除用户时应至少保留一个用户存在，否则将不能登录系统.
	</div>
	<div class="white-box">
		<table class="list-table" cellspacing="0">
			<tr class='head-light-box'>
				<td width="4%">ID</td>
				<td width="35%">用户名</td>
				<td>操 作</td>
			</tr>

			<tr>
				<td>id</td>
				<td>adminname</td>
				<td>
					[<a href="javascript:void(null)" onclick="$('#fpwdid').toggle()">修改密码</a>]
					[<a href="admin.php?act=delete&id=id" onclick="return confirm('确实要删除吗')">删除</a>]
				</td>
			</tr>

			<tr class="hide" id="fpwdid">
				<td>&nbsp;</td>
				<td colspan="4">
					<form action="admin.php" method="post" validate="true">
						新密码：<input type="password" name="password" size="20"
						rule="required" tip="修改密码不能为空!" value="pwd"/>&nbsp;&nbsp;
						<input type="submit" class="button" value="提交修改"/>
						<input type="hidden" name="id" value="id"/>
						<input type="hidden" name="act" value="save"/>
					</form>
				</td>
			</tr>

			<tr class="head-light-box">
			  <td colspan="4">&nbsp;</td>
			</tr>

		</table>
	</div>
</div>
<!-- ύѡɾı? -->
<form method="post" action="control/admin.php" name="multiBoxForm" class="hidden">
<input type="hidden" name="act" value="delete"/>
</form>
<script type="text/javascript">

function buildForm()
{
	if( confirm('确实要删除吗') )
	{
		var idlist = document.getElementsByName("ids");
		//ѡеidӵҪύı?
		for(i=0;i<idlist.length;i++)
		{
			if(idlist[i].checked)
			{
				var el 		= document.createElement("input");
				el.type     = "checkbox";
				el.name     = "id";
				el.value= idlist[i].value;
				document.multiBoxForm.appendChild(el);
				el.checked  = true;
			}
		}
		//ύ?
		document.multiBoxForm.submit();
	}
	else
		return false;
}
</script>
</body>
</html>
