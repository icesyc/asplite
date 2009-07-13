<?php
include_once(dirname(__FILE__).'/error.class.php');

//控制器类
class _Control {

	Public function __construct() {

		//获取调用函数名
		if(empty($_REQUEST['act'])) {

			$this -> act = "main";

		}else{

			$this -> act = $_REQUEST['act'];

		}

	}

	Public function Play($str = "main") {

		echo stristr($str,$this->act);

		exit;

		if(stristr($str,$this->act)) {

			$err = new _ERROR;

			$err -> alert("没有找到Main函数！");

		}else{

			echo $str;

		}



	}


}

//$c = new _control;

//$c ->play("test,main,edit,save");



?>