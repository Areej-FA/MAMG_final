<?php
 
    //including the db operation file
    require_once '../Includes/DbOperation.php';
    
    $db = new DbOperation();
    
    
    $db->returnHalls();
    
?>