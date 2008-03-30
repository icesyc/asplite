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
		Collection.add i, col(i)
	Next
End Function

'��ӡ����,�����ڲ��ݹ�
Function dump_(var,key, deep)
	If Not IsNull(key) Then response.write String(deep,vbTab) & key &" => "
	If IsObject(var)Then 
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

'ecoh ���� ���棨Response.write ������
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
	If Not IsObject(Conn) Then initDB()
	Set newRS = server.CreateObject("adodb.recordset")
End Function 

'����һ��model����
Function model(tblName)
	Set model = new Model_
	model.table = Config.tablePre & tblName
	Set schema = Conn.OpenSchema(28,Array(empty,empty,model.table))
	If schema.eof And schema.bof Then System.halt("�� "&model.table& " ������")
	model.PK = schema("column_name")
	schema.close
	Set schema = nothing
End Function

'����һ��ģ�����
Function view(filePath)
	Set view = new Template
	view.dir = Config.viewPath
	view.setFile filePath
End Function

'����һ��tree����
Function tree(tblName)
	Set tree = new Tree_
	tree.table = Config.tablePre & tblName
	Set schema = Conn.OpenSchema(28,Array(empty,empty,tree.table))
	If schema.eof And schema.bof Then System.halt("�� "&tree.table& " ������")
	tree.PK = schema("column_name")
	schema.close
	Set schema = nothing
End Function
%>