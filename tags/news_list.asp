<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/Pager.asp" -->
<%


page = getInt(Request.Querystring("page"))
sort_id  = getInt(Request.querystring("sort_id"))
If page <= 0 Then page = 1
limit = 20
If sort_id = 0 Then sort_id = 2
Set n = model("news")
Set l = model("news_sort")
Set newsList = n.findAll("sort_id>1","id,title,created", "id desc", page, limit)
	For Each i In newsList
		newsList(i).Item("created") = FormatDateTime(newsList(i).Item("created"),2)
		newsList(i).Item("title") = left(newsList(i).Item("title"),13)
	Next

Set p = pager(page, n.findCount("sort_id>1"), limit)
Set linkList = l.findAll("id<>1","*", "id desc", 1, 10)
Set tpl = view("admin/news_list.htm")
tpl.assign "newsList", newsList
tpl.assign "sort_id", sort_id
tpl.assign "linkList", linkList
tpl.assign "pager", p.makePage()
tpl.display

Set n = Nothing
Set l = Nothing
Set newsList = nothing
Set linkList = nothing
Set tpl = Nothing
Set System = nothing
%>