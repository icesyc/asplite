<%
'smtp配置信息
smtpserver = "smtp.163.com"
smtpuser   = "mail.smtp"
smtppass   = "mailsmtp"
smtpemail  = "mail.smtp@163.com"

If request("mod") = "yes" Then
	email = request("email")
	subject = request("name")
	body  = request("content")
	url   = request("email")

	set mail=CreateObject("jmail.Message")
	mail.Charset ="gb2312"
	mail.From = smtpemail    '发送人的邮件地址
	mail.FromName = "蓝桥科技有限公司"
	mail.AddRecipient email   '接收者的邮件地址
	mail.MailDomain = smtpserver   '改成可以正常使用的邮件服务器的IP或域名
	mail.MailServerUserName = smtpuser  '邮件服务器的邮箱地址
	mail.MailServerPassWord = smtppass   '邮件服务器的邮箱密码
	mail.subject= subject     '标题
	mail.htmlBody= "<p>您的好友给您推荐：</p><p>以下是给您的留言内容<p>" & body & "<p>注意：这是一封系统邮件，请不要回复。</p>"    '正文
	On Error Resume Next
	mail.Send(smtpserver)    '改成可以正常使用的邮件服务器的IP或域名
	mail.close()
	set mail=nothing 
	msg = "邮件发送成功!"
	If Err Then msg = "邮件发送失败，请联系网站管理员。"
%>
<script type="text/javascript">
	alert("<%=msg%>");
	history.back();
</script>
<%Else%>
<script type="text/javascript">
	alert("参数错误");
</script>
<%End If%>