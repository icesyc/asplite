<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/FileUploader.asp" -->
<!-- #include file="asplite/FileSystem.asp" -->
<!-- #include file="session.asp" -->
<%
'友情链接管理

Set Link = model("link")

'列表
Sub default
	'分类列表
	Set linkList = Link.findAll(null,null,null,null,null)
	Set v = view("admin/link_list.htm")
	v.assign "linkList", linkList
	v.display
	Set v = Nothing
	Set linkList = Nothing
End Sub

'添加
Sub save
	If System.isPost Then
		Dim f,fname
		Set uploader = new FileUploader
		Set f   = uploader.file.Item("logo")		
		'判断文件类型
		If f.FileExt <> "jpg" and f.FileExt <> "gif" Then 
			message "上传的文件类型不正确，只能上传gif/jpg格式", "error"
		End If
		'保存上传的文件
		fname = uploader.autoSave("logo", Server.mapPath(Config.userfiles))
		uploader.Form.Item("logo") = Config.userfiles & fname
		link.save(uploader.Form)
		message "链接添加成功", "success"
	Else
		Set v = view("admin/link_save.htm")
		v.display
		Set v = nothing
	End If
End Sub

'删除
Sub delete
	Dim id,sql
	id = Trim(Request("id"))
	If id = "0" Or id = "" Then System.halt("未指定id")
	sql = "select logo from "&Config.tablePre&"link where id in("&id&")"
	Set rs = Conn.execute(sql)
	'先删除所有的图片
	While Not rs.eof
		FS.DeleteFile(rs.fields("logo"))
		rs.moveNext
	Wend
	sql = "delete from "&Config.tablePre&"link where id in("&id&")"
	Conn.execute(sql)
	System.goBack
End Sub

Config.pageActList = "default,save,delete"
System.run
Set sort = nothing
Set System = Nothing
%>