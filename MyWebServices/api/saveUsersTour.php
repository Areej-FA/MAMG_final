<?php
 
    //including the db operation file
    require_once '../Includes/DbOperation.php';
    
    $db = new DbOperation();
    
    if(isset($_POST["UserID"]) && isset($_POST["TourID"])){
		$userID = $_POST["UserID"];
		$tourID =  $_POST["TourID"];
		
		$db->saveUsersTour($tourID, $userID);
	}
    
?>