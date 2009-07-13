<?php /* Smarty version 2.6.25, created on 2009-07-09 03:41:42
         compiled from main.htm */ ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="content-type" content="text/html;charset=utf-8"/>
<meta name="Author" content="" >
<link rel="stylesheet" href="/system/style/global.css" type="text/css"/>
</head>
<body>
<div class="main-box">
	<div class="head-dark-box">
	PHP后台管理系统
	</div>
	<div class="body-box">

	<?php $_from = $this->_tpl_vars['arr']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['key'] => $this->_tpl_vars['value']):
?>
		<div>
		<?php echo $this->_tpl_vars['value']; ?>
 
		</div>
	<?php endforeach; endif; unset($_from); ?>

	</div>
</div>
</body>
</html>