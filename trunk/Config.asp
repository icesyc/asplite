<%
' 应用程序配置文件
'
' @package    asplite
' @author     ice_berg16(寻梦的稻草人)
' @copyright  ice_berg16@163.com
' @version    $Id$

Class Config_

	'应用程序路径
	Public appRoot

	'数据库文件位置
	Public dbPath
	
	'数据库类型 sqlserver|access
	Public dbDriver

	'------ 如果为sql server 则需要指定以下配置 -----------

	'数据库的服务器地址
	Public dbHost
	
	'数据库的用户名
	Public dbUser

	'数据库的密码
	Public dbPassword

	'数据库的名称
	Public dbName

	'数据库的前缀
	Public tablePre

	'Session的超时设置,单位为分钟
	Public sessionTime

	'URL命令名称
	Public urlCommand

	'默认执行的动作
	Public defaultAction

	'程序名称
	Public appName

	'当前页面可用的动作列表
	Public pageActList

	'上传的文件路径
	Public uploadPath

	'分页样式
	Public pagerFormat

	'前台分页样式
	Public fpagerFormat

	Private Sub Class_Initialize
		appRoot				= ""
		dbPath				= Server.MapPath(appRoot & "/core/db/webapp.mdb")
		dbDriver			= "access"
		urlCommand			= "act"
		sessionTime			= 30
		appName				= "asp程序"
		defaultAction		= "default"
		tablePre			= "ice_"
		pageActList			= "default,add,update,delete"
		thumbPath			= appRoot & "/thumb"
		pagerFormat			= "Pages: <span class=""red"">[current]</span>/<span class=""red"">[total]</span> "&_
							  "Total: <span class=""red"">[recordCount]</span> "&_
							  "[prev]&lt;[/prev] "&_
							  "[nav] "&_
							  "[next]&gt;[/next]"
		fpagerFormat		= "[prev]上一页[/prev]　[next]下一页[/next]"
	End Sub
End Class

'类的实例化
Set Config = new Config_
%>