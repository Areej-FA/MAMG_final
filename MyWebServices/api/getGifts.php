<?php

//including the db operation file
require_once '../Includes/DbOperation.php';

$db = new DbOperation();
if (isset($_POST["Email"])) {
    $email = $_POST["Email"];
    $db->getAllGifts($email);
}
?>