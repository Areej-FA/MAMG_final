<?php
 
    //including the db operation file
    require_once '../Includes/DbOperation.php';
    
    $db = new DbOperation();
    
    if(isset($_POST["id"])){
		$id = $_POST["id"];
		$db->getAnObject($id);
	}
    
?>