<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_GET['email'];
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 
$userid = $_GET['userid'];

$api_key = 'enter ur api key';
$collection_id = 'enter your collection id'; 
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $phone,
          'name' => $name,
          'amount' => $amount * 100, // Cents
          'description' => 'Wallet Topup',
          'callback_url' => "https://domain.com/pawpal/server/api/return_url",
          'redirect_url' => "https://domian.com/pawpal/server/api/payment_update.php?userid=$userid&email=$email&name=$name&phone=$phone&amount=$amount" 
);

$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

// AUTOMATICALLY REDIRECT TO PAYMENT PAGE
if (isset($bill['url'])) {
    header("Location: {$bill['url']}");
} else {
    // If something goes wrong unexpectedly, show a simple error
    echo "<h3>Error: API Returned No URL</h3>";
    print_r($bill);
}
?>
