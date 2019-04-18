<?php

//including the db operation file
require_once '../Includes/DbOperation.php';

$db = new DbOperation();

if (isset($_POST["Email"]) && isset($_POST["Pro_id"])) {
    $Pro_id = $_POST["Pro_id"];
    $email = $_POST["Email"];
    $db->deleteWishlist($Pro_id, $email);
}
?>