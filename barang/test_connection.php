<?php
// Enable CORS
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

// Test database connection
$connection = new mysqli("mysql", "root", "toor", "coba");

if ($connection->connect_error) {
    echo json_encode([
        'success' => false,
        'message' => 'Connection failed: ' . $connection->connect_error
    ]);
} else {
    // Check if table exists
    $result = $connection->query("SHOW TABLES LIKE 'barang'");
    $tableExists = $result->num_rows > 0;
    
    echo json_encode([
        'success' => true,
        'message' => 'Database connected successfully!',
        'database' => 'coba',
        'table_barang_exists' => $tableExists,
        'mysql_version' => $connection->server_info
    ]);
}

$connection->close();
?>
