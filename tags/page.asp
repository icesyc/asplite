<!-- #include file="asplite/Init.asp" -->
<!-- #include file="session.asp" -->
<!-- #include file="asplite/Pager.asp" -->
<!-- #include file="fckeditor/fckeditor.asp" -->
<%
'��һҳ�����

Set mpage = model("page")

'�б�
Sub default
	Dim page, limit,i,p,v
	limit = 20
	page = getInt(Request.QueryString("page"))
	If page < 1 Then page = 1
	Set pageList = mpage.findAll(null,"id,title,created","id desc",page,limit)

	'��ҳ����
	Set p = pager(page, mpage.findCount(null), limit)
	Set v = view("admin/page_list.htm")
	v.assign "pageList", pageList
	v.assign "pager", p.makePage()
	v.display
	Set pageList = Nothing
	Set v = Nothing
	Set p = nothing
End Sub

'���
Sub save
	If System.isPost Then
		mpage.save(Collection(Request.Form))
		message "ҳ�汣��ɹ�", "success"
	Else
		Dim id
		id = getInt(Request.QueryString("id"))
		If id = 0 Then act = "���" Else act = "�����޸�"
		Set record = mpage.getRow(id)

		Set v = view("admin/page_save.htm")
		v.assign record, Null
		v.assign "act", act
		v.assign "editor", editor("90%",500,"content", record.Item("content"))
		v.display
		Set record = Nothing
		Set v = nothing
	End If
End Sub

'ɾ��
Sub delete
	Dim id
	id = Trim(Request("id"))
	If id = "" Then System.halt("δָ��id")
	If InStr(id, ",") Then id = Split(id, ",")
	mpage.delete(id)
	System.goBack
End Sub

Config.pageActList = "default,save,delete"
System.run
Set mpage = nothing
Set System = Nothing
%>