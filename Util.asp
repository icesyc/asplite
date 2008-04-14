<%
' 工具对象,包括一些常用函数
'
' @package    asplite
' @author     ice_berg16(寻梦的稻草人)
' @copyright  ice_berg16@163.com
' @version    $Id$

'全局变量，ADODB连接对象
Dim Conn

'数据库连接函数
Function initDB()
	str = ""
	If Config.dbDriver = "access" Then 
		str = "Provider = Microsoft.Jet.OLEDB.4.0;Data Source =" & Config.dbPath
	ElseIf Config.dbDriver = "sqlserver" Then
		str = "PROVIDER=SQLOLEDB.1;Data Source="&Config.dbHost&";Initial Catalog="&Config.dbName&";Persist Security Info=True;User ID="&Config.dbUser&";Password="&Config.dbPassword&";Connect Timeout=30"
	End If
	If str = "" Then halt("数据库连接语句为空")
	Set Conn = Server.CreateObject("ADODB.Connection")
	on error resume next
	Conn.open str
	If Err Then
		System.halt("对不起，数据连接错误！<br/>" & Err.description)
	End If
End Function

'判断index是否在数组arr中
Function inArray(arr, index)
	Dim find
	find = false
	For Each v In arr
		If v = index Then
			find  = true
			Exit For			
		End If 
	Next
	inArray = find
End Function

'取得整数值
Function getInt(v)
	v = Trim(v)
	If Not IsNumeric(v) Then v = 0
	getInt = CInt(v)
End Function

'集合转换
Function Collection(col)
	Set Collection = server.CreateObject("Scripting.Dictionary")
	If Not IsObject(col) Then
		Exit Function
	End if
	For Each i In col
		Collection.add i, col.Item(i)
	Next
End Function

'打印变量,用于内部递归
Function dump_(var,key, deep)
	If Not IsNull(key) Then response.write String(deep,vbTab) & key &" => "
	If TypeName(var) = "Recordset" Then 
		Response.write "(" & vbCrLf
		For Each i In var.Fields
			dump_ i, null,deep+1
		Next
		Response.write String(deep,vbTab) & ")" & vbCrlf
	ElseIf TypeName(var) = "Field" Then 
		Response.write "(" & vbCrLf
		dump_ var.Value, var.Name, deep+1
		Response.write String(deep,vbTab) & ")" & vbCrlf
	ElseIf IsObject(var) And TypeName(var) <> "IStringList" Then 
		Response.write "(" & vbCrLf
		For Each i In var
			dump_ var(i), i, deep+1
		Next
		Response.write String(deep,vbTab) & ")" & vbCrlf
	ElseIf IsArray(var) Then 
		Response.write "(" & vbCrLf
		cnt = UBound(var)
		For i = 0 To cnt
			dump_ var(i), i, deep+1
		Next 
		Response.write String(deep,vbTab) & ")" & vbCrlf
	Else
		response.write Server.HtmlEncode(var) &"("& TypeName(var) &")" & vbCrlf
	End If
End Function

'打印变量,不能打印多维数组
Function dump(var)
	dump_ var, null, 0
End Function

'IIF ()函数 三元判断符 
Public Function IIF(expression, vTrue, vFalse)
	If expression Then IIF = vTrue Else IIF = vFalse
End Function

'echo 方法 代替（Response.write 方法）
Public Sub echo(str)
	Response.write str
End Sub

'halt 方法 代替 (Response.End 方法)
Public Sub halt(strStr)
	If strStr <> "" Then echo strStr & "<br />"
	Response.End
End Sub

'新建一个fSO对象
Function newFS()
	Set newFS = server.CreateObject("Scripting.FileSystemObject")
End Function 

'新建一个集合
Function newCol()
	Set newCol = server.CreateObject("Scripting.Dictionary")
End Function

'新建一个rs对象
Function newRS()
	'如果没有连接数据库，自动连接
	If TypeName(Conn) <> "Connection" Then  initDB()
	Set newRS = server.CreateObject("adodb.recordset")
End Function 

'新建一个model对象
Function model(tblName)
	Set model = new Model_
	model.table = Config.tablePre & tblName
	Set schema = Conn.OpenSchema(28,Array(empty,empty,model.table))
	If schema.eof And schema.bof Then System.halt("表 "&model.table& " 不存在")
	model.PK = schema("column_name")
	schema.close
	Set schema = nothing
End Function

'新建一个模板对象
Function view(filePath)
	Set view = new Template
	view.dir = Config.viewPath
	view.setFile filePath
End Function

'新建一个tree对象
Function tree(tblName)
	Set tree = new Tree_
	tree.table = Config.tablePre & tblName
	Set schema = Conn.OpenSchema(28,Array(empty,empty,tree.table))
	If schema.eof And schema.bof Then System.halt("表 "&tree.table& " 不存在")
	tree.PK = schema("column_name")
	schema.close
	Set schema = nothing
End Function

'生成fckeditor内容
Function editor(width, height, field, value)
	Set e = new FCKeditor
	e.basePath = Config.editorPath
	e.width = width
	e.Height = height
	e.ToolbarSet = "Normal"
	e.Value = value
	editor = e.CreateHtml("content")
End Function

'生成一个分页对象
Function pager(currentPage, recordCount, pageSize)
	Set pager = new Pager_
	pager.currentPage = currentPage
	pager.recordCount = recordCount
	pager.pageSize	  = pageSize
	pager.formatStr	  = Config.pagerFormat
End Function

'使用模板的消息显示
Sub message(msg, msgType)
	Set v = view("admin/"&msgType&".htm")
	v.assign "message", msg
	v.display
	Set v = Nothing
	resposne.End
End Sub

'alert并返回
Sub alert(msg)
	response.write "<script type='text/javascript'>alert("""&msg&""");history.back()</script>"
	response.End
End Sub

'返回目录名
Function dirname(f)
	dirname = Mid(f,1,InstrRev(f,"\")-1)
End Function

'返回文件名
Function basename(f)
	basename = Mid(f,InstrRev(f,"\")+1)
End Function
%>