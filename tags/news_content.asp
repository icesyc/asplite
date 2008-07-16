<!-- #include file="asplite/Init.asp" -->
<%

id = getInt(Request.querystring("id"))
If id = 0 Then System.halt("²ÎÊý´íÎó")
Set n = model("news")
Set l = model("link")
Set record = n.getRow(id)
Set nList = n.findAll("sort_id<>"&record("sort_id"),"*", "id desc", 1, 5)
	For Each i In nList
		nList(i).Item("created") = FormatDateTime(nList(i).Item("created"),2)
		nList(i).Item("title") = left(nList(i).Item("title"),13)
	Next
	
Set tpl = view("admin/news_content.htm")
tpl.assign record,Null
tpl.assign "nList", nList
tpl.display

Set n = Nothing
Set l = Nothing
Set nList = Nothing
Set record = Nothing
Set tpl = Nothing
Set System = nothing
%>