<%
'Asp FastTemplate_Class
'author So_Flying

Class FastTemplate

	Public L				'������߿�
	Public R				'�����ұ߿�

	Public displayType		'������� 0 | 1 (0-��ͨ���, 1-�ı����)
	Public outPutFileAddress'����ı��ļ���ַ
	Public  strFile			'ģ���ļ��ַ���
	'Private data			ģ�����  [Dictionary ����]
	'Private blockData_a	�����ַ��ֵ�	[Dictionary ����]
	'Private blockData_b	����ģ�����	[Dictionary ����]
	Private REG				'�������
	Private FSO				'FileSystemObject ����
	Private FS				'Stream ����

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
	' @param String strAdd Parameter FileAddress	'����ģ��
	' ����ģ���ļ� [���ַ���ʽ��ֵ�� strFile]
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
	' @param [Dictionary ����] objKeyVal	��������
	' ����ģ����� ֵ����
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
	' @param String strKey		�����ʶ
	' @param Number Times		ѭ������
	' @param [Dictionary ����] objKeyVal	��������
	' ���������ַ��ֵ� ֵ����
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
			'ע����ʹ�ù���ģ���������
			objKeyVal.RemoveAll
		End If
	End sub

	' @access Public
	' ���
	Public Function OutPut()
		OutPut = strFile
		If displayType = 1 Then Call CreateHTML : OutPut = outPutFileAddress
	End Function

	' @access Public
	' @param String strName
	' ע�� ģ�����
	Public Sub UnSet(ByVal objKeyVal, ByVal strName)
		If objKeyVal.Exists(strName) Then objKeyVal.Remove(strName)
	End Sub
	
	' @access Private
	' ��������HTML�ı�
	Private Function CreateHTML()
		If outPutFileAddress = "" Then Quit("FastTemplate : �ƶ����·��δ����.")
		Set newFile = FSO.CreateTextFile(Server.MapPath(outPutFileAddress),True,True)
		'�ı��ָ�д��
		'���һЩ����,ò��FSO���ܶ� 30K���ϵ�String���в���
		i = 1
		While i <= Len(strFile)
			newFile.Write Mid(strFile,i,1024)
			i = i + 1024
		Wend
        Set newFile = Nothing
	End Function
End Class
%>