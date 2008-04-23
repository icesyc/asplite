<%
' ���ڸĽ���ǰ��ڵ�����㷨�����ͽṹ,��װ���ݿ����
'
' @package    asplite
' @author     ice_berg16(Ѱ�εĵ�����)
' @copyright  ice_berg16@163.com
' @version    $Id$
'
' �ֶ��б�  id, name, parent_id, left_value, right_value, deep


Class Tree_
	
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
		If Not IsObject(Conn) Then initDB()
		Set rs = server.CreateObject("adodb.recordset")
	End Sub

	'��������
	Private Sub Class_Terminate
		If IsObject(rs) Then
			If  rs.state <> adStateClosed Then rs.close
			Set rs = nothing
		End If
	End Sub

	Private Function createRoot
		sql = "select * from "& table &" where parent_id=-1"		'
		rs.open "select * from " & table &" where parent_id=-1", Conn, 1, 3
		If rs.eof Then 
			rs.addNew
			rs.Fields("name") = "__ROOT_NODE__"
			rs.Fields("left_value") = 1
			rs.Fields("right_value") = 2
			rs.Fields("parent_id") = -1
			rs.Fields("deep") = 0
			rs.update
		End If
		Set createRoot = rs2col(rs)
		rs.close
	End Function

	' ��ӻ���½ڵ�
	' @param data Dictionary����
	Public Function save(data)
		If Not IsObject(data) Then System.halt("model.save : ����������һ������")
		If data.Item(PK) <> "" Then 
			save = update(data)
		Else
			save = create(data)
		End If
	End Function
	
	' �����½ڵ�
	' @param data Dictionary����
	Public Function create(data)
		Dim sql, parent
		If typeName(data) <> "Dictionary" Then System.halt("model.save : ����������һ������")
		If data.exists("parent_id") Then 
			If IsNumeric(data.Item("parent_id")) Then 
				rs.open "select * from " &table& " where id="&data.Item("parent_id"), Conn, 1, 1
				If rs.eof Then System.halt("Tree.create : idΪ"&data.Item("parent_id")&"�Ľ�㲻����")
				Set parent = rs2col(rs)
				rs.close
			Else
				'�鿴�����ڵ��Ƿ���ڣ��������򴴽�
				Set parent = createRoot
			End If
		Else
			'�鿴�����ڵ��Ƿ���ڣ��������򴴽�
			Set parent = createRoot
		End If
		
		'�������ҽڵ�
		sql = "update "& table &" set left_value=left_value+2 where left_value>=" & parent.Item("right_value")
		Conn.execute sql
		sql = "update "& table &" set right_value=right_value+2 where right_value>="& parent.Item("right_value")
		Conn.execute sql

		rs.open table,Conn,1,3
		rs.addNew
		rs.Fields("name")		= data.Item("name")
		rs.Fields("left_value") = parent.Item("right_value")
		rs.Fields("right_value")= parent.Item("right_value")+1
		rs.Fields("parent_id")  = parent.Item(PK)
		rs.Fields("deep")		= parent.Item("deep") + 1
		rs.update
		rs.close
	End Function
	
	' ���½��
	' @param data Dictionary����
	Public Function update(data)
		If Not IsObject(data) Then System.halt("model.save : ����������һ������")
		rs.open "select * from "& table &" where "& PK &"="& data.Item(PK),Conn,1,3
		rs.Fields("name") = data.Item("name")
		rs.update
		rs.close
	End Function

	' ɾ���ýڵ�������ӽڵ�
	' @param value string|int
	Public Function delete(id)
		Dim sql,node
		'ȡ�������Ϣ
		Set node = getNode(id)
		span = node.Item("right_value") - node.Item("left_value") + 1
		'ɾ���ڵ㼰�ӽڵ�
		sql = "delete from "& table &" where left_value>="& node.Item("left_value")& " and right_value<="& node.Item("right_value")
		Conn.execute sql
		
		'�������Ҽ�
		sql = "update "& table &" set left_value=left_value-"& span &" where left_value>"&node.Item("right_value")
		Conn.execute sql
		sql = "update "& table &" set right_value=right_value-"& span &" where right_value>"&node.Item("right_value")
		Conn.execute sql
	End Function
	
	'���ؽڵ��·��
	Public Function getPath(node)
		Dim sql, i
		If typeName(node) <> "Dictionary" Then Set node = getNode(node)
		sql = "select * from "&table&" where left_value<"&node.Item("left_value")&" and right_value>"&node.Item("right_value")&" and parent_id<>-1 order by left_value"
		rs.open sql, Conn, 1, 1
		Set getPath = server.CreateObject("Scripting.Dictionary")
		i = 0
		While Not rs.eof
			getPath.add i, rs2col(rs)
			rs.moveNext
			i = i + 1
		Wend
		rs.close
	End Function

	'ȡ��һ���ڵ���Ϣ
	Public Function getNode(id)
		Dim sql
		sql = "select * from "&table&" where id="& id
		rs.open sql, Conn, 1, 1
		Set getNode = rs2col(rs)
		rs.close
	End Function

	'ȡ�ø��ڵ�
	Public Function getParent(ByVal id)
		Set node = getNode(id)
		sql = "select top 1 * from "&table&" where left_value<"&node.Item("left_value")&" and right_value>"&node.Item("right_value")&" and parent_id<>-1 order by left_value desc"
		rs.open sql, Conn, 1, 1
		Set getParent = rs2col(rs)
		rs.close
	End Function 

	'ȡֱ���ӽڵ�
	Public Function getChild(id)
		Dim sql, i
		sql = "select * from "&table&" where parent_id="&id&" order by left_value"
		rs.open sql, Conn, 1, 1
		Set getChild = server.CreateObject("Scripting.Dictionary")
		i = 0
		While Not rs.eof
			getChild.add i, rs2col(rs)
			rs.moveNext
			i = i + 1
		Wend
		rs.close
	End Function

	'ȡ����ĳ���ڵ�Ϊ��������
	Public Function getSubTree(ByVal node)
		Dim sql, i
		If typeName(node) <> "Dictionary" Then Set node = getNode(node)
		sql = "select * from "&table&" where left_value between "&node.Item("left_value")&" and "&node.Item("right_value")&" order by left_value"
		rs.open sql, Conn, 1, 1
		Set getSubTree = server.CreateObject("Scripting.Dictionary")
		i = 0
		While Not rs.eof
			getSubTree.add i, rs2col(rs)
			rs.moveNext
			i = i + 1
		Wend
		rs.close
	End Function

	'ȡ�����нڵ�
	Public Function getAllNode()
		Dim sql, i
		sql = "select * from "&table&" where left_value>1 order by left_value"
		rs.open sql, Conn, 1, 1
		Set getAllNode = server.CreateObject("Scripting.Dictionary")
		i = 0
		While Not rs.eof
			getAllNode.add i, rs2col(rs)
			rs.moveNext
			i = i + 1
		Wend
		rs.close
	End Function

	'��RS����ת���ɼ���
	Private Function rs2col(rs)
		Dim i
		Set rs2col = server.CreateObject("Scripting.Dictionary")
		If Not rs.eof Then
			For Each i In rs.fields
				rs2col.add i.name, i.value
			Next
		End If
	End Function
End Class
%>