<?php
// Enable CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

$connection = new mysqli("mysql","root","toor","coba");
$data = mysqli_query($connection, "select * from note_app");
$data = mysqli_fetch_all($data, MYSQLI_ASSOC);
echo json_encode($data);
?>