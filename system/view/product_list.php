<?php
include('session.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<?php
include ('inc/model.php');
?>
<head>
<title> </title>
<meta http-equiv="content-type" content="text/html;charset=utf-8"/>
<meta name="Author" content="ice_berg16(Ѱεĵ)"/>
<link rel="stylesheet" href="style/global.css" type="text/css"/>
<script type="text/javascript" src="javascript/jquery.js"></script>
<script type="text/javascript" src="javascript/jquery.util.js"></script>
</head>
<body>
<div class="main-box">
	<div class="head-dark-box">
		新闻管理
	</div>
	<form method="get" action="control/product.php">
	<div class="white-box">
		<table class="list-table" cellspacing="0">
			<tr class='head-light-box'>
				<td width="4%">&nbsp;</td>
				<td>标题</td>
				<td>时间</td>
				<td>操作</td>
			</tr>
		
<?php
		$DB=new link_db;
		$dbh = $DB->CONN();
		$dbname="ice_product";
		$field = "*";
		$page=isset($_GET['page']) ? intval($_GET['page']) : 1;
		$pagesize=10;

		$num = $dbh->query("select count(*) as num from $dbname ");
		$count = $num->fetchColumn();
		$count = ceil($count/$pagesize);
		if ($page>$count){
			$page=$count;
		}elseif($page<1){
			$page=1;
		}
		$pagenum=($page-1)*$pagesize;
		$sth = $dbh->prepare("SELECT $field FROM $dbname order by id desc limit $pagesize offset $pagenum",array(PDO::ATTR_CURSOR, PDO::CURSOR_SCROLL));
		$sth->execute();
		while ($result = $sth->fetch()){
?>
			<tr>
				<td><input type="checkbox" name="id[]" value="<?=$result['id']?>" /></td>
				<td><a href="#" target="_blank"><?=$result['title']?> <?if (isset($result['thumbnail'])){echo "<img src='style/images/pic.gif' align='absmiddle'/>";}?></a></td>
				<td><?=$result['created']?></td>
				<td>
					[<a href="product_edit.php?act=edit&id=<?=$result['id']?>">修改</a>]
					[<a href="control/product.php?act=delete&id=<?=$result['id']?>" onclick="return confirm('确定删除吗！')">删除</a>]
				</td>
			</tr>
		<?php
					}
		?>
			<tr>
				<td align="right" colspan="4" id="pager">
				<?php
				$pagenext=$page+1;
				$pageadd=$page-1;
				echo "<br><br><a href='?page=1' class='red'>首页</a>&nbsp;&nbsp;&nbsp;&nbsp";
				echo "<a href='?page=$pageadd' class='red'>上一页</a>&nbsp;&nbsp;&nbsp;&nbsp";
				echo "<a href='?page=$pagenext' class='red'>下一页</a>&nbsp;&nbsp;&nbsp;&nbsp";
				echo "<a href='?page=$count' class='red'>尾页</a>";
				?>
				</td>
			</tr>
			<tr class="head-light-box">
				<td colspan="4">
				<input type="checkbox" onclick="$(':checkbox').checkAll(this.checked)" id="ckall"/>	
				&nbsp;&nbsp;选择: <input type="image" src="style/images/delete.gif" alt="确定删除！" onclick="return confirm('确定删除吗！')"/>	
				&nbsp;<input type="image" src="style/images/top.gif" onclick="this.form.act='recmd'"/>	
				&nbsp;<input type="image" src="style/images/down.gif" onclick="this.form.act.value='cancelRecmd'"/>	
				<input type="hidden" name="act" value="delete"/>				</td>
			</tr>
		</table>
	</div>
	</form>
</div>
</body>
</html>
