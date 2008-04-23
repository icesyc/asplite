<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/Tree.asp" -->
<!-- #include file="session.asp" -->
<%
'新闻分类管理

Dim tblArr,tbl
tblArr = Array("news", "product")
tbl    = Trim(Request("tbl"))
If Not inArray(tblArr, tbl) Then System.halt("参数错误")
Set sort = tree(tbl&"_sort")

'列表
Sub default
	'分类列表
	Set sortList = sort.getAllNode()
	For Each i In sortList
		sortList.Item(i).add "indent", String(sortList.Item(i).Item("deep")-1, "　")
	Next
	Set v = view("admin/sort.htm")
	v.assign "sortList", sortList
	v.assign "tbl", tbl
	v.display
	Set v = Nothing
	Set sortList = Nothing
End Sub

'添加
Sub save
	If System.isPost Then
		sort.save(Collection(Request.Form))
		System.goBack
	End If
End Sub

'删除
Sub delete
	Dim id
	id = getInt(Request("id"))
	If id = 0 Then System.halt("未指定id")
	sort.delete(id)
	System.goBack
End Sub

Config.pageActList = "default,save,delete"
System.run
Set sort = nothing
Set System = Nothing
%>