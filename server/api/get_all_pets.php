<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $baseQuery = "
     SELECT 
        p.pet_id,
        p.user_id,
        p.pet_name,
        p.age,
        p.gender,
        p.pet_type,
        p.category,
        p.health,
        p.description,
        p.lat,
        p.lng,
        p.created_at,
        u.name,
        u.email,
        u.phone
    FROM tbl_pets p
    JOIN tbl_users u ON p.user_id = u.user_id
    ";

   if (isset($_GET['search']) && !empty($_GET['search']) && isset($_GET['filter']) && !empty($_GET['filter']) && $_GET['filter'] != 'All') {
        
        $search = $conn->real_escape_string($_GET['search']);
        $filter = $conn->real_escape_string($_GET['filter']);
        
        $sqlsearch = $baseQuery . " WHERE p.pet_name LIKE '%$search%' AND p.pet_type = '$filter' ORDER BY p.pet_id DESC";

    } else if (isset($_GET['search']) && !empty($_GET['search'])) {
        
        $search = $conn->real_escape_string($_GET['search']);
        $sqlsearch = $baseQuery . " WHERE p.pet_name LIKE '%$search%' ORDER BY p.pet_id DESC";

    } else if (isset($_GET['filter']) && !empty($_GET['filter']) && $_GET['filter'] != 'All') {
        
        $filter = $conn->real_escape_string($_GET['filter']);
        $sqlsearch = $baseQuery . " WHERE p.pet_type = '$filter' ORDER BY p.pet_id DESC";

    } else {
        $sqlsearch = $baseQuery . " ORDER BY p.pet_id DESC";
    }

    $result = $conn->query($sqlsearch);
    
    if ($result && $result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            $petdata[] = $row;
        }
        $response = array("success" => true, "data" => $petdata);
        sendJsonResponse($response);
    } else {
        $response = array("success" => true, "data" => []);
        sendJsonResponse($response);
    }
} else {
    $response = array("success" => false, "message" => "No submission yet");
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>