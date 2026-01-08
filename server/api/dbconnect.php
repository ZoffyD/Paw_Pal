<?php
    $servername = "localhost";
    $username = "canortxw_eric_pawpal";
    $password = ")-Euk;-+-?k$";
    $dbname = "canortxw_Eric_pawpal_db";
    
    //create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    //check connection
    if ($conn->connect_error) {
        //die is a function that stops the code and displays the message
        die("Connection failed: " . $conn->connect_error);
    }
?>