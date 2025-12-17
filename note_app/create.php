<?php
// Enable CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

$connection = new mysqli("mysql", "root", "toor", "coba");
$title = $_POST['title'];
$content = $_POST['content'];
$date = date('Y-m-d');
$result = mysqli_query($connection, "insert into note_app set
title='$title', content='$content', date='$date'");
if($result){echo json_encode([
'message' => 'Data input successfully'
]);
}else{
echo json_encode([
'message' => 'Data Failed to input'
]);
}
?>