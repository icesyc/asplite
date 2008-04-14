<%
' Model����,��װ���ݿ����
'
' @package    asplite
' @author     ice_berg16(Ѱ�εĵ�����)
' @copyright  ice_berg16@163.com
' @version    $Id$

Class Model_
	
	'����
	Public table
	
	'recordset����
	Private rs

	'����
	public PK
	
	'�Ƿ��ӡSQL���
	Public debug

	'���캯��
	Private Sub Class_initialize
		'lazy load
		If TypeName(Conn) <> "Connection" Then  initDB()
		Set rs = server.CreateObject("adodb.recordset")
	End Sub

	'��������
	Private Sub Class_Terminate
		If IsObject(rs) Then
			If  rs.state <> 0 Then rs.close
			Set rs = nothing
		End If
	End Sub

	' ʵ����ӻ����
	' @param data Dictionary����
	Public Function save(data)
		If typeName(data) <> "Dictionary" Then System.halt("model.save : ����������һ������")
		If data.exists(PK) Then 
			If data.Item(PK) <> "" Then save = update(data) Else save = create(data)
		Else
			save = create(data)
		End If
	End Function
	
	' �����¼�¼
	' @param data Dictionary����
	Public Function create(data)
		If typeName(data) <> "Dictionary" Then System.halt("model.save : ����������һ������")
		rs.open table,Conn,1,3
		rs.addNew
		For Each f In rs.Fields
			If (f.name = "created" Or f.name = "updated") And Not data.exists(f.name) Then rs(f.name) = now
			If f.name <> PK And data.exists(f.name) Then rs(f.name) = data.Item(f.name)
		Next
		rs.update
		rs.close
	End Function
	
	' ���¼�¼
	' @param data Dictionary����
	Public Function update(data)	
		If typeName(data) <> "Dictionary" Then System.halt("model.save : ����������һ������")
		rs.open "select * from "& table &" where "& PK &"="& data.Item(PK),Conn,1,3
		For Each f In rs.Fields			
			If f.name = "updated" And Not data.exists(f.name) Then rs(f.name) = now
			If f.name <> PK And data.exists(f.name) Then rs(f.name) = data.Item(f.name)
		Next
		rs.update
		rs.close
	End Function

	' ����������ɾ��
	' @param value string|int
	Public Function delete(value)
		delete = deleteByField(PK, value)
	End Function
	
	'ĳ���ֶμ�������
	'@param id �����ļ�¼ֵ
	'@param field Ҫ���ӵ��ֶ�
	Public Function increField(id, field)
		sql = "update "&table&" set "&field&"="&field&"+1 where "&PK&"="&id
		debug_(sql)
		Conn.execute sql, increField
	End Function

	'��������ȡ��һ����¼
	Public Function getRow(ByVal id)
		Dim sql,f
		If Not IsNumeric(id) Then id = 0
		sql = "select * from "&table&" where "&PK&" ="&id
		rs.open sql, Conn, 1, 1
		Set getRow = rs2col(rs)
		'������������ڣ��򴴽�һ���յļ�¼
		If getRow.Count = 0 Then 
			For Each f In rs.Fields
				getRow.add f.name, ""
			Next
		End If
		rs.close
	End Function

	'����һ����¼��,û�в鵽�򷵻�һ���ռ�
	Public Function findAll(ByVal where, ByVal fields, ByVal order, ByVal page, ByVal limit)
		Dim sql,tmp,lmt,i
		If IsNumeric(where) Then
			where = PK &"="& where
		ElseIf IsArray(where) Then 
			where = Join(where, " and ")
		ElseIf IsObject(where) Then 
			tmp = ""
			For Each k In where
				tmp = tmp & " and "& where(k)
			Next
			where = Mid(tmp,6)
		End If 
		fields = IIF(IsNull(fields), "*", fields)		
		lmt    = IIF(IsNull(limit), "", "top "& limit &" ")
		where  = IIF(IsNull(where), "", " where "& where)
		order  = IIF(IsNull(order), "", " order by "& order)	
		sql = "select "& lmt & fields &" from "& table
		If IsNumeric(page) And page > 1 And limit > 0 Then
			sql = sql & " where "& PK &" not in("
			sql = sql & "select top "& (page-1)*limit &" "& PK &" from "& table & where & order
			sql = sql & ")"
		Else
			sql = sql & where
		End If
		sql = sql & order
		debug_(sql)
		rs.open sql, Conn, 1, 1
		Set findAll = server.CreateObject("Scripting.Dictionary")
		i = 0
		While Not rs.eof
			findAll.add i, rs2col(rs)
			rs.moveNext
			i = i + 1
		Wend
		rs.close
	End Function

	'����һ����¼,û�в鵽�򷵻�һ���ռ�
	Public Function find(ByVal where, ByVal fields, ByVal order)
		Set find = findAll(where, fields, order, null, 1)
		If find.exists(0) Then Set find = find.Item(0)
	End Function 

	'����������¼����
	Public Function findCount(ByVal where)
		Dim sql
		If IsNumeric(where) Then
			where = PK &"="& where
		ElseIf IsArray(where) Then 
			where = Join(where, " and ")
		ElseIf IsObject(where) Then 
			tmp = ""
			For Each k In where
				tmp = tmp & " and "& where(k)
			Next
			where = Mid(tmp,6)
		End If 
		sql = "select count(*) as cnt from "& table
		If Not IsNull(where) Then sql = sql &" where "& where
		debug_(sql)
		rs.open sql, Conn, 1, 1
		findCount = rs.fields("cnt").value
		rs.close
	End Function

	'���������ֶε�ɾ��
	Public Function deleteByField(f,v)
		Dim sql,cond
		If IsArray(v) Then
			cond = " in (" & Join(quote(v), ",") & ")"
		Else
			cond = " = " & quote(v)
		End If
		sql = "delete from " &table& " where " &f& cond
		debug_(sql)
		Conn.execute sql, deleteByField
	End Function

	'����sql�İ�ȫ�ַ���
	Public Function quote(ByVal v)
		If IsArray(v) Then 
			If Not IsNumeric(v(0)) Then 
				Dim i,c
				c = UBound(v)
				For i = 0 To c
					v(i) = "'"& v(i) & "'"
				Next 
			End If
		Else
			If Not IsNumeric(v) Then v = "'"& v &"'"
		End If
		quote = v
	End Function

	'��RS����ת����
	Public Function rs2col(rs)
		Dim i,v
		Set rs2col = server.CreateObject("Scripting.Dictionary")
		If Not rs.eof Then
			For Each i In rs.fields
				'��ֹ����Nullֵ
				v = IIF(IsNull(i.value), "", i.value)
				rs2col.add i.name, v
			Next
		End If
	End Function

	'��ӡsql���
	Private  Sub debug_(sql)
		If debug = True Then 			
			Response.write("<fieldset style='font:verdana 12px'><legend><strong>Model Debug</strong></legend><pre style='color:red;margin:10px'>" & sql & "</pre></fieldset>")
		End if		
	End Sub

	'ִ��sql��䣬����Ӱ��ļ�¼��
	Public Function exec(sql)
		debug_(sql)
		Conn.execute sql, exec
	End Function
	
	'��Ԫ������
	Public Function IIF(expression, vTrue, vFalse)
		If expression Then IIF = vTrue Else IIF = vFalse
	End Function
End Class
%>