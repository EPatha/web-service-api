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

// Auto generate KdBrg dengan format B001, B002, B003...
$query = "SELECT KdBrg FROM barang ORDER BY KdBrg DESC LIMIT 1";
$result = mysqli_query($connection, $query);

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    $lastKdBrg = $row['KdBrg'];
    // Extract number from B001 -> 001
    $number = intval(substr($lastKdBrg, 1));
    $newNumber = $number + 1;
    // Format kembali menjadi B002
    $KdBrg = 'B' . str_pad($newNumber, 3, '0', STR_PAD_LEFT);
} else {
    // Jika belum ada data, mulai dari B001
    $KdBrg = 'B001';
}

$NmBrg = $_POST['NmBrg'];
$HrgBeli = $_POST['HrgBeli'];
$HrgJual = $_POST['HrgJual'];
$Stok = $_POST['Stok'];

$result = mysqli_query($connection, "INSERT INTO barang SET 
    KdBrg='$KdBrg', 
    NmBrg='$NmBrg', 
    HrgBeli='$HrgBeli', 
    HrgJual='$HrgJual', 
    Stok='$Stok'");

if ($result) {
    echo json_encode([
        'success' => true,
        'message' => 'Data berhasil ditambahkan',
        'KdBrg' => $KdBrg
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Gagal menambahkan data'
    ]);
}

$connection->close();
?>
