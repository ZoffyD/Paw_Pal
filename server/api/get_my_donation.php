<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if($_SERVER['REQUEST_METHOD'] != 'GET'){
    sendJsonResponse(array("success"=> false, "message" => "Invalid Reuqest"));
    exit();
}

if(!isset($_GET['userid'])){
    sendJsonResponse(array("success"=> false, "message" => "Missing user id"));
    exit();
}
$user_id = $_GET['userid'];

$sql = "SELECT
        d.donation_id,
        d.donation_type,
        d.amount,
        d.description,
        d.donation_date,
        p.pet_name
        FROM tbl_donations d
        LEFT JOIN tbl_pets p ON d.pet_id = p.pet_id
        WHERE d.user_id = '$user_id'
        ORDER BY d.donation_date DESC";

$result =$conn->query($sql);

if($result && $result->num_rows>0){
    $donate = array();
    while($row = $result-> fetch_assoc()){
        $donate[]=$row;
    }
    sendJsonResponse(array("success"=> true, "data" => $donate));
}else{
    sendJsonResponse(array("success"=> false, "data" => []));
}

function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>