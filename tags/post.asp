<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/Pager.asp" -->
<!-- #include file="session.asp" -->
<!-- #include file="fckeditor/fckeditor.asp" -->
<%
Dim post
Set post = model("post")
If System.isPost Then
Dim id
id = Trim(Request("id"))
If id = "" Then System.halt("公告不能为空！")
	content=request("content")
	conn.execute("update "&Config.tablePre&"post set content='"&content&"' where id=2")
	System.goBack
Else
	id=request("id")
	Set record = post.getRow(id)
	Set v = view("admin/post.htm")
	v.assign "editor", editor("90%",500,"content", record.Item("content"))
	v.assign record, Null
	v.display
	Set v = nothing
End If
Set post = nothing
Set System = Nothing
%>