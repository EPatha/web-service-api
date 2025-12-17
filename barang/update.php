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

$KdBrg = $_POST['KdBrg'];
$NmBrg = $_POST['NmBrg'];
$HrgBeli = $_POST['HrgBeli'];
$HrgJual = $_POST['HrgJual'];
$Stok = $_POST['Stok'];

$result = mysqli_query($connection, "UPDATE barang SET 
    NmBrg='$NmBrg', 
    HrgBeli='$HrgBeli', 
    HrgJual='$HrgJual', 
    Stok='$Stok' 
    WHERE KdBrg='$KdBrg'");

if ($result) {
    echo json_encode([
        'success' => true,
        'message' => 'Data berhasil diupdate'
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Gagal mengupdate data'
    ]);
}

$connection->close();
?>
