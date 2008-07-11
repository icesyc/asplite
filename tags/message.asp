<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/Pager.asp" -->
<!-- #include file="session.asp" -->
<%
'留言管理

Dim msg
Set msg = model("message")

'列表
Sub default
	Dim page, limit,i
	limit = 20
	page = getInt(Request.QueryString("page"))
	If page <= 0 Then page = 1
	Set msgList = msg.findAll(null,null,"id desc",page,limit)
	Set v = view("admin/message_list.htm")

	Set p = pager(page, msg.findCount(null), limit)
	v.assign "messageList", msgList
	v.assign "pager", p.makePage()
	v.display
	Set v = Nothing
End Sub

'添加
Sub save
	If System.isPost Then
		msg.save(Collection(Request.Form))
		alert("留言成功，我们会尽快和您联系！")
	Else
		Set v = view("admin/message_save.htm")
		v.display
		Set v = nothing
	End If
End Sub

'修改
Sub edit
	If System.isPost Then
		Set data = Collection(Request.Form)
		If Not data.exists("id") Then 
			data.add "id", request("id")
		End If
		
		msg.update(data)
		response.Write("window.opener=null;window.close()")
		
	Else
		Set v = view("admin/setpwd.htm")
		v.display
		Set v = nothing
	End If
End Sub

'删除
Sub delete
	Dim id
	id = Trim(Request("id"))
	If id = "" Then System.halt("未指定id")
	If InStr(id, ",") Then id = Split(id, ",")
	msg.delete(id)
	System.goBack
End Sub

Config.pageActList = "default,save,delete,edit"
System.run
Set msg = nothing
Set System = Nothing
%>