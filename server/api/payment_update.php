<?php
// error_reporting(0);
include_once("dbconnect.php");

$userid = $_GET['userid'];
$amount = $_GET['amount'];
$email = $_GET['email'];
$name = $_GET['name'];
$phone = $_GET['phone'];

$xkey = 'get ur x key'; 

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if($paidstatus == "true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}

$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz' . $key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}


$signed = hash_hmac('sha256', $signing, $xkey);

if ($signed === $data['x_signature']) {

    if ($paidstatus === "Success") {
        $sqlupdatewallet = "UPDATE `tbl_users` SET `wallet` = `wallet` + '$amount' WHERE `user_id` = '$userid'";
        
        if($conn ->query ($sqlupdatewallet) === TRUE){
            // Print receipt
    echo "
    <html>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
    <body style='padding:20px;'>
        <center>
            <h4>PawPal Donation Receipt</h4>
            <hr>
        </center>
        <table class='w3-table w3-striped'>
            <th>Item</th><th>Description</th>
            <tr><td>Receipt</td><td>$receiptid</td></tr>
            <tr><td>Name</td><td>$name</td></tr>
            <tr><td>Email</td><td>$email</td></tr>
            <tr><td>Phone</td><td>$phone</td></tr>
            <tr><td>Paid Amount</td><td>RM $amount</td></tr>
            <tr><td>Paid Status</td><td class='w3-text-green'>$paidstatus</td></tr>
            </table><br>
            <center><button class='w3-btn w3-blue w3-round' onclick='window.print()'>Print Receipt</button></center>
            </body>
    </html>";
        }
    } else {
        echo "
    <html>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
    <body style='padding:20px;'>
        <center>
            <h4>PawPal Donation Receipt</h4>
            <hr>
        </center>
        <table class='w3-table w3-striped'>
            <th>Item</th><th>Description</th>
            <tr><td>Receipt</td><td>$receiptid</td></tr>
            <tr><td>Name</td><td>$name</td></tr>
            <tr><td>Email</td><td>$email</td></tr>
            <tr><td>Phone</td><td>$phone</td></tr>
            <tr><td>Paid Amount</td><td>RM $amount</td></tr>
            <tr><td>Paid Status</td><td class='w3-text-red'>$paidstatus</td></tr>
            </table><br>
            <center><button class='w3-btn w3-blue w3-round' onclick='window.print()'>Print Receipt</button></center>
            </body>
    </html>";
    }
} else {
    echo "Security Error: Signature Mismatch.";
}
?>
