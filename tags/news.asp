<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/Tree.asp" -->
<!-- #include file="session.asp" -->
<!-- #include file="asplite/Pager.asp" -->
<!-- #include file="fckeditor/fckeditor.asp" -->
<%
'新闻管理

Set news = new Model_
news.table = Config.tablePre & "news_view"
news.PK    = "id"

'
Function getWhere(sortList)
	getWhere = ""
	For Each i In sortList
		getWhere = getWhere & "," & sortList(i).Item("id")
	Next
	getWhere = "sort_id in("& Mid(getWhere, 2)&")"
End Function

'列表
Sub default
	Dim page, limit,i,act,actText,sort_id,where,p,v
	limit = 20
	page = getInt(Request.QueryString("page"))
	If page < 1 Then page = 1
	sort_id = Trim(Request.QueryString("sort_id"))
	Set psort = tree("news_sort")
	If sort_id <> "" Then where = getWhere(psort.getSubTree(sort_id)) Else where = null
	Set newsList = news.findAll(where,"id,title,created,sort,is_recmd,is_pic","id desc",page,limit)
	For Each i In newsList
		if newsList.Item(i).Item("is_recmd") = 1 Then 
			act = "cancelRecmd"
			actText = "取消推荐"
		Else
			act = "recmd"
			actText = "推荐"
		End If
		If newsList.Item(i).Item("is_pic") = 1 Then 			
			pic = "<img src=""style/images/pic.gif"" align=""absmiddle""/>"
		Else		
			pic = ""
		End If
		newsList.Item(i).add "act", act
		newsList.Item(i).add "actText", actText
		newsList.Item(i).add "pic", pic
	Next

	'分类列表
	Set sortList = psort.getAllNode()
	For Each i In sortList
		sortList.Item(i).add "indent", String(sortList.Item(i).Item("deep")-1, "　")
	Next

	'分页参数
	Set p = pager(page, news.findCount(where), limit)
	Set v = view("admin/article_list.htm")
	v.assign "sort_id", sort_id
	v.assign "newsList", newsList
	v.assign "sortList", sortList
	v.assign "pager", p.makePage()
	v.display
	Set v = Nothing
	Set newsList = Nothing
	Set sortList = Nothing
	Set psort    = nothing
	Set p = nothing
End Sub

'添加
Sub save
	Set news = model("news")
	If System.isPost Then
		news.save(Collection(Request.Form))
		message "新闻保存成功", "success"
	Else
		Dim id
		id = getInt(Request.QueryString("id"))
		If id = 0 Then act = "添加" Else act = "内容修改"
		Set record = news.getRow(id)

		'分类列表
		Set sortList = tree("news_sort").getAllNode()
		For Each i In sortList
			sortList.Item(i).add "indent", String(sortList.Item(i).Item("deep")-1, "　")
		Next

		Set v = view("admin/article_save.htm")
		v.assign "sortList", sortList
		v.assign record, Null
		v.assign "act", act
		v.assign "editor", editor("90%",500,"content", record.Item("content"))
		v.display
		Set record = Nothing
		Set v = nothing
	End If
End Sub

'推荐
Sub recmd
	Dim id
	id = Trim(Request("id"))
	If id = "" Then System.halt("未指定id")
	Conn.execute("update "&Config.tablePre&"news set is_recmd=1 where id in("&id&")")
	System.goBack
End Sub

'取消推荐
Sub cancelRecmd
	Dim id
	id = Trim(Request("id"))
	If id = "" Then System.halt("未指定id")
	Conn.execute("update "&Config.tablePre&"news set is_recmd=0 where id in("&id&")")
	System.goBack
End Sub

'删除
Sub delete
	Dim id
	id = Trim(Request("id"))
	If id = "" Then System.halt("未指定id")
	If InStr(id, ",") Then id = Split(id, ",")
	Set news = model("news")
	news.delete(id)
	System.goBack
End Sub

Config.pageActList = "default,save,recmd,cancelRecmd,delete"
System.run
Set news = nothing
Set System = Nothing
%>