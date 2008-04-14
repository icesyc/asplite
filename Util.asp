<%
' ���߶���,����һЩ���ú���
'
' @package    asplite
' @author     ice_berg16(Ѱ�εĵ�����)
' @copyright  ice_berg16@163.com
' @version    $Id$

'ȫ�ֱ�����ADODB���Ӷ���
Dim Conn

'���ݿ����Ӻ���
Function initDB()
	str = ""
	If Config.dbDriver = "access" Then 
		str = "Provider = Microsoft.Jet.OLEDB.4.0;Data Source =" & Config.dbPath
	ElseIf Config.dbDriver = "sqlserver" Then
		str = "PROVIDER=SQLOLEDB.1;Data Source="&Config.dbHost&";Initial Catalog="&Config.dbName&";Persist Security Info=True;User ID="&Config.dbUser&";Password="&Config.dbPassword&";Connect Timeout=30"
	End If
	If str = "" Then halt("���ݿ��������Ϊ��")
	Set Conn = Server.CreateObject("ADODB.Connection")
	on error resume next
	Conn.open str
	If Err Then
		System.halt("�Բ����������Ӵ���<br/>" & Err.description)
	End If
End Function

'�ж�index�Ƿ�������arr��
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

'ȡ������ֵ
Function getInt(v)
	v = Trim(v)
	If Not IsNumeric(v) Then v = 0
	getInt = CInt(v)
End Function

'����ת��
Function Collection(col)
	Set Collection = server.CreateObject("Scripting.Dictionary")
	If Not IsObject(col) Then
		Exit Function
	End if
	For Each i In col
		Collection.add i, col.Item(i)
	Next
End Function

'��ӡ����,�����ڲ��ݹ�
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

'��ӡ����,���ܴ�ӡ��ά����
Function dump(var)
	dump_ var, null, 0
End Function

'IIF ()���� ��Ԫ�жϷ� 
Public Function IIF(expression, vTrue, vFalse)
	If expression Then IIF = vTrue Else IIF = vFalse
End Function

'echo ���� ���棨Response.write ������
Public Sub echo(str)
	Response.write str
End Sub

'halt ���� ���� (Response.End ����)
Public Sub halt(strStr)
	If strStr <> "" Then echo strStr & "<br />"
	Response.End
End Sub

'�½�һ��fSO����
Function newFS()
	Set newFS = server.CreateObject("Scripting.FileSystemObject")
End Function 

'�½�һ������
Function newCol()
	Set newCol = server.CreateObject("Scripting.Dictionary")
End Function

'�½�һ��rs����
Function newRS()
	'���û���������ݿ⣬�Զ�����
	If TypeName(Conn) <> "Connection" Then  initDB()
	Set newRS = server.CreateObject("adodb.recordset")
End Function 

'�½�һ��model����
Function model(tblName)
	Set model = new Model_
	model.table = Config.tablePre & tblName
	Set schema = Conn.OpenSchema(28,Array(empty,empty,model.table))
	If schema.eof And schema.bof Then System.halt("�� "&model.table& " ������")
	model.PK = schema("column_name")
	schema.close
	Set schema = nothing
End Function

'�½�һ��ģ�����
Function view(filePath)
	Set view = new Template
	view.dir = Config.viewPath
	view.setFile filePath
End Function

'�½�һ��tree����
Function tree(tblName)
	Set tree = new Tree_
	tree.table = Config.tablePre & tblName
	Set schema = Conn.OpenSchema(28,Array(empty,empty,tree.table))
	If schema.eof And schema.bof Then System.halt("�� "&tree.table& " ������")
	tree.PK = schema("column_name")
	schema.close
	Set schema = nothing
End Function

'����fckeditor����
Function editor(width, height, field, value)
	Set e = new FCKeditor
	e.basePath = Config.editorPath
	e.width = width
	e.Height = height
	e.ToolbarSet = "Normal"
	e.Value = value
	editor = e.CreateHtml("content")
End Function

'����һ����ҳ����
Function pager(currentPage, recordCount, pageSize)
	Set pager = new Pager_
	pager.currentPage = currentPage
	pager.recordCount = recordCount
	pager.pageSize	  = pageSize
	pager.formatStr	  = Config.pagerFormat
End Function

'ʹ��ģ�����Ϣ��ʾ
Sub message(msg, msgType)
	Set v = view("admin/"&msgType&".htm")
	v.assign "message", msg
	v.display
	Set v = Nothing
	resposne.End
End Sub

'alert������
Sub alert(msg)
	response.write "<script type='text/javascript'>alert("""&msg&""");history.back()</script>"
	response.End
End Sub

'����Ŀ¼��
Function dirname(f)
	dirname = Mid(f,1,InstrRev(f,"\")-1)
End Function

'�����ļ���
Function basename(f)
	basename = Mid(f,InstrRev(f,"\")+1)
End Function
%>