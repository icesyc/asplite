<%
' 基于改进的前序节点遍历算法的树型结构,封装数据库操作
'
' @package    asplite
' @author     ice_berg16(寻梦的稻草人)
' @copyright  ice_berg16@163.com
' @version    $Id$
'
' 字段列表  id, name, parent_id, left_value, right_value, deep


Class Tree_
	
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
		If Not IsObject(Conn) Then initDB()
		Set rs = server.CreateObject("adodb.recordset")
	End Sub

	'析构函数
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

	' 添加或更新节点
	' @param data Dictionary对象
	Public Function save(data)
		If Not IsObject(data) Then System.halt("model.save : 参数必须是一个集合")
		If data.Item(PK) <> "" Then 
			save = update(data)
		Else
			save = create(data)
		End If
	End Function
	
	' 创建新节点
	' @param data Dictionary对象
	Public Function create(data)
		Dim sql, parent
		If typeName(data) <> "Dictionary" Then System.halt("model.save : 参数必须是一个集合")
		If data.exists("parent_id") Then 
			If IsNumeric(data.Item("parent_id")) Then 
				rs.open "select * from " &table& " where id="&data.Item("parent_id"), Conn, 1, 1
				If rs.eof Then System.halt("Tree.create : id为"&data.Item("parent_id")&"的结点不存在")
				Set parent = rs2col(rs)
				rs.close
			Else
				'查看顶级节点是否存在，不存在则创建
				Set parent = createRoot
			End If
		Else
			'查看顶级节点是否存在，不存在则创建
			Set parent = createRoot
		End If
		
		'更新左右节点
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
	
	' 更新结点
	' @param data Dictionary对象
	Public Function update(data)
		If Not IsObject(data) Then System.halt("model.save : 参数必须是一个集合")
		rs.open "select * from "& table &" where "& PK &"="& data.Item(PK),Conn,1,3
		rs.Fields("name") = data.Item("name")
		rs.update
		rs.close
	End Function

	' 删除该节点和所有子节点
	' @param value string|int
	Public Function delete(id)
		Dim sql,node
		'取出结点信息
		Set node = getNode(id)
		span = node.Item("right_value") - node.Item("left_value") + 1
		'删除节点及子节点
		sql = "delete from "& table &" where left_value>="& node.Item("left_value")& " and right_value<="& node.Item("right_value")
		Conn.execute sql
		
		'更新左右键
		sql = "update "& table &" set left_value=left_value-"& span &" where left_value>"&node.Item("right_value")
		Conn.execute sql
		sql = "update "& table &" set right_value=right_value-"& span &" where right_value>"&node.Item("right_value")
		Conn.execute sql
	End Function
	
	'返回节点的路径
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

	'取得一个节点信息
	Public Function getNode(id)
		Dim sql
		sql = "select * from "&table&" where id="& id
		rs.open sql, Conn, 1, 1
		Set getNode = rs2col(rs)
		rs.close
	End Function

	'取得父节点
	Public Function getParent(ByVal id)
		Set node = getNode(id)
		sql = "select top 1 * from "&table&" where left_value<"&node.Item("left_value")&" and right_value>"&node.Item("right_value")&" and parent_id<>-1 order by left_value desc"
		rs.open sql, Conn, 1, 1
		Set getParent = rs2col(rs)
		rs.close
	End Function 

	'取直接子节点
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

	'取得以某个节点为根的子树
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

	'取得所有节点
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

	'将RS对象转换成集合
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