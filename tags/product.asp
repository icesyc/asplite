<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/Tree.asp" -->
<!-- #include file="session.asp" -->
<!-- #include file="asplite/Pager.asp" -->
<!-- #include file="fckeditor/fckeditor.asp" -->
<%
'产品管理

Set product = new Model_
product.table = Config.tablePre & "product_view"
product.PK    = "id"

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
	Set psort = tree("product_sort")
	If sort_id <> "" Then where = getWhere(psort.getSubTree(sort_id)) Else where = null
	Set productList = product.findAll(where,"id,title,created,sort,is_recmd","id desc",page,limit)
	For Each i In productList
		if productList.Item(i).Item("is_recmd") = 1 Then 
			act = "cancelRecmd"
			actText = "取消推荐"
		Else
			act = "recmd"
			actText = "推荐"
		End If
		If productList.Item(i).Item("is_pic") = 1 Then 			
			pic = "<img src=""style/images/pic.gif"" align=""absmiddle""/>"
		Else
			pic = ""
		End If
		productList.Item(i).add "act", act
		productList.Item(i).add "actText", actText
		productList.Item(i).add "pic", pic
	Next

	'分类列表
	Set sortList = psort.getAllNode()
	For Each i In sortList
		sortList.Item(i).add "indent", String(sortList.Item(i).Item("deep")-1, "　")
	Next

	'分页参数
	Set p = pager(page, product.findCount(where), limit)
	Set v = view("admin/product_list.htm")
	v.assign "sort_id", sort_id
	v.assign "productList", productList
	v.assign "sortList", sortList
	v.assign "pager", p.makePage()
	v.display
	Set v = Nothing
	Set productList = Nothing
	Set sortList = Nothing
	Set p = Nothing
	Set psort = nothing
End Sub

'添加
Sub save
	Set product = model("product")
	If System.isPost Then
		product.save(Collection(Request.Form))
		message "产品保存成功", "success"
	Else
		Dim id
		id = getInt(Request.QueryString("id"))
		If id = 0 Then act = "添加" Else act = "内容修改"
		Set record = product.getRow(id)

		'分类列表
		Set sortList = tree("product_sort").getAllNode()
		For Each i In sortList
			sortList.Item(i).add "indent", String(sortList.Item(i).Item("deep")-1, "　")
		Next

		Set v = view("admin/product_save.htm")
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
	Conn.execute("update "&Config.tablePre&"product set is_recmd=1 where id in("&id&")")
	System.goBack
End Sub

'取消推荐
Sub cancelRecmd
	Dim id
	id = Trim(Request("id"))
	If id = "" Then System.halt("未指定id")
	Conn.execute("update "&Config.tablePre&"product set is_recmd=0 where id in("&id&")")
	System.goBack
End Sub

'删除
Sub delete
	Dim id
	id = Trim(Request("id"))
	If id = "" Then System.halt("未指定id")
	If InStr(id, ",") Then id = Split(id, ",")
	Set product = model("product")
	product.delete(id)
	System.goBack
End Sub

Config.pageActList = "default,save,recmd,cancelRecmd,delete"
System.run
Set product = nothing
Set System = Nothing
%>