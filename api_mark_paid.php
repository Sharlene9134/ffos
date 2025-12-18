<?php
require_once 'config.php';
header('Content-Type: application/json');

$orderId = (int)($_POST['order_id'] ?? 0);
if (!$orderId) {
    echo json_encode(['success' => false, 'error' => 'Invalid order ID']);
    exit;
}

$stmt = $pdo->prepare("UPDATE orders SET status='PAID', paid_at=NOW(), updated_at=NOW() WHERE id=?");
$res = $stmt->execute([$orderId]);

if ($res) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'error' => 'Failed to update order']);
}
