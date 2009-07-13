<?php
include(dirname(__FILE__)."\libs\init.class.php");

$login_arr = array();

$login = new _Model;

$login -> Table("fb_admin");

$login_arr = $login -> Select();

if (!empty($login_arr)){
    session_start(); 
    $_SESSION["uid"]=$login_arr[0]['uid'];  
	$_SESSION["pwd"]=$login_arr[0]['pwd'];  
	echo "<script>window.location.href = 'frame.php';</script>";
}else{
	echo "<script>window.location.href = 'login.htm';</script>";
}

?>