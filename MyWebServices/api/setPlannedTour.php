<?php
 
    //including the db operation file
    require_once '../Includes/DbOperation.php';
    
    $db = new DbOperation();
    
    if(isset($_POST["Name"]) && isset($_POST["Descrption"])){
		$image;
		if(isset($_FILES['file']['tmp_name'])){
			$image = $_FILES['file']['tmp_name'];
			$image = addslashes(file_get_contents($image));
		} else {
			$image = "NULL";
		}
		
		$name = $_POST["Name"];
		$desc =  $_POST["Descrption"];
		
		$db->setPlannedTour($name, $desc, $image);
	}
    
?>
