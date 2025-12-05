<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    //check for missing user id
    if (!isset($_GET['userid'])) {
        $response = array('success' => false, 'message' => 'Missing user id');
        sendJsonResponse($response);
        exit();
    }

    $user_id = $_GET['userid'];

    $sql = "
     SELECT 
        p.pet_id,
        p.user_id,
        p.pet_name,
        p.pet_type,
        p.category,
        p.description,
        p.image_paths,
        p.lat,
        p.lng,
        p.created_at,
        u.name,
        u.email,
        u.phone
    FROM tbl_pets p
    JOIN tbl_users u ON p.user_id = u.user_id
    WHERE p.user_id = '$user_id'
    ORDER BY p.pet_id DESC
    ";

    $result = $conn->query($sql);

    //if user has pet
    if ($result && $result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            $petdata[] = $row;
        }

        $response = array("success"=> true,"data"=> $petdata);
        sendJsonResponse($response);
    }
    if($result -> num_rows === 0) {
         $response = array("success"=> false,"message"=> "No submission yet", "data"=>[]);
         sendJsonResponse($response);
         exit();
    }
}else{
    $response = array("success"=> false,"message"=> "Invalid request", "data"=>[]);
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>