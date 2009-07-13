<?php

	class test {

		var $str = "test string!";

		function fb() {

			echo $this->str;
			
		}
		
	}

	$c = new test;

	$c -> fb();


?>