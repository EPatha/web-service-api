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

if ($connection->connect_error) {
    die(json_encode(['error' => 'Connection failed: ' . $connection->connect_error]));
}

$id = $_GET['id'];
$data = mysqli_query($connection, "SELECT * FROM barang WHERE id=" . $id);
$data = mysqli_fetch_array($data, MYSQLI_ASSOC);
echo json_encode($data);

$connection->close();
?>
