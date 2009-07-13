<?php 

class _Error {

	Public function Alert($str="暂无信息") {

		echo "<script>";

		echo "alert('".$str."');";

		echo "history.go(-1);";

		echo "</script>";

		exit;
		
	}
	
}


?>