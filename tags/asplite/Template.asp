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
		If dir = "" Then e "Template.setFile : 未指定模板目录", true
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

		'分析Include
		reg.Pattern = "<!-- INCLUDE ([a-zA-Z0-9_.\/]+) -->"
		Set matches = reg.Execute(template)

		Dim fname, subtemplate
		For Each match In matches
			fname = match.submatches(0)
			subtemplate = readFile(dir & "/" & fname)
			template = Replace(template, match.value, subtemplate)
		Next
		'解析BEGIN和END
		parse = parseBlock(template, data)
		'解析普通变量
		reg.Pattern = "\{([a-zA-Z0-9_.]+)\}"
		Set matches = reg.Execute(parse)
		parse = replaceMatch(parse, data, matches)
	End Function

	'在当前区域中解析匹配的变量
	Private Function replaceMatch(ByVal tpl, stack, matches)
		replaceMatch = tpl

		Dim k,m,obj
		For Each m In matches
			k =  m.subMatches(0)
			Set obj = getStackObj(k, stack, true)
			'取得最后的键值
			If InStr(k, ".") Then k = Mid(k, InstrRev(k, ".")+1)
			replaceMatch = Replace(replaceMatch, m.value, obj.Item(k))
		Next
	End Function

	' 解析块 分析Begin和End
	' @param str 要解析的串
	Private Function parseBlock(Byval tpl, stack)
		Dim res
		res = tpl
		'如果要解析的块变量不是对象则返回
		If TypeName(stack) <> "Dictionary"Then
			parseBlock = res
			Exit Function
		End If
		'如果解析的变量不是顶级，并且没有对应的数据则清空此部分
		If Not stack Is data And stack.Count = 0 Then
			parseBlock = ""
			Exit Function
		End If		
		Dim matches,match,k,k2,block,replacement,obj,subobj,matches2,blockReg

		'循环查找标签
		Set blockReg = new RegExp
		blockReg.Pattern = "<!-- BEGIN ([a-zA-Z0-9_.]+) -->([\s\S]*?)<!-- END \1 -->"
		blockReg.IgnoreCase = True
		blockReg.Global     = True

		Set matches = blockReg.Execute(tpl)
		For Each match In matches
			k =  match.subMatches(0)
			block = match.subMatches(1)
			replacement = ""
			Set obj = getStackObj(k, stack, false)
			'确保变量存在
			If TypeName(obj) <> "Nothing" Then
				'进行本层的替换
				reg.Pattern = "\{([a-zA-Z0-9_.]+)\}"		
				Set matches2 = reg.Execute(block)
				If TypeName(obj) = "Dictionary" And obj.Count > 0 Then
					If obj.exists(0) Then '二维集合
						If TypeName(obj.Item(0)) = "Dictionary" Then						
							If blockReg.test(block) Then '递归处理
								For Each k2 In obj
									Set subobj = getStackObj(k2, obj, false)
									block = parseBlock(block, subobj)
									replacement = replacement & replaceMatch(block, obj.Item(k2), matches2)	
								Next 
							Else							
								For Each k2 In obj
									replacement = replacement & replaceMatch(block, obj.Item(k2), matches2)	
								Next 
							End If
						End If
					Else '一维集合
						For Each k2 In obj
							replacement = replacement & Replace(Replace(block, "{key}", k2), "{value}", obj.Item(k2))
						Next
					End If
				End If
				res = Replace(res, match.value, replacement)
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
			If TypeName(getStackObj.Item(k)) <> "Dictionary" Then 
				e "Template.getStackObj : 变量 "& okey &" 不是一个Dictionary对象", False
				Set getStackObj = nothing
			Else			
				Set getStackObj = getStackObj.Item(k)
			End If
		End If 
	End Function

	' @access Public
	' 输出
	Public Sub display
		response.write parse()
		response.End
	End Sub

	' 用于生成HTML文本
	Public Function html(filePath)
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