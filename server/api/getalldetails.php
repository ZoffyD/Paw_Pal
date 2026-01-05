<?php

header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {


    $sql = "
     SELECT 
        p.pet_id,
        p.user_id,
        p.pet_name,
        p.age,
        p.gender,
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
    
    ";

    if (
        isset($_GET['search']) && !empty($_GET['search'])
        && isset($_GET['filter']) && !empty($_GET['filter'])
    ) {
        $search = $conn->real_escape_string($_GET['search']);
        $filter = $conn->real_escape_string($_GET['filter']);

        $sqlloadpet = $sql . "
            WHERE p.pet_name LIKE '%$search%' 
            AND p.pet_type LIKE %$filter%' 
            ORDER BY s.pet_id DESC";
    } else if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sqlloadpet = $sql . "
            WHERE p.pet_name LIKE '%$search%' ORDER BY s.pet_id DESC";

    } else if (isset($_GET['filter']) && !empty($_GET['filter'])) {
        $filter = $conn->real_escape_string($_GET['filter']);
        $sqlloadpet = $sql . " 
         WHERE p.pet_type LIKE '%$filter%' ORDER BY s.pet_id DESC";
    } else {
        $sqlloadpet = $sql . " ORDER BY p.pet_id DESC";
    }

    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            $petdata[] = $row;
        }
        $response = array("success" => true, "data" => $petdata);
        sendJsonResponse($response);
    }
} else {
    $response = array("success" => false, "data" => null);
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>