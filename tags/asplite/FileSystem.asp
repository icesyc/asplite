<%
'File_Option's Class [File's Info & Option]
'Author So_Flying
'Date	2007-2-26
'==================>
'Private Functions
'
'
'==================>
'Public Functions

Class FileSystem_
	Private FSO

	Private Sub Class_Initialize
		Set FSO = CreateObject("Scripting.FileSystemObject")
	End Sub

	Private Sub Class_Terminate
		Set FSO = Nothing
	End Sub

	'返回文件后缀(带'.')
	Public Function FileType(fullFileName)
		FileType = ""
		thePointAt = InStr (fullFileName,".")
		theFileNameLength = Len (fullFileName)
		If thePointAt > 0 Then FileType = Right(fullFileName,theFileNameLength - thePointAt + 1)
	End Function

	'制造标准日期文件地址
	Public Function AutoCreateFolder(aDir)
		theDir = aDir
		If Right(aDir,1) <> "/" Then theDir = theDir & "/"
		theDir = theDir & Year(Now())
		If Len(Month(Now())) = 1 Then
			theDir = theDir & "0" & Month(Now()) & "/"
		Else
			theDir = theDir & Month(Now()) & "/"
		End If
		If Len(Day(Now())) = 1 Then
			theDir = theDir & "0" & Day(Now())
		Else
			theDir = theDir & Day(Now())
		End If
		Call CreateFolder(theDir)
		AutoCreateFolder = theDir
	End Function
	
	'建立文件夹
	Public Function CreateFolder(theDir)
		Dim addArr, tmpAddr
		addArr = Split(IIF(Left(theDir,1)="/",Right(theDir,Len(theDir)-1),theDir),"/")
		tmpAddr = "/"
		For i = 0 To UBound(addArr)
			If addArr(i) = "" Then Exit For
			tmpAddr = tmpAddr & addArr(i)&"/"
			'Debug tmpAddr, 0
			If Not FSO.FolderExists(Server.MapPath(tmpAddr)) Then FSO.CreateFolder(Server.MapPath(tmpAddr))
		Next
	End Function

	'建立文件
	'@param String theDir -> 文件逻辑路径
	Public Function CreateFile(theDir)
		tmpFolderAddr = Left(theDir , InstrRev(theDir, "/"))
		tmpFileAddr = Right(theDir , Len(theDir) - InstrRev(theDir,"/"))
		Call CreateFolder(tmpFolderAddr)
		Set CreateFile = FSO.CreateTextFile(Server.MapPath(theDir),True)
	End Function

	'删除文件
	Public Function DeleteFile(theDir)
		If FSO.FileExists(Server.MapPath(theDir)) Then
			FSO.DeleteFile(Server.MapPath(theDir))
		End If
	End Function
	
	'删除文件夹
	Public Function DeleteFolder(theDir)
		Dim tmpAddr, tmpFiles, tmpFolder
		tmpAddr = theDir
		If Right(theDir, 1) <> "/" Then tmpAddr = tmpAddr & "/"
		If Not FSO.FolderExists(Server.MapPath(tmpAddr)) Then Exit Function
		Set tmpFolder = FSO.GetFolder(Server.MapPath(tmpAddr))
		Set tmpFiles = tmpFolder.Files
		For Each xFile In tmpFiles
			xFile.Delete
		Next
		For Each xFolder In tmpFolder.SubFolders
			If xFolder.size > 0 Then Call DeleteFolder(tmpAddr & xFolder.Name)
			xFolder.Delete
		Next
		Set tmpFolder = FSO.GetFolder(Server.MapPath(theDir))
			tmpFolder.Delete
	End Function

	'以流方式读取文件内容
	Public Function ReadAll(theDir)
		ReadAll = ""
		If FSO.FileExists(Server.MapPath(theDir)) Then
			Set tmpRead = FSO.OpenTextFile(Server.MapPath(theDir),1)
			ReadAll = tmpRead.ReadAll()
		End If
	End Function
End Class

Dim FS
Set FS = new FileSystem_
%>