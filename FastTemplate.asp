<%
'Asp FastTemplate_Class
'author So_Flying

Class FastTemplate

	Public L				'变量左边框
	Public R				'变量右边框

	Public displayType		'输出类型 0 | 1 (0-普通输出, 1-文本输出)
	Public outPutFileAddress'输出文本文件地址
	Public  strFile			'模板文件字符串
	'Private data			模版变量  [Dictionary 对象]
	'Private blockData_a	区块字符字典	[Dictionary 对象]
	'Private blockData_b	区块模版变量	[Dictionary 对象]
	Private REG				'正则对象
	Private FSO				'FileSystemObject 对象
	Private FS				'Stream 对象

	Private Sub Class_Initialize
		L = "{"
		R = "}"
		displayType = 0
		strFile = ""
		Set REG = New RegExp
			REG.IgnoreCase = True
			REG.Global = True
		Set FSO = CreateObject("Scripting.FileSystemObject")
		Set FS = CreateObject("ADODB.Stream")
	End Sub

	Private Sub Class_Terminate
		Set REG = Nothing
		Set data = Nothing
		Set blockData_a = Nothing
		Set blockData_b = Nothing
		Set tag = Nothing
		Set FSO = Nothing
		Set FS = Nothing
	End Sub

	' @access Public
	' @param String strAdd Parameter FileAddress	'加载模版
	' 加载模版文件 [以字符形式赋值到 strFile]
	Public Sub SetTemplateFile(strAdd)
		If FSO.FileExists(Server.MapPath(strAdd)) Then
			Set hndFile = FSO.OpenTextFile(Server.MapPath(strAdd),1)
			strFile = hndFile.ReadAll
			Set hndFile = Nothing
		Else
			'Throw()
		End If
		If strFile = "" Then 
			'throw()
		End If
		
	End Sub	

	' @access Public
	' @param [Dictionary 对象] objKeyVal	变量内容
	' 加载模板变量 值内容
	Public sub SetVal(ByVal objKeyVal)
		If IsObject(objKeyVal) Then
			For Each key In objKeyVal
				If key = "" Then Exit For
				strFile = Replace(strFile, L & key & R, objKeyVal.Item(key))
			Next
			objKeyVal.RemoveAll
		End If
	End sub

	' @access Public
	' @param String strKey		区块标识
	' @param Number Times		循环次数
	' @param [Dictionary 对象] objKeyVal	变量内容
	' 加载区域字符字典 值内容
	Public sub SetBlock(ByVal strKey, ByVal objKeyVal, Times)
		regStr = ""
		finishStr = ""
		tmpBeginStr = ""
		tmpEndStr = ""
		If strKey <> "" And IsObject(objKeyVal) Then
			tmpBeginStr = "<!-- BEGIN "&strKey&" -->"
			tmpEndStr = "<!-- END "&strKey&" -->"
			REG.Pattern = "<!--\s+BEGIN " & strKey & "\s+-->([\s\S.]*)<!--\s+END " & strKey & "\s+-->"
			Set matches = REG.Execute(strFile)
			For Each match In matches
				regStr =  match.Value
			Next
			For i = 0 To Times-1
				tmpStr = Replace(Replace(regStr,tmpBeginStr,""),tmpEndStr,"")
				For Each key In objKeyVal
					If Not IsArray(objKeyVal.Item(Key)) Then 
						tmpStr = Replace(tmpStr, L & key & R, objKeyVal.Item(key))
					Else
						If i > UBound(objKeyVal.Item(key)) Then
							tmpStr = Replace(tmpStr, L & key & R, "")
						Else				
							tmpStr = Replace(tmpStr, L & key & R, objKeyVal.Item(key)(i))
						End If
					End If
				Next
				finishStr = finishStr + tmpStr
			Next	
			strFile = Replace(strFile, regStr, tmpBeginStr & finishStr & tmpEndStr)
			'注销已使用过的模版变量内容
			objKeyVal.RemoveAll
		End If
	End sub

	' @access Public
	' 输出
	Public Function OutPut()
		OutPut = strFile
		If displayType = 1 Then Call CreateHTML : OutPut = outPutFileAddress
	End Function

	' @access Public
	' @param String strName
	' 注销 模版变量
	Public Sub UnSet(ByVal objKeyVal, ByVal strName)
		If objKeyVal.Exists(strName) Then objKeyVal.Remove(strName)
	End Sub
	
	' @access Private
	' 用于生成HTML文本
	Private Function CreateHTML()
		If outPutFileAddress = "" Then Quit("FastTemplate : 制定输出路径未设置.")
		Set newFile = FSO.CreateTextFile(Server.MapPath(outPutFileAddress),True,True)
		'文本分割写入
		'查过一些文章,貌似FSO不能对 30K以上的String进行操作
		i = 1
		While i <= Len(strFile)
			newFile.Write Mid(strFile,i,1024)
			i = i + 1024
		Wend
        Set newFile = Nothing
	End Function
End Class
%>