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

$nama_barang = $_POST['nama_barang'];
$harga = $_POST['harga'];
$stok = $_POST['stok'];

$result = mysqli_query($connection, "INSERT INTO barang SET 
    nama_barang='$nama_barang', 
    harga='$harga', 
    stok='$stok'");

if ($result) {
    echo json_encode([
        'success' => true,
        'message' => 'Data berhasil ditambahkan'
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Gagal menambahkan data'
    ]);
}

$connection->close();
?>
