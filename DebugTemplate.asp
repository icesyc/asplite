<%
' ģ�����
'
' @package    asplite
' @author     ice_berg16(Ѱ�εĵ�����)
' @copyright  ice_berg16@163.com
' @version    $Id$

Class Template

	Public dir		'ģ��Ŀ¼
	Public template	'ģ���ļ��ַ���
	Public data		'ģ�����  [Dictionary ����]
	Private fso		'fso����
	Private reg		'������ʽ����
	Public debug	'�Ƿ����
	Public skipError '�Ƿ���������

	'���캯��
	Public Sub Class_Initialize
		Set data = server.CreateObject("Scripting.Dictionary")
		Set fso  = server.CreateObject("Scripting.FileSystemObject")
		'��ʼ��������ʽ
		Set reg =  new RegExp
		reg.IgnoreCase = True
		reg.Global     = True
		dir = ""
		template = ""
	End Sub

	'��������
	Public Sub Class_Terminate
		Set fso = Nothing
		Set data = Nothing
	End Sub

	' ����ģ���ļ�
	' @param file ģ��·��
	Public Sub setFile(file)
		If dir = "" Then e "Template.setFile : δָ��ģ��Ŀ¼"
		template = readFile(dir & "/" & file)	
	End Sub

	'��ȡ�ļ�����
	Private Function readFile(file)
		If fso.FileExists(file) Then
			readFile = fso.OpenTextFile(file,1).readAll()
		Else
			e "Template.readFile : �ļ� "& file & "������", true
		End If
	End Function

	' ����ģ�����
	' @param key, ����
	' @param value ֵ �κ�����
	Public Sub assign(key, value)		
		If IsObject(key) Then
			For Each k In key
				data.add k, key(k)
			Next
		Else
			data.add key, value
		End If
	End Sub

	' ����ģ��
	' @param source Դ�ļ�
	Private Function parse()
		If template = "" Then e "Template.parse : ģ������Ϊ��", true
		
		If debug = true Then
			e "��ʼ���� dir="& dir, false
			e "template"& vbCrlf & template, False
			response.write("data:<pre>")
			dump data
			response.write("</pre>")
		End if

		'����Include
		If debug = True Then e "����include�Ľ��", false
		reg.Pattern = "<!-- INCLUDE ([a-zA-Z0-9_.\/]+) -->"
		Set matches = reg.Execute(template)

		Dim fname, subtemplate
		For Each match In matches
			fname = match.submatches(0)
			subtemplate = readFile(dir & "/" & fname)
			template = Replace(template, match.value, subtemplate)
			If debug = True Then e match.value &" -> "& dir & "/"& fname, false
		Next
		If debug = True Then 
			e template, false
		End If
		'����BEGIN��END
		parse = parseBlock(template, data)
		'������ͨ����
		reg.Pattern = "\{([a-zA-Z0-9_.]+)\}"
		Set matches = reg.Execute(parse)
		parse = replaceMatch(parse, data, matches)
	End Function

	'�ڵ�ǰ�����н���ƥ��ı���
	Private Function replaceMatch(ByVal tpl, stack, matches)
		If debug = True Then e "�滻����ǰ"& tpl, false
		replaceMatch = tpl

		Dim k,m,obj
		For Each m In matches
			k =  m.subMatches(0)
			Set obj = getStackObj(k, stack, true)
			'ȡ�����ļ�ֵ
			If InStr(k, ".") Then k = Mid(k, InstrRev(k, ".")+1)
			replaceMatch = Replace(replaceMatch, m.value, obj.Item(k))
		Next
		If debug = True Then e "�滻������"& replaceMatch, false
	End Function

	' ������ ����Begin��End
	' @param str Ҫ�����Ĵ�
	Private Function parseBlock(Byval tpl, stack)
		Dim res
		res = tpl
		'���Ҫ�����Ŀ���������ڣ����������
		If Not IsObject(stack) Or TypeName(stack) = "Nothing" Or TypeName(stack) = "Empty" Then
			res = ""
			Exit Function
		End If

		'ѭ�����ұ�ǩ
		reg.Pattern = "<!-- BEGIN ([a-zA-Z0-9_.]+) -->([\s\S]*?)<!-- END \1 -->"
		
		Dim matches,match,k,k2,block,replacement,obj,matches2
		Set matches = reg.Execute(tpl)
		For Each match In matches
			k =  match.subMatches(0)
			block = match.subMatches(1)
			replacement = ""
			If debug = True Then 
				e "���� block:"& k &" �Ľ��", false
				e match.value & vbCrlf & k &"=>"& block, False
			End If
			Set obj = getStackObj(k, stack, false)
			'ȷ����������
			If TypeName(obj) <> "Nothing" Then 		
				If reg.test(block) Then 		
					'�ݹ鴦��
					If debug = True Then 
						e "�ݹ鿪ʼ:", False
						dump block
					End If 
					block = parseBlock(block, obj)
					If debug = True Then 
						e "�ݹ����:", False
						dump block
					End If
				End If
				'���б�����滻
				reg.Pattern = "\{([a-zA-Z0-9_.]+)\}"		
				Set matches2 = reg.Execute(block)
				If IsObject(obj) Then 
					If obj.exists(0) Then '��ά����
						If IsObject(obj.Item(0)) Then
							For Each k2 In obj
								replacement = replacement & replaceMatch(block, obj.Item(k2), matches2)	
							Next 
						End If
					Else 'һά����
						replacement = replaceMatch(block, obj, matches2)
					End If
				End If
				res = Replace(res, match.value, replacement)
				If debug = True Then e "���ν��" &k&" " & res, false
			End If
		Next

		'������ǰ�ı���
		parseBlock = res
	End Function

	' ����key��
	' {key}  -> obj("key")
	' {example.key}  -> obj("example")("key")
	' {top.key} -> data("key")
	Private Function getStackObj(ByVal k, stack, value)
		Dim okey,parent
		okey = k
		If Mid(k,1,4) = "top." Then 
			Set getStackObj = data
			k = Mid(k,5)
		Else 
			Set getStackObj = stack
		End If
		
		While InStr(k,".") > 0 
			parent = Mid(k,1,InStr(k,".")-1)
			k = Mid(k,InStr(k,".")+1)
			If Not getStackObj.exists(parent) Then 				
				e "Template.getStackObj : ���� "& okey &" ������", false
				Exit Function
			End If
			Set getStackObj = getStackObj.Item(parent)
		Wend
		
		'��������ּ�����ǿ������Ϊ����
		If IsNumeric(k) Then k = CInt(k)
		If Not getStackObj.exists(k) Then 						
			e "Template.getStackObj : ���� "& okey &" ������", false
		End If 
		'��ȡֵ����ȡ��?
		If value = false Then 
			'��֤��ֵ������һ������
			If Not IsObject(getStackObj.Item(k)) Then 
				e "Template.getStackObj : ���� "& okey &" ����һ������", False
				Set getStackObj = nothing
			Else			
				Set getStackObj = getStackObj.Item(k)
			End If
		End If 
		If debug = True And value = False Then
			e "��ǰ������"& okey & " => ", false
			dump getStackObj
		End If 
	End Function

	' @access Public
	' ���
	Public Sub display
		response.write parse()
	End Sub

	' @access Private
	' ��������HTML�ı�
	Private Function html(filePath)
		Dim res,i,newFile
		If filePath = "" Then e "Template.html : δָ��Ҫ���ɵ�ҳ��·��."
		res = parse()
		Set newFile = fso.CreateTextFile(Server.MapPath(filePath),True,True)
		'�ı��ָ�д��
		'���һЩ����,ò��FSO���ܶ� 30K���ϵ�String���в���
		i = 1
		While i <= Len(res)
			newFile.Write Mid(res,i,1024)
			i = i + 1024
		Wend
        Set newFile = Nothing
	End Function

	'�������
	Private Sub e(msg, ifstop)
		response.write "<pre>"& Server.HtmlEncode(msg) &"</pre>"
		If ifstop = True Then response.End
	End Sub
End Class
%>