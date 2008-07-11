<!-- #include file="asplite/Init.asp" -->
<!-- #include file="asplite/FileUploader.asp" -->
<!-- #include file="session.asp" -->
<%
'��Դ������
Set fso = newFS
rootFolder = Config.userfiles
docRoot = Server.MapPath("/")
'����IIS5,�̷�ΪСд,���ļ�·�����̷�Ϊ��д,����Ҫת���ɴ�д
docRoot = UCase(Left(docRoot,1)) & Mid(docRoot,2)
availIcon = Array("ai","avi","bmp","cs","dll","doc","exe","fla","gif","htm","html","jpg","js","mdb","mp3","pdf","png","ppt","rar","swf","swt","txt","vsd","wmv","xls","xml","zip")

Function getIcon(ByVal name)
	Dim ext 
	ext = LCase(IIF(InStr(name,"."), Mid(name, InstrRev(name,".")+1), ""))
	getIcon = IIF(ext="", "default", IIF(inArray(availIcon, ext), ext, "default"))
End Function
'�б�
Sub default
	path = request.querystring("path")
	If path = "" Then 
		path = rootFolder
		parentFolder = rootFolder
	Else
		parentFolder =  Mid(path,1,InstrRev(path,"/")-1)
	End If
	If Left(path,Len(rootFolder)) <> rootFolder Then message "���·�����ܷ���", "error"
	rpath = server.mapPath(path)
	If Not fso.FolderExists(rpath) Then message "����ļ��в�����", "error"
	Set curFolder = fso.getFolder(rpath)
	'ȡ��������Ŀ¼
	Set folderList = newCol
	i = 0
	For Each sf In curFolder.subFolders
		Set tmpCol = newCol
		tmpCol.add "name", sf.Name
		tmpCol.add "type", sf.Type
		tmpCol.add "created", sf.DateCreated
		tmpCol.add "size", sizeCount(sf.Size)
		tmpCol.add "path", server.urlEncode(Replace(Replace(sf.Path, docRoot, ""), "\", "/"))
		folderList.add i, tmpCol
		i = i + 1
	Next
	
	Set fileList = newCol
	i = 0
	For Each f In curFolder.Files
		Set tmpCol = newCol
		tmpCol.add "icon", getIcon(f.Name)
		tmpCol.add "name", f.Name
		tmpCol.add "type", f.Type
		tmpCol.add "size", sizeCount(f.Size)
		tmpCol.add "created", f.DateCreated
		tmpCol.add "vpath", Replace(Replace(f.Path, docRoot, ""), "\", "/")
		tmpCol.add "path", server.urlEncode(Replace(Replace(f.Path, docRoot, ""), "\", "/"))
		fileList.add i, tmpCol
		i = i + 1
	Next
	Set vod = model("vod")
	
	Set vodlist = vod.findAll(null,"*", "id asc", 1, 20)


	Set v = view("admin/vod_list.htm")
	v.assign "vodlist", vodlist
	v.assign "path", path
	v.display
	Set folderList = nothing
	Set v = Nothing
End Sub

'ɾ��
Sub delete
	id = request.querystring("f")
	set m = model("vod")
	set url = m.findAll("id="&id,"*",null,1 ,1 )
	f = url(0).Item("url")
	If Left(f,Len(rootFolder)) <> rootFolder Then message "���·�����ܷ���", "error"
	f = server.mapPath(f)
	If fso.fileExists(f) Then
		fso.deleteFile(f)
		m.delete(id)
		System.goBack
	Else
		message "�Բ�������ļ�������", "error"
	End If 
End Sub

Sub deleteFolder
	f = request.querystring("f")
	If Left(f,Len(rootFolder)) <> rootFolder Then message "���·�����ܷ���", "error"
	folder = server.mapPath(f)
	If fso.folderExists(folder) Then
		fso.deleteFolder(folder)
		System.goBack
	Else
		message "�Բ�������ļ��в�����", "error"
	End If 
End Sub


'�ϴ��ļ�
Sub upload
	Dim allowExt
	allowExt = "7z|aiff|asf|avi|bmp|csv|doc|fla|flv|gif|gz|gzip|jpeg|jpg|mid|mov|mp3|mp4|mpc|mpeg|mpg|ods|odt|pdf|png|ppt|pxd|qt|ram|rar|rm|rmi|rmvb|rtf|sdc|sitd|swf|sxc|sxw|tar|tgz|tif|tiff|txt|vsd|wav|wma|wmv|xls|xml|zip"
	allowExt = Split(allowExt, "|")
	Set uploader = new FileUploader
	folder =  uploader.Form("folder")&"/vod"
	Set f  = uploader.file.Item("file")
	If Left(folder,Len(rootFolder)) <> rootFolder Then message "���·�����ܷ���", "error"
	If Not inArray(allowExt,f.FileExt) Then message "���ļ����Ͳ������ϴ�", "error"
	realPath = server.mapPath(folder&"/"& f.fileName)
	If fso.fileExists(realPath) Then message "�ļ��Ѿ�����", "error"
		'д������
		vod_url = folder&"/"& f.fileName
		set vod = newCol
		vod.add "url", vod_url
		set m = model("vod")
		m.create(vod)

	uploader.saveToFile "file", realPath
	Set uploader = Nothing
	Set f = Nothing
	System.goBack
End Sub
Config.pageActList = "default,delete,deleteFolder,createFolder,upload"
System.run
Set fso = nothing
Set System = Nothing
Set fs = nothing
%>