<%
' 系统对象,包括一些系统函数
'
' @package    asplite
' @author     ice_berg16(寻梦的稻草人)
' @copyright  ice_berg16@163.com
' @version    $Id$

Class System_

	'当前文件名
	Public Property Get selfPage
		page = Request.ServerVariables("PATH_INFO")
		selfPage = Mid(page, InStrRev(page, "/")+1)
	End Property

	'是否为Post方式提交
	Public Property Get isPost
		If LCase(Request.ServerVariables("REQUEST_METHOD")) = "post" Then
			isPost = true
		Else
			isPost = false
		End If
	End Property

	'返回到前一页
	Public Function goBack()
		Response.redirect(Request.ServerVariables("HTTP_REFERER"))
	End Function


	'系统信息函数
	Public Function halt(msg)
		Response.write("<fieldset style='font-size:12px;'><legend><strong>系统提示</strong></legend><div style='color:red;margin:10px'>" & msg & "</div></fieldset>")
		Response.End()
	End Function

	Public Sub run
		Dim act: act = ""
		If Request.QueryString(Config.urlCommand) <> "" Then
			act = Trim(Request.QueryString(Config.urlCommand))
		ElseIf Request.Form(Config.urlCommand) <> "" Then
			act = Trim(Request.Form(Config.urlCommand))
		End If
		If act = "" Then act = Config.defaultAction
		'检查命令是否可用
		availAct = Split(Config.pageActList, ",")
		If inArray(availAct, act) Then 
			Set action = getRef(act)
			Call action()
		Else
			System.halt("Error: 未找到Action:" & act)
		End If
	End Sub

	Public Sub Class_Terminate
		If TypeName(Conn) = "Connection" Then 
			If Conn.state <> 0 Then Conn.close
			Set Conn = nothing
		End If
		Set Config = Nothing
	End Sub
End Class

Dim System
Set System = new System_
%>