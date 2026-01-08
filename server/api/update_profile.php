<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    echo json_encode(
        array("success" => false, "message" => "Invalid Request")
    );
    exit();
}

$user_id = $_POST['user_id'];
$name = $_POST['name'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$image = $_POST["image"] ?? '';

$sql = "UPDATE tbl_users SET name ='$name', phone = '$phone', email = '$email'";

//if image is provided , decode it and save it 
if (!empty($image)) {
    $decode_image = base64_decode($image);

    $filename = "person" . $user_id . ".png";
    $path = "../assets/person/" . $filename;
    file_put_contents($path, $decode_image);
    $sql .= ", profile_image ='$filename'";
}

$sql .= " WHERE user_id = '$user_id'";

if ($conn->query($sql) === TRUE) {
    $response = array(
        "success" => TRUE,
        "message" => "Profile update successful"
    );
    //if new image created, send the filename back 
    if (isset($filename)) {
        $response['new_image'] = $filename;
    }
    echo json_encode($response);
} else {
    echo json_encode(
        array(
            "success" => false,
            "message" => "Profile update unsuccessful"
        )
    );
}
?>