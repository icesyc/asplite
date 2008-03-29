<%
Session.Timeout = Config.sessionTime
if Session("admin") = empty Then
	Response.redirect("login.asp")
end if
%>