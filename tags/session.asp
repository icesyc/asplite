<%
Session.Timeout = Config.sessionTime
if Session("adminLogin") = empty Then
	If Request("act") <> "login" Then 
		Response.redirect("index.asp?act=login")
	End If
end if
%>