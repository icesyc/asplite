<!-- #include file="asplite/Init.asp" -->
<!-- #include file="session.asp" -->
<!-- #include file="asplite/md5.asp" -->
<%
'Ĭ��
Sub default
	%><!-- #include file="frame.asp" --><%
End Sub

'��¼
Sub login
	If System.isPost Then
		Dim user,pwd,msg,admin,v
		user = Replace(Replace(Request.Form("user_name"), "'", ""), """", "")
		pwd  = Request.Form("password")
		code = Request.Form("imgcode")
		If code <> Trim(Session("imageCode")) Then 
			msg = "��֤�����"
		Else
			Set admin = model("admin").find("user_name='"&user&"'", null, null)
			If admin.Count = 0 Then 
				msg = "�û���������"
			ElseIf admin.Item("password") <> MD5(pwd, 32) Then 
				msg = "�������"
			End If
		End If
		If msg <> "" Then 
			Set v = view("admin/login.htm")
			v.assign "message", msg
			v.assign "appName", Config.appName
			v.assign "className", "login-msg"
			v.display
		End If
		Session("adminLogin") = True
		Session("user_name") = user
		Session("uid")		 = admin.Item("id")
		Session("last_visit")= admin.Item("last_visit")
		Conn.execute("update "&Config.tablePre&"admin set last_visit='"&now&"' where id="&admin.Item("id"))
		Set admin = Nothing
		Set v = nothing
		Response.redirect("index.asp")
	Else
		Set v = view("admin/login.htm")
		v.assign "appName", Config.appName
		v.assign "message" , ""
		v.assign "className", "hide"
		v.display
		Set v = Nothing
	End If
End Sub

'ע��
Sub logout
	Session("adminLogin") = Empty
	Session("user_name") = Empty
	Session("uid") = Empty
	Session.abandon
	Response.redirect("index.asp?act=login")
End Sub

Config.pageActList = "default,login,logout"
System.run
Set System = Nothing
%>