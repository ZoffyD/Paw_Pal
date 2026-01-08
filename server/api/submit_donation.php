<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    echo json_encode(array('status' => 'failed', 'message' => 'Method Not Allowed'));
    exit();
}

$petid = $_POST['petid'];
$userid = $_POST['userid'];
$donationtype = $_POST['donationType'];
$amount = isset($_POST['amount']) ? floatval($_POST['amount']) : 0.0;
$description = $_POST['description'];

// Check donor has enough money or not
if ($donationtype == "Money") {
    $sqlCheckBalance = "SELECT wallet FROM tbl_users WHERE user_id = '$userid'";
    $resultBalance = $conn->query($sqlCheckBalance);
    
    if ($resultBalance->num_rows > 0) {
        $row = $resultBalance->fetch_assoc();
        $currentBalance = floatval($row['wallet']);
        
        if ($currentBalance < $amount) {
            echo json_encode(array('status' => 'failed', 'message' => 'Insufficient wallet balance. Please Top Up.'));
            exit();
        }
    } else {
        echo json_encode(array('status' => 'failed', 'message' => 'User not found'));
        exit();
    }
}

// transaction begin here
$conn->begin_transaction();

try {
    
    $sqlinsert = "INSERT INTO `tbl_donations`(`pet_id`, `user_id`, `donation_type`, `amount`, `description`, `donation_date`) 
                  VALUES ('$petid','$userid','$donationtype','$amount','$description', NOW())";
    $conn->query($sqlinsert);

    if ($donationtype == "Money") {
        
        $sqlOwner = "SELECT user_id FROM `tbl_pets` WHERE `pet_id` = '$petid'";
        $resultOwner = $conn->query($sqlOwner);
        
        if ($resultOwner->num_rows > 0) {
            $ownerId = $resultOwner->fetch_assoc()['user_id'];
            
            $sqlDeduct = "UPDATE `tbl_users` SET `wallet` = `wallet` - $amount WHERE `user_id` = '$userid'";
            $conn->query($sqlDeduct);
            
            $sqlAdd = "UPDATE `tbl_users` SET `wallet` = `wallet` + $amount WHERE `user_id` = '$ownerId'";
            $conn->query($sqlAdd);
        }
    }

    $conn->commit();
    echo json_encode(array('status' => 'success', 'message' => 'Donation successful'));

} catch (Exception $e) {
    // If error, undo changes
    $conn->rollback();
    echo json_encode(array('status' => 'failed', 'message' => 'Database Error: ' . $e->getMessage()));
}
?>