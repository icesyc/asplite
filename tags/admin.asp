<!-- #include file="asplite/Init.asp" -->
<!-- #include file="session.asp" -->
<!-- #include file="asplite/md5.asp" -->
<%
'管理员帐号管理

Set admin = model("admin")

'列表
Sub default
	Set adminList = admin.findAll(null,null,null,null,null)
	Set v = view("admin/admin_list.htm")
	v.assign "adminList", adminList
	v.display
	Set v = Nothing
	Set adminList = nothing
End Sub

'添加
Sub save
	If System.isPost Then
		user_name = Trim(Request.Form("user_name"))
		exists = admin.findCount("user_name='"&user_name&"'")
		If exists > 0 Then 
			message "用户名已经存在", "error"
		End If
		Set data = Collection(Request.Form)
		data.Item("password") = MD5(data.Item("password"), 32)
		admin.save(data)
		System.goBack
	End If
End Sub

Sub setpwd
	If System.isPost Then
		Set data = Collection(Request.Form)
		If Not data.exists("id") Then 
			data.add "id", Session("uid")
		End If
		data.Item("password") = MD5(data.Item("password"), 32)
		admin.update(data)
		message "密码修改成功", "success"
	Else
		Set v = view("admin/setpwd.htm")
		v.display
		Set v = nothing
	End If
End Sub

'删除
Sub delete
	Dim id
	dump request.Form
	id = Trim(Request("id"))
	If id = "" Then System.halt("未指定id")
	If InStr(id, ",") Then id = Split(id, ",")
	admin.delete(id)
	System.goBack
End Sub

Config.pageActList = "default,save,setpwd,delete"
System.run
Set admin = nothing
Set System = Nothing
%>