<?php
  header("Access-Control-Allow-Origin: *");

  if($_SERVER['REQUEST_METHOD']=='POST'){

    if(!isset($_POST['email']) || !isset($_POST['password'])){
        $response = array ('success' => false, 'message' => 'Invalid Request');
        sendJsonResponse($response);
        exit();
    }
    //Getting values
    $email = $_POST['email'];
    $password = $_POST['password'];
    $hashedpassword = sha1($password);
    
    include 'dbconnect.php';
    $sqllogin = "SELECT * FROM `tbl_users` WHERE email = '$email' AND `password` = '$hashedpassword'";
    $result = $conn->query($sqllogin);

    if($result->num_rows > 0){
      $userdata = array();
      while($row = $result->fetch_assoc()){
          $userdata[] = $row;
      }
        $response = array ('success' => true, 'data' => $userdata,'message' => 'Login Success');
        sendJsonResponse($response);
    }else{
        $response = array ('success'=> false, 'message'=> 'Invalid email or password','data '=> null);
        sendJsonResponse($response);
  }

}else{
  $response = array ('success'=> false, 'message'=> 'Method not allowed');
  sendJsonResponse($response);
  exit();
}
function sendJsonResponse($sentArray){
  header('Content-Type: application/json');
  echo json_encode($sentArray);
}
?>