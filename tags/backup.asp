<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/FileUploader.asp" -->
<!-- #include file="session.asp" -->
<%
'���ݿⱸ����ָ�

Set fso = newFS

'����
Sub backup

	If System.isPost Then
		saveType = Trim(Request.Form("saveType"))
		If Not fso.fileExists(Config.dbPath) Then System.halt("ָ�������ݿ��ļ�������")

		If saveType = "server" Then	'���浽������
			Set f = fso.getFile(Config.dbPath)
			current = Year(now)&Month(now)&Day(now)&Hour(now)&Minute(now)&Second(now)
			newName = f.parentFolder.path &"\"&current &".mdb"
			f.copy(newName)
			message "�ɹ������ļ�Ϊ"&newName, "success"
		Else	'���ص��ͻ���
			docRoot = IIF(Config.appRoot="", "/", Config.appRoot)
			docRoot = Server.MapPath(docRoot)
			vpath   = Replace(Replace(Config.dbPath, docRoot, ""), "\", "/")
			Response.redirect(vpath)
		End If
	Else
		'�ļ��б�
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

'�ָ�
Sub restore
	Dim f,fname
	Set uploader = new FileUploader
	If uploader.Form("restoreType") = "server" Then '�������ϻָ�
		fname = Replace(Trim(uploader.Form("fname")), Chr(0), "")
		path = dirname(Config.dbPath) & "\" & fname
	Else '�����ϴ��ָ�
		Set f   = uploader.file.Item("dbfile")
		'�ж��ļ�����
		If f.FileExt <> "mdb" Then message "�ϴ����ļ����Ͳ���ȷ��ֻ���ϴ�mdb��ʽ", "error"
		'�����ϴ����ļ�
		fname = uploader.autoSave("dbfile", dirname(Config.dbPath))
		path = dirname(Config.dbPath) & "\" & fname
	End If
	If Not fso.fileExists(path) Then System.halt("Ҫ�ָ������ݿ��ļ������� ->" &path)
	If fso.FileExists(Config.dbPath) Then fso.deleteFile(Config.dbPath)
	fso.copyFile path, Config.dbPath
	message "���ݿ��ļ��ָ��ɹ�", "success"
End Sub

'����
Sub download
	fname = Replace(Trim(Request.QueryString("fname")), Chr(0), "")
	path = dirname(Config.dbPath) & "\" & fname
	If Not fso.fileExists(path) Then System.halt("ָ�������ݿ��ļ������� ->" &path)
	docRoot = IIF(Config.appRoot="", "/", Config.appRoot)
	docRoot = Server.MapPath(docRoot)
	vpath   = Replace(Replace(path, docRoot, ""), "\", "/")
	Response.redirect(vpath)
End Sub

'ɾ��
Sub delete
	fname = Replace(Trim(Request.QueryString("fname")), Chr(0), "")
	ftype = Mid(fname, InstrRev(fname,".")+1)
	If ftype <> "mdb" Then System.halt("ָ�����ļ��������ݿ��ļ� ->" & fname)
	path = dirname(Config.dbPath) & "\" & fname
	If Not fso.fileExists(path) Then System.halt("ָ�������ݿ��ļ������� ->" &path)
	fso.deleteFile(path)
	Response.redirect("backup.asp")
End Sub

Config.pageActList = "backup,restore,download,delete"
Config.defaultAction = "backup"
System.run
Set fso = nothing
Set System = Nothing
%>