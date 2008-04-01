<%
' ��ҳ��
'
' @package    asplite
' @author     ice_berg16(Ѱ�εĵ�����)
' @copyright  ice_berg16@163.com
' @version    $Id$

Class Pager_
	
	'��ǰҳ��
	Public currentPage
	'��¼����
	Public recordCount
	'ÿҳ��¼��
	Public pageSize
	'��ҳ��
	Public pageCount
	'������ʾ�����б����ӵķ�ҳ,�ò���ָ��Ҫ��ʾ�ĸ���
	Public linkNumber

	'Ҫ��ʾ�ĸ�ʽ
	Public formatStr
	
	'����
	Public errorMsg

	'��ĳ�ʼ��
	'@param curPage int ��ǰҳ
	'@param recount int ��������
	Public Sub Class_Initialize()
		errorMsg	= ""
		linkNumber  = 10
		formatStr   = "Pages: [current]/[total] �ܼ�¼�� [recordCount] [prev]��һҳ[/prev] [prevnav]ǰ10ҳ[/prevnav] [nav]  [nextnav]��10ҳ[/nextnav] [next]��һҳ[/next]"
	End Sub 
	
	'��ʾ�ܵķ�ҳ��
	Public Function makePage()
		If IsEmpty(currentPage) Or IsEmpty(recordCount) Or IsEmpty(pageSize) Then 
			errorMsg = "��ҳ��������ȫ"
			Exit Function
		End If
		If Not IsNumeric(currentPage) Then
			errorMsg = "currentPage ��������"
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
		'�������ֵ���
		For i=s To t
			If i > pageCount Then Exit For
			If i = currentPage Then
				nav = nav & " <span class='current'>"& currentPage &"</span>"
			Else
				nav = nav & " <a href='"& url & i &"'>"& i &"</a>"
			End If
		Next
		'ȥ����һ���ո�
		nav = Mid(nav, 2)
		'��һҳ�����һҳ
		first_   = "<a href='"& url & "1'>1</a>"
		last_    = "<a href='"& url & pageCount &"'>"& pageCount &"</a>"

		'Ĭ�ϵ���һҳ����һҳ���ϵ������µ���
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

	'ȡ�÷�ҳ����
	Private Function getPageCount()	
		If recordCount mod pageSize=0 Then
			getPageCount = recordCount \ pageSize
		Else
			getPageCount = recordCount \ pageSize + 1
		End If
		If getPageCount = 0 Then getPageCount = 1
	End Function

	'ȡ��URL
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