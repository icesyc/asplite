<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/FileUploader.asp" -->
<!-- #include file="asplite/FileSystem.asp" -->
<!-- #include file="session.asp" -->
<%
'�������ӹ���

Set Link = model("link")

'�б�
Sub default
	'�����б�
	Set linkList = Link.findAll(null,null,null,null,null)
	Set v = view("admin/link_list.htm")
	v.assign "linkList", linkList
	v.display
	Set v = Nothing
	Set linkList = Nothing
End Sub

'���
Sub save
	If System.isPost Then
		Dim f,fname
		Set uploader = new FileUploader
		Set f   = uploader.file.Item("logo")		
		'�ж��ļ�����
		If f.FileExt <> "jpg" and f.FileExt <> "gif" Then 
			message "�ϴ����ļ����Ͳ���ȷ��ֻ���ϴ�gif/jpg��ʽ", "error"
		End If
		'�����ϴ����ļ�
		fname = uploader.autoSave("logo", Server.mapPath(Config.userfiles))
		uploader.Form.Item("logo") = Config.userfiles & fname
		link.save(uploader.Form)
		message "������ӳɹ�", "success"
	Else
		Set v = view("admin/link_save.htm")
		v.display
		Set v = nothing
	End If
End Sub

'ɾ��
Sub delete
	Dim id,sql
	id = Trim(Request("id"))
	If id = "0" Or id = "" Then System.halt("δָ��id")
	sql = "select logo from "&Config.tablePre&"link where id in("&id&")"
	Set rs = Conn.execute(sql)
	'��ɾ�����е�ͼƬ
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