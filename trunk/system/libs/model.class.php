<?php
include_once(dirname(__FILE__)."\config.class.php");
include_once(dirname(__FILE__)."\error.class.php");
Class _Model {

	Public function __Construct() {

		$HOST = SQL_HOST;

		$IP   = SQL_IP;

		$DB_NAME = SQL_NAME;

		$UID  = SQL_UID;

		$PWD  = SQL_PWD;

		$this->Conn = NEW PDO($HOST."=".$IP.";dbname=".$DB_NAME,$UID,$PWD) or die("DB Link Error!!!");
		
	}	

	Public function Table($Table = null) {

		if(!empty($Table)) {

			$this -> table = FB."_".$Table;
			
		}else{
		
			$err = new _Error;

			$err -> Alert("表名为空！");
			
		}
		
	}

	Public function Select($num=null,$line="*",$table=null,$where=null,$order="id desc",$type= PDO::FETCH_ASSOC) {

			if(Empty($table)) {

				$table = $this->table;
				
			}

		$sql = "SELECT $line FROM $table ";

			if(!Empty($where)) {

				$sql .= "WHEHER $where ";
				
			}
		
		$sql .= "order by $order ";

			if(!Empty($num)) {

				$sql .= "limit $num";
				
			}
		
		$exc = $this->Conn->query("SELECT * FROM fb_admin order by id desc") or die("SQL Select Error!!!");

		$row = $exc -> fetchall($type);

		Return $row;

	}
	
}

?>