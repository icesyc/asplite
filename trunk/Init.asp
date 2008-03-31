<%
' 应用程序启动加载程序员
'
' @package    asplite
' @version    $Id$
%>
<!-- #include file="Config.asp" -->
<!-- #include file="System.asp" -->
<!-- #include file="Model.asp" -->
<!-- #include file="Template.asp" -->
<!-- #include file="Util.asp" -->
<%
Private Function sqlCheck(ByVal Str)
	sqlCheck = 0
	If Instr(LCase(Str),"select ") > 0 Or Instr(LCase(Str),"insert ") > 0 Or Instr(LCase(Str),"delete ") > 0 Or Instr(LCase(Str),"delete from ") > 0 or Instr(LCase(Str),"count(") > 0 or Instr(LCase(Str),"drop table") > 0 or Instr(LCase(Str),"update ") > 0 or Instr(LCase(Str),"truncate ") > 0 or Instr(LCase(Str),"asc(") > 0 or Instr(LCase(Str),"mid(") > 0 or Instr(LCase(Str),"char(") > 0 or Instr(LCase(Str),"xp_cmdshell") > 0 or Instr(LCase(Str),"exec master") > 0 or Instr(LCase(Str),"net localgroup administrators") > 0  or Instr(LCase(Str),"and ") > 0 Or Instr(LCase(Str),"net user") > 0 Or Instr(LCase(Str),"or ") > 0 Then
		sqlCheck = 1
	End If
	Str=Replace(LCase(Str),"select ","")
	Str=Replace(LCase(Str),"insert ","")
	Str=Replace(LCase(Str),"delete ","")
	Str=Replace(LCase(Str),"delete from ","")
	Str=Replace(LCase(Str),"count(","")
	Str=Replace(LCase(Str),"drop table","")
	Str=Replace(LCase(Str),"xp_cmdshell","")
	Str=Replace(LCase(Str),"exec master","")
	Str=Replace(LCase(Str),"declera ","")
	Str=Replace(LCase(Str),"net localgroup administrators","")
	Str=Replace(LCase(Str),"and ","")
	Str=Replace(LCase(Str),"update ","")
	Str=Replace(LCase(Str),"truncate ","")
	Str=Replace(LCase(Str),"asc(","")
	Str=Replace(LCase(Str),"mid(","")
	Str=Replace(LCase(Str),"char(","")
	Str=Replace(LCase(Str),"net user","")
	Str=Replace(LCase(Str),"or ","")
	Str=Replace(Str,"_","")					'过滤SQL注入_
	Str=Replace(Str,"*","")					'过滤SQL注入*
	Str=Replace(Str," ","")					'过滤SQL注入空格
	Str=Replace(Str,chr(34),"")				'过滤SQL注入"
	Str=Replace(Str,chr(39),"")            '过滤SQL注入'
	Str=Replace(Str,chr(91),"")            '过滤SQL注入[
	Str=Replace(Str,chr(93),"")            '过滤SQL注入]
	Str=Replace(Str,chr(37),"")            '过滤SQL注入%
	Str=Replace(Str,chr(58),"")            '过滤SQL注入:
	Str=Replace(Str,chr(59),"")            '过滤SQL注入;
	Str=Replace(Str,chr(43),"")            '过滤SQL注入+
	Str=Replace(Str,"{","")            '过滤SQL注入{
	Str=Replace(Str,"}","")            '过滤SQL注入}
	If sqlCheck <> 0 Then Response.End
End Function

Call sqlCheck(Request.ServerVariables("QUERY_STRING"))
%>