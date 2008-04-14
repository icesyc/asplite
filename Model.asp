<%
' Model对象,封装数据库操作
'
' @package    asplite
' @author     ice_berg16(寻梦的稻草人)
' @copyright  ice_berg16@163.com
' @version    $Id$

Class Model_
	
	'表名
	Public table
	
	'recordset对象
	Private rs

	'主键
	public PK
	
	'是否打印SQL语句
	Public debug

	'构造函数
	Private Sub Class_initialize
		'lazy load
		If TypeName(Conn) <> "Connection" Then  initDB()
		Set rs = server.CreateObject("adodb.recordset")
	End Sub

	'析构函数
	Private Sub Class_Terminate
		If IsObject(rs) Then
			If  rs.state <> 0 Then rs.close
			Set rs = nothing
		End If
	End Sub

	' 实现添加或更新
	' @param data Dictionary对象
	Public Function save(data)
		If typeName(data) <> "Dictionary" Then System.halt("model.save : 参数必须是一个集合")
		If data.exists(PK) Then 
			If data.Item(PK) <> "" Then save = update(data) Else save = create(data)
		Else
			save = create(data)
		End If
	End Function
	
	' 创建新记录
	' @param data Dictionary对象
	Public Function create(data)
		If typeName(data) <> "Dictionary" Then System.halt("model.save : 参数必须是一个集合")
		rs.open table,Conn,1,3
		rs.addNew
		For Each f In rs.Fields
			If (f.name = "created" Or f.name = "updated") And Not data.exists(f.name) Then rs(f.name) = now
			If f.name <> PK And data.exists(f.name) Then rs(f.name) = data.Item(f.name)
		Next
		rs.update
		rs.close
	End Function
	
	' 更新记录
	' @param data Dictionary对象
	Public Function update(data)	
		If typeName(data) <> "Dictionary" Then System.halt("model.save : 参数必须是一个集合")
		rs.open "select * from "& table &" where "& PK &"="& data.Item(PK),Conn,1,3
		For Each f In rs.Fields			
			If f.name = "updated" And Not data.exists(f.name) Then rs(f.name) = now
			If f.name <> PK And data.exists(f.name) Then rs(f.name) = data.Item(f.name)
		Next
		rs.update
		rs.close
	End Function

	' 基于主键的删除
	' @param value string|int
	Public Function delete(value)
		delete = deleteByField(PK, value)
	End Function
	
	'某个字段计数增加
	'@param id 主键的记录值
	'@param field 要增加的字段
	Public Function increField(id, field)
		sql = "update "&table&" set "&field&"="&field&"+1 where "&PK&"="&id
		debug_(sql)
		Conn.execute sql, increField
	End Function

	'根据主键取得一条记录
	Public Function getRow(ByVal id)
		Dim sql,f
		If Not IsNumeric(id) Then id = 0
		sql = "select * from "&table&" where "&PK&" ="&id
		rs.open sql, Conn, 1, 1
		Set getRow = rs2col(rs)
		'如果主键不存在，则创建一个空的记录
		If getRow.Count = 0 Then 
			For Each f In rs.Fields
				getRow.add f.name, ""
			Next
		End If
		rs.close
	End Function

	'返回一个记录集,没有查到则返回一个空集
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

	'返回一条记录,没有查到则返回一个空集
	Public Function find(ByVal where, ByVal fields, ByVal order)
		Set find = findAll(where, fields, order, null, 1)
		If find.exists(0) Then Set find = find.Item(0)
	End Function 

	'查找条件记录总数
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

	'基于条件字段的删除
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

	'用于sql的安全字符串
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

	'将RS对象转换成
	Public Function rs2col(rs)
		Dim i,v
		Set rs2col = server.CreateObject("Scripting.Dictionary")
		If Not rs.eof Then
			For Each i In rs.fields
				'防止出现Null值
				v = IIF(IsNull(i.value), "", i.value)
				rs2col.add i.name, v
			Next
		End If
	End Function

	'打印sql语句
	Private  Sub debug_(sql)
		If debug = True Then 			
			Response.write("<fieldset style='font:verdana 12px'><legend><strong>Model Debug</strong></legend><pre style='color:red;margin:10px'>" & sql & "</pre></fieldset>")
		End if		
	End Sub

	'执行sql语句，返回影响的记录数
	Public Function exec(sql)
		debug_(sql)
		Conn.execute sql, exec
	End Function
	
	'三元操作符
	Public Function IIF(expression, vTrue, vFalse)
		If expression Then IIF = vTrue Else IIF = vFalse
	End Function
End Class
%>