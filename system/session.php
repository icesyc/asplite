<?php
session_start();
if(!isset($_SESSION["uid"]) && !isset($_SESSION["pwd"])){
			echo "<script>";
			echo "window.location.href='login.htm';";
			echo "</script>";
			exit;
}
?>