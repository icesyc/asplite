<%
'smtp������Ϣ
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
	mail.From = smtpemail    '�����˵��ʼ���ַ
	mail.FromName = "���ſƼ����޹�˾"
	mail.AddRecipient email   '�����ߵ��ʼ���ַ
	mail.MailDomain = smtpserver   '�ĳɿ�������ʹ�õ��ʼ���������IP������
	mail.MailServerUserName = smtpuser  '�ʼ��������������ַ
	mail.MailServerPassWord = smtppass   '�ʼ�����������������
	mail.subject= subject     '����
	mail.htmlBody= "<p>���ĺ��Ѹ����Ƽ���</p><p>�����Ǹ�������������<p>" & body & "<p>ע�⣺����һ��ϵͳ�ʼ����벻Ҫ�ظ���</p>"    '����
	On Error Resume Next
	mail.Send(smtpserver)    '�ĳɿ�������ʹ�õ��ʼ���������IP������
	mail.close()
	set mail=nothing 
	msg = "�ʼ����ͳɹ�!"
	If Err Then msg = "�ʼ�����ʧ�ܣ�����ϵ��վ����Ա��"
%>
<script type="text/javascript">
	alert("<%=msg%>");
	history.back();
</script>
<%Else%>
<script type="text/javascript">
	alert("��������");
</script>
<%End If%>