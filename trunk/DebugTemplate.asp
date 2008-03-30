<%
' 模板程序
'
' @package    asplite
' @author     ice_berg16(寻梦的稻草人)
' @copyright  ice_berg16@163.com
' @version    $Id$

Class Template

	Public dir		'模板目录
	Public template	'模板文件字符串
	Public data		'模版变量  [Dictionary 对象]
	Private fso		'fso对象
	Private reg		'正则表达式对象
	Public debug	'是否调试
	Public skipError '是否跳过错误

	'构造函数
	Public Sub Class_Initialize
		Set data = server.CreateObject("Scripting.Dictionary")
		Set fso  = server.CreateObject("Scripting.FileSystemObject")
		'初始化正则表达式
		Set reg =  new RegExp
		reg.IgnoreCase = True
		reg.Global     = True
		dir = ""
		template = ""
	End Sub

	'析构函数
	Public Sub Class_Terminate
		Set fso = Nothing
		Set data = Nothing
	End Sub

	' 加载模版文件
	' @param file 模板路径
	Public Sub setFile(file)
		If dir = "" Then e "Template.setFile : 未指定模板目录"
		template = readFile(dir & "/" & file)	
	End Sub

	'读取文件内容
	Private Function readFile(file)
		If fso.FileExists(file) Then
			readFile = fso.OpenTextFile(file,1).readAll()
		Else
			e "Template.readFile : 文件 "& file & "不存在", true
		End If
	End Function

	' 设置模板变量
	' @param key, 变量
	' @param value 值 任何类型
	Public Sub assign(key, value)		
		If IsObject(key) Then
			For Each k In key
				data.add k, key(k)
			Next
		Else
			data.add key, value
		End If
	End Sub

	' 解析模板
	' @param source 源文件
	Private Function parse()
		If template = "" Then e "Template.parse : 模板内容为空", true
		
		If debug = true Then
			e "开始解析 dir="& dir, false
			e "template"& vbCrlf & template, False
			response.write("data:<pre>")
			dump data
			response.write("</pre>")
		End if

		'分析Include
		If debug = True Then e "解析include的结果", false
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
		'解析BEGIN和END
		parse = parseBlock(template, data)
		'解析普通变量
		reg.Pattern = "\{([a-zA-Z0-9_.]+)\}"
		Set matches = reg.Execute(parse)
		parse = replaceMatch(parse, data, matches)
	End Function

	'在当前区域中解析匹配的变量
	Private Function replaceMatch(ByVal tpl, stack, matches)
		If debug = True Then e "替换变量前"& tpl, false
		replaceMatch = tpl

		Dim k,m,obj
		For Each m In matches
			k =  m.subMatches(0)
			Set obj = getStackObj(k, stack, true)
			'取得最后的键值
			If InStr(k, ".") Then k = Mid(k, InstrRev(k, ".")+1)
			replaceMatch = Replace(replaceMatch, m.value, obj.Item(k))
		Next
		If debug = True Then e "替换变量后"& replaceMatch, false
	End Function

	' 解析块 分析Begin和End
	' @param str 要解析的串
	Private Function parseBlock(Byval tpl, stack)
		Dim res
		res = tpl
		'如果要解析的块变量不存在，清除本区域
		If Not IsObject(stack) Or TypeName(stack) = "Nothing" Or TypeName(stack) = "Empty" Then
			res = ""
			Exit Function
		End If

		'循环查找标签
		reg.Pattern = "<!-- BEGIN ([a-zA-Z0-9_.]+) -->([\s\S]*?)<!-- END \1 -->"
		
		Dim matches,match,k,k2,block,replacement,obj,matches2
		Set matches = reg.Execute(tpl)
		For Each match In matches
			k =  match.subMatches(0)
			block = match.subMatches(1)
			replacement = ""
			If debug = True Then 
				e "解析 block:"& k &" 的结果", false
				e match.value & vbCrlf & k &"=>"& block, False
			End If
			Set obj = getStackObj(k, stack, false)
			'确保变量存在
			If TypeName(obj) <> "Nothing" Then 		
				If reg.test(block) Then 		
					'递归处理
					If debug = True Then 
						e "递归开始:", False
						dump block
					End If 
					block = parseBlock(block, obj)
					If debug = True Then 
						e "递归结束:", False
						dump block
					End If
				End If
				'进行本层的替换
				reg.Pattern = "\{([a-zA-Z0-9_.]+)\}"		
				Set matches2 = reg.Execute(block)
				If IsObject(obj) Then 
					If obj.exists(0) Then '二维集合
						If IsObject(obj.Item(0)) Then
							For Each k2 In obj
								replacement = replacement & replaceMatch(block, obj.Item(k2), matches2)	
							Next 
						End If
					Else '一维集合
						replacement = replaceMatch(block, obj, matches2)
					End If
				End If
				res = Replace(res, match.value, replacement)
				If debug = True Then e "本次结果" &k&" " & res, false
			End If
		Next

		'解析当前的变量
		parseBlock = res
	End Function

	' 解析key名
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
				e "Template.getStackObj : 变量 "& okey &" 不存在", false
				Exit Function
			End If
			Set getStackObj = getStackObj.Item(parent)
		Wend
		
		'如果是数字键，则强近类型为数字
		If IsNumeric(k) Then k = CInt(k)
		If Not getStackObj.exists(k) Then 						
			e "Template.getStackObj : 变量 "& okey &" 不存在", false
		End If 
		'是取值还是取键?
		If value = false Then 
			'保证键值必须是一个对象
			If Not IsObject(getStackObj.Item(k)) Then 
				e "Template.getStackObj : 变量 "& okey &" 不是一个对象", False
				Set getStackObj = nothing
			Else			
				Set getStackObj = getStackObj.Item(k)
			End If
		End If 
		If debug = True And value = False Then
			e "当前变量："& okey & " => ", false
			dump getStackObj
		End If 
	End Function

	' @access Public
	' 输出
	Public Sub display
		response.write parse()
	End Sub

	' @access Private
	' 用于生成HTML文本
	Private Function html(filePath)
		Dim res,i,newFile
		If filePath = "" Then e "Template.html : 未指定要生成的页面路径."
		res = parse()
		Set newFile = fso.CreateTextFile(Server.MapPath(filePath),True,True)
		'文本分割写入
		'查过一些文章,貌似FSO不能对 30K以上的String进行操作
		i = 1
		While i <= Len(res)
			newFile.Write Mid(res,i,1024)
			i = i + 1024
		Wend
        Set newFile = Nothing
	End Function

	'输出错误
	Private Sub e(msg, ifstop)
		response.write "<pre>"& Server.HtmlEncode(msg) &"</pre>"
		If ifstop = True Then response.End
	End Sub
End Class
%>