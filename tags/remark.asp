<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/Pager.asp" -->

<%
'评论管理
Set r = new Model_
r.table = Config.tablePre & "remark"
r.PK    = "id"

'列表
Sub default
page = getInt(Request.Querystring("page"))
If page <= 0 Then page = 1
limit = 10
If sort_id = 0 Then sort_id = 2
where = "type='"&request("type")&"'"
Set rlist = r.findAll(where,"*", "id desc", page, limit)
Set p = pager(page, r.findCount("type='news'"), limit)
	
	
	Set v = view("admin/remark.htm")
	v.assign "rlist", rlist
	v.assign "ti",request("ti")
	v.assign "id",request("news_id")
	v.assign "ip" , ip
	v.assign "add_time" , now()
	v.assign "pager", p.makePage()
	v.display
	Set v = Nothing
End Sub

'删除
Sub delete
	Dim id
	id = Trim(Request("id"))
	If id = "" Then System.halt("未指定id")
	If InStr(id, ",") Then id = Split(id, ",")
	r.delete(id)
	System.goBack
End Sub


Config.pageActList = "default,save,delete"
System.run
Set msg = nothing
Set System = Nothing
%>

