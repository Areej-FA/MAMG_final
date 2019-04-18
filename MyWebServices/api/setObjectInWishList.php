<?php

//including the db operation file
require_once '../Includes/DbOperation.php';

$db = new DbOperation();

if (isset($_POST["Pro_id"]) && isset($_POST["Email"])) {
    $Pro_id = $_POST["Pro_id"];
    $email = $_POST["Email"];
    $db->setObjectInWishList($Pro_id, $email);
}
?>