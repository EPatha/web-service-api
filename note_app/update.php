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
$id = $_POST['id'];
$result = mysqli_query($connection, "update note_app set
title='$title', content='$content' where id='$id'");
if($result){
echo json_encode([
'message' => 'Data edit successfully'
]);
}else{
echo json_encode([
'message' => 'Data Failed to update'
]);
}
?>