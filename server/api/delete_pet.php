<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';


if(!isset($_POST['petid'])){
     $response = array('success' => false, 'message' => 'Missing pet id');
    sendJsonResponse($response);
    exit();
}

$petid = $_POST['petid'];


$sqldelete = "DELETE FROM tbl_pets WHERE pet_id = '$petid'";

if ($conn->query($sqldelete) === TRUE) {
    $response = array('success' => true, 'message' => 'Delete successfullu');
    sendJsonResponse($response);
} else {
    $response = array('success' => false, 'message' => 'Fail to delete');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>