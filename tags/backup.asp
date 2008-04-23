<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/FileUploader.asp" -->
<!-- #include file="session.asp" -->
<%
'数据库备份与恢复

Set fso = newFS

'备份
Sub backup

	If System.isPost Then
		saveType = Trim(Request.Form("saveType"))
		If Not fso.fileExists(Config.dbPath) Then System.halt("指定的数据库文件不存在")

		If saveType = "server" Then	'保存到服务器
			Set f = fso.getFile(Config.dbPath)
			current = Year(now)&Month(now)&Day(now)&Hour(now)&Minute(now)&Second(now)
			newName = f.parentFolder.path &"\"&current &".mdb"
			f.copy(newName)
			message "成功备份文件为"&newName, "success"
		Else	'下载到客户端
			docRoot = IIF(Config.appRoot="", "/", Config.appRoot)
			docRoot = Server.MapPath(docRoot)
			vpath   = Replace(Replace(Config.dbPath, docRoot, ""), "\", "/")
			Response.redirect(vpath)
		End If
	Else
		'文件列表
		Set fileList = newCol
		dbFolder = dirname(Config.dbPath)
		dbName   = basename(Config.dbPath)
		Set files = fso.getFolder(dbFolder).files
		i = 0
		For Each f In files
			If f.Name <> dbName Then 
				Set ff = newCol
				ff.add "file", f.name
				fileList.add i, ff
				i = i + 1
			End If
		Next

		Set v = view("admin/backup.htm")
		v.assign "fileList", fileList
		v.assign "dbPath", Config.dbPath
		v.display
		Set v = Nothing
		Set fso = Nothing
	End If
End Sub

'恢复
Sub restore
	Dim f,fname
	Set uploader = new FileUploader
	If uploader.Form("restoreType") = "server" Then '服务器上恢复
		fname = Replace(Trim(uploader.Form("fname")), Chr(0), "")
		path = dirname(Config.dbPath) & "\" & fname
	Else '本地上传恢复
		Set f   = uploader.file.Item("dbfile")
		'判断文件类型
		If f.FileExt <> "mdb" Then message "上传的文件类型不正确，只能上传mdb格式", "error"
		'保存上传的文件
		fname = uploader.autoSave("dbfile", dirname(Config.dbPath))
		path = dirname(Config.dbPath) & "\" & fname
	End If
	If Not fso.fileExists(path) Then System.halt("要恢复的数据库文件不存在 ->" &path)
	If fso.FileExists(Config.dbPath) Then fso.deleteFile(Config.dbPath)
	fso.copyFile path, Config.dbPath
	message "数据库文件恢复成功", "success"
End Sub

'下载
Sub download
	fname = Replace(Trim(Request.QueryString("fname")), Chr(0), "")
	path = dirname(Config.dbPath) & "\" & fname
	If Not fso.fileExists(path) Then System.halt("指定的数据库文件不存在 ->" &path)
	docRoot = IIF(Config.appRoot="", "/", Config.appRoot)
	docRoot = Server.MapPath(docRoot)
	vpath   = Replace(Replace(path, docRoot, ""), "\", "/")
	Response.redirect(vpath)
End Sub

'删除
Sub delete
	fname = Replace(Trim(Request.QueryString("fname")), Chr(0), "")
	ftype = Mid(fname, InstrRev(fname,".")+1)
	If ftype <> "mdb" Then System.halt("指定的文件不是数据库文件 ->" & fname)
	path = dirname(Config.dbPath) & "\" & fname
	If Not fso.fileExists(path) Then System.halt("指定的数据库文件不存在 ->" &path)
	fso.deleteFile(path)
	Response.redirect("backup.asp")
End Sub

Config.pageActList = "backup,restore,download,delete"
Config.defaultAction = "backup"
System.run
Set fso = nothing
Set System = Nothing
%>