<?php

//including the db operation file
require_once '../Includes/DbOperation.php';

$db = new DbOperation();

if (isset($_POST["Email"]) && isset($_POST["Tour_id"])) {
    $Tour_id = $_POST["Tour_id"];
    $email = $_POST["Email"];
    $db->deleteFavourite($Tour_id, $email);
}
?>