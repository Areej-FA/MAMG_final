<?php
 
    //including the db operation file
    require_once '../Includes/DbOperation.php';
    
    $db = new DbOperation();
    
    if(isset($_POST["ObjID"]) && isset($_POST["TourID"])){
		$objID = $_POST["ObjID"];
		$tourID =  $_POST["TourID"];
		
		$db->savePlannedTour($objID, $tourID);
	}
    
?>