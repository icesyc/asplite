<%
' Ӧ�ó��������ļ�
'
' @package    asplite
' @author     ice_berg16(Ѱ�εĵ�����)
' @copyright  ice_berg16@163.com
' @version    $Id$

Class Config_

	'Ӧ�ó���·��
	Public appRoot

	'���ݿ��ļ�λ��
	Public dbPath
	
	'���ݿ����� sqlserver|access
	Public dbDriver

	'------ ���Ϊsql server ����Ҫָ���������� -----------

	'���ݿ�ķ�������ַ
	Public dbHost
	
	'���ݿ���û���
	Public dbUser

	'���ݿ������
	Public dbPassword

	'���ݿ������
	Public dbName

	'���ݿ��ǰ׺
	Public tablePre

	'Session�ĳ�ʱ����,��λΪ����
	Public sessionTime

	'URL��������
	Public urlCommand

	'Ĭ��ִ�еĶ���
	Public defaultAction

	'��������
	Public appName

	'��ǰҳ����õĶ����б�
	Public pageActList

	'�ϴ����ļ�·��
	Public uploadPath

	'��ҳ��ʽ
	Public pagerFormat

	'ǰ̨��ҳ��ʽ
	Public fpagerFormat

	'��ͼģ���·��
	Public viewPath

	'�༭����·��
	Public editorPath

	'�û��ļ�·��,fckeditor���ϴ��ļ�λ��
	Public userfiles

	Private Sub Class_Initialize
		appRoot				= ""
		dbPath				= Server.MapPath(appRoot & "/system/db/webapp.mdb")
		dbDriver			= "access"
		urlCommand			= "act"
		sessionTime			= 30
		viewPath			= Server.MapPath(appRoot & "/system/view")
		editorPath			= appRoot & "/system/fckeditor/"
		userfiles			= appRoot & "/userfiles/"
		appName				= "asp����"
		defaultAction		= "default"
		tablePre			= "ice_"
		pageActList			= "default,save,delete"
		pagerFormat			= "Pages: <span class=""red"">[current]</span>/<span class=""red"">[total]</span> "&_
							  "Total: <span class=""red"">[recordCount]</span> "&_
							  "[prev]&lt;[/prev] "&_
							  "[nav] "&_
							  "[next]&gt;[/next]"
		fpagerFormat		= "[prev]��һҳ[/prev]��[next]��һҳ[/next]"
	End Sub
End Class

'���ʵ����
Dim Config
Set Config = new Config_
%>