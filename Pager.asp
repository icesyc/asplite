<%
' 分页类
'
' @package    asplite
' @author     ice_berg16(寻梦的稻草人)
' @copyright  ice_berg16@163.com
' @version    $Id$

Class Pager_
	
	'当前页面
	Public currentPage
	'记录总数
	Public recordCount
	'每页记录数
	Public pageSize
	'总页数
	Public pageCount
	'对于显示数字列表链接的分页,该参数指定要显示的个数
	Public linkNumber

	'要显示的格式
	Public formatStr
	
	'错误
	Public errorMsg

	'类的初始化
	'@param curPage int 当前页
	'@param recount int 记数总数
	Public Sub Class_Initialize()
		errorMsg	= ""
		linkNumber  = 10
		formatStr   = "Pages: [current]/[total] 总记录数 [recordCount] [prev]上一页[/prev] [prevnav]前10页[/prevnav] [nav]  [nextnav]后10页[/nextnav] [next]下一页[/next]"
	End Sub 
	
	'显示总的分页数
	Public Function makePage()
		If IsEmpty(currentPage) Or IsEmpty(recordCount) Or IsEmpty(pageSize) Then 
			errorMsg = "分页参数不完全"
			Exit Function
		End If
		If Not IsNumeric(currentPage) Then
			errorMsg = "currentPage 不是数字"
			Exit Function
		End If
		currentPage = CInt(currentPage)
		Dim url, s, t, nav, first_, prev_, next_, last_, prevnav_, nextnav_, outFormat
		nav = ""
		url = getURL()
		pageCount = getPageCount()
		s = currentPage - linkNumber \ 2
		If s <= 0 Then s = 1
		t = s + linkNumber - 1
		'生成数字导航
		For i=s To t
			If i > pageCount Then Exit For
			If i = currentPage Then
				nav = nav & " <span class='current'>"& currentPage &"</span>"
			Else
				nav = nav & " <a href='"& url & i &"'>"& i &"</a>"
			End If
		Next
		'去掉第一个空格
		nav = Mid(nav, 2)
		'第一页和最后一页
		first_   = "<a href='"& url & "1'>1</a>"
		last_    = "<a href='"& url & pageCount &"'>"& pageCount &"</a>"

		'默认的上一页，下一页，上导航，下导航
		prev_	 = "<a>$1</a>"
		next_	 = "<a>$1</a>"
		prevnav_ = "<a>$1</a>"
		nextnav_ = "<a>$1</a>"
		If currentPage > 1 Then prev_ = "<a href='"& url & (currentPage-1) &"'>$1</a>"
		If currentPage < pageCount Then next_ = "<a href='"& url & (currentPage+1) &"'>$1</a>"
		If s > linkNumber Then prevnav_ = "<a href='"& url & (s - linkNumber) &"'>$1</a>"
		If s + linkNumber < pageCount Then nextnav_ = "<a href='"& url & (s + linkNumber) &"'>$1</a>"
		outFormat = Replace(formatStr, "[current]", currentPage)
		outFormat = Replace(outFormat, "[total]", pageCount)
		outFormat = Replace(outFormat, "[recordCount]", recordCount)
		outFormat = Replace(outFormat, "[nav]", nav)
		reg =  Array("\[prev\](.+?)\[\/prev\]", "\[next\](.+?)\[\/next\]", "\[first\](.+?)\[\/first\]", "\[last\](.+?)\[\/last\]", "\[prevnav\](.+?)\[\/prevnav\]","\[nextnav\](.+?)\[\/nextnav\]")
		rep  = Array(prev_ , next_ , first_ , last_ , prevnav_ , nextnav_)
		For i = 0 To UBound(reg)
			Set r = new RegExp
			r.pattern = reg(i)
			r.ignoreCase = True
			outFormat = r.Replace(outFormat, rep(i))
		Next
		makePage = outFormat		
	End Function

	'取得分页总数
	Private Function getPageCount()	
		If recordCount mod pageSize=0 Then
			getPageCount = recordCount \ pageSize
		Else
			getPageCount = recordCount \ pageSize + 1
		End If
		If getPageCount = 0 Then getPageCount = 1
	End Function

	'取得URL
	Private Function getURL()
		Dim ps, url
		qs =  Request.ServerVariables("QUERY_STRING")
		If qs = "" Then 
			url =  Request.ServerVariables("URL") & "?page="
		Else
			If InStr(1, qs, "page=") > 0 Then
				Set reg = new RegExp
				reg.Pattern = "page=(\d+)"
				url = Request.ServerVariables("URL") & "?" & qs
				url = reg.Replace(url, "") & "page="
			Else
				url = Request.ServerVariables("URL") & "?" & qs & "&page="
			End If
		End If
		getURL = url
	End Function
End Class
%>