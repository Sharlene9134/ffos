<?php
require_once 'config.php';
if (empty($_SESSION['admin'])) {
    header('Location: insights_&_statistics.php');
    exit;
}

// --- Helpers ---
function handle_image_upload(string $fieldName): ?string
{
    if (empty($_FILES[$fieldName]['name'])) {
        return null;
    }

    $file = $_FILES[$fieldName];
    if ($file['error'] !== UPLOAD_ERR_OK) {
        return null;
    }

    $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    $allowed = ['jpg','jpeg','png','gif','webp'];
    if (!in_array($ext, $allowed, true)) {
        return null;
    }

    $uploadsDir = __DIR__ . '/uploads';
    if (!is_dir($uploadsDir)) {
        @mkdir($uploadsDir, 0777, true);
    }

    $newName = uniqid('prod_', true) . '.' . $ext;
    $target = $uploadsDir . '/' . $newName;

    if (!move_uploaded_file($file['tmp_name'], $target)) {
        return null;
    }

    return 'uploads/' . $newName;
}

// --- Handle POST actions (create/edit for category/product/bundle) ---
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';

    // Create category
    if ($action === 'create_category') {
        $name = trim($_POST['category_name'] ?? '');
        if ($name !== '') {
            $stmt = $pdo->prepare("INSERT INTO product_categories (name) VALUES (?)");
            $stmt->execute([$name]);
        }
    }

    // Edit category
    if ($action === 'edit_category') {
        $id   = (int)($_POST['category_id'] ?? 0);
        $name = trim($_POST['category_name'] ?? '');
        if ($id > 0 && $name !== '') {
            $stmt = $pdo->prepare("UPDATE product_categories SET name = ? WHERE id = ?");
            $stmt->execute([$name, $id]);
        }
    }

    // Create product
    if ($action === 'create_product') {
        $name       = trim($_POST['product_name'] ?? '');
        $code       = trim($_POST['product_code'] ?? '');
        $price      = (float)($_POST['product_price'] ?? 0);
        $categoryId = (int)($_POST['product_category_id'] ?? 0);

        if ($name !== '' && $code !== '' && $price > 0 && $categoryId > 0) {
            $imagePath = handle_image_upload('product_image');

            $stmt = $pdo->prepare(
                "INSERT INTO menu_items (code, category_id, is_bundle, name, price, image_path, is_active)
                 VALUES (?, ?, 0, ?, ?, ?, 1)"
            );
            $stmt->execute([$code, $categoryId, $name, $price, $imagePath]);
        }
    }

    // Edit product
    if ($action === 'edit_product') {
        $id         = (int)($_POST['product_id'] ?? 0);
        $name       = trim($_POST['product_name'] ?? '');
        $code       = trim($_POST['product_code'] ?? '');
        $price      = (float)($_POST['product_price'] ?? 0);
        $categoryId = (int)($_POST['product_category_id'] ?? 0);
        $existing   = $_POST['existing_product_image'] ?? null;

        if ($id > 0 && $name !== '' && $code !== '' && $price > 0 && $categoryId > 0) {
            $imagePath = handle_image_upload('product_image');
            if ($imagePath === null) {
                $imagePath = $existing; // keep old one
            }

            $stmt = $pdo->prepare(
                "UPDATE menu_items
                 SET code = ?, category_id = ?, name = ?, price = ?, image_path = ?
                 WHERE id = ? AND is_bundle = 0"
            );
            $stmt->execute([$code, $categoryId, $name, $price, $imagePath, $id]);
        }
    }

    // Create bundle (no category; standalone)
    if ($action === 'create_bundle') {
        $bundleName   = trim($_POST['bundle_name'] ?? '');
        $bundleCode   = trim($_POST['bundle_code'] ?? '');
        $selectedProd = $_POST['bundle_items'] ?? []; // array of product IDs
        $quantities   = $_POST['bundle_qty'] ?? [];   // keyed by product ID

        if ($bundleName !== '' && $bundleCode !== '' && !empty($selectedProd)) {
            $ids = array_map('intval', $selectedProd);
            $in  = implode(',', $ids);

            $stmt = $pdo->query("SELECT id, price FROM menu_items WHERE id IN ($in) AND is_bundle = 0");
            $prices = [];
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $prices[$row['id']] = (float)$row['price'];
            }

            $total = 0;
            $bundleComponents = [];
            foreach ($ids as $pid) {
                $qty = max(1, (int)($quantities[$pid] ?? 1));
                if (!isset($prices[$pid])) continue;
                $total += $prices[$pid] * $qty;
                $bundleComponents[] = ['id' => $pid, 'qty' => $qty];
            }

            if ($total > 0 && !empty($bundleComponents)) {
                $imagePath = handle_image_upload('bundle_image');

                $stmt = $pdo->prepare(
                    "INSERT INTO menu_items (code, category_id, is_bundle, name, price, image_path, is_active)
                     VALUES (?, NULL, 1, ?, ?, ?, 1)"
                );
                $stmt->execute([$bundleCode, $bundleName, $total, $imagePath]);
                $bundleMenuId = (int)$pdo->lastInsertId();

                $stmtItem = $pdo->prepare(
                    "INSERT INTO bundle_items (bundle_menu_item_id, menu_item_id, quantity)
                     VALUES (?, ?, ?)"
                );
                foreach ($bundleComponents as $comp) {
                    $stmtItem->execute([$bundleMenuId, $comp['id'], $comp['qty']]);
                }
            }
        }
    }

    // Edit bundle (including composition)
    if ($action === 'edit_bundle') {
        $bundleId     = (int)($_POST['bundle_id'] ?? 0);
        $bundleName   = trim($_POST['bundle_name'] ?? '');
        $bundleCode   = trim($_POST['bundle_code'] ?? '');
        $existingImg  = $_POST['existing_bundle_image'] ?? null;
        $selectedProd = $_POST['bundle_items'] ?? [];
        $quantities   = $_POST['bundle_qty'] ?? [];

        if ($bundleId > 0 && $bundleName !== '' && $bundleCode !== '' && !empty($selectedProd)) {
            $ids = array_map('intval', $selectedProd);
            $in  = implode(',', $ids);

            $stmt = $pdo->query("SELECT id, price FROM menu_items WHERE id IN ($in) AND is_bundle = 0");
            $prices = [];
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $prices[$row['id']] = (float)$row['price'];
            }

            $total = 0;
            $bundleComponents = [];
            foreach ($ids as $pid) {
                $qty = max(1, (int)($quantities[$pid] ?? 1));
                if (!isset($prices[$pid])) continue;
                $total += $prices[$pid] * $qty;
                $bundleComponents[] = ['id' => $pid, 'qty' => $qty];
            }

            if ($total > 0 && !empty($bundleComponents)) {
                $imagePath = handle_image_upload('bundle_image');
                if ($imagePath === null) {
                    $imagePath = $existingImg;
                }

                // Update main bundle record
                $stmt = $pdo->prepare(
                    "UPDATE menu_items
                     SET code = ?, name = ?, price = ?, image_path = ?
                     WHERE id = ? AND is_bundle = 1"
                );
                $stmt->execute([$bundleCode, $bundleName, $total, $imagePath, $bundleId]);

                // Replace bundle items
                $stmtDel = $pdo->prepare("DELETE FROM bundle_items WHERE bundle_menu_item_id = ?");
                $stmtDel->execute([$bundleId]);

                $stmtItem = $pdo->prepare(
                    "INSERT INTO bundle_items (bundle_menu_item_id, menu_item_id, quantity)
                     VALUES (?, ?, ?)"
                );
                foreach ($bundleComponents as $comp) {
                    $stmtItem->execute([$bundleId, $comp['id'], $comp['qty']]);
                }
            }
        }
    }

    // After any POST, redirect to avoid form resubmission
    header('Location: insights_&_statistics.php');
    exit;
}

// --- Fetch data for UI ---
$categories = $pdo->query("SELECT id, name FROM product_categories ORDER BY name")->fetchAll(PDO::FETCH_ASSOC);

$products   = $pdo->query(
    "SELECT m.id, m.code, m.name, m.price, m.is_bundle, m.image_path,
            m.category_id,
            c.name AS category_name
     FROM menu_items m
     LEFT JOIN product_categories c ON c.id = m.category_id
     ORDER BY m.is_bundle ASC, c.name ASC, m.name ASC"
)->fetchAll(PDO::FETCH_ASSOC);

// Separate lists
$singleProducts = array_values(array_filter($products, fn($p) => (int)$p['is_bundle'] === 0));
$bundles        = array_values(array_filter($products, fn($p) => (int)$p['is_bundle'] === 1));

// Bundle details for "View" modal and Edit prefill
$bundleItemsByBundle = [];
$stmtDetails = $pdo->prepare(
    "SELECT bi.bundle_menu_item_id, bi.menu_item_id, bi.quantity,
            m.name, m.price
     FROM bundle_items bi
     JOIN menu_items m ON m.id = bi.menu_item_id
     ORDER BY bi.bundle_menu_item_id, m.name"
);
while ($row = $stmtDetails->fetch(PDO::FETCH_ASSOC)) {
    $bid = (int)$row['bundle_menu_item_id'];
    $mid = (int)$row['menu_item_id'];
    $qty = (int)$row['quantity'];
    $price = (float)$row['price'];
    $bundleItemsByBundle[$bid][] = [
        'id'       => $mid,
        'name'     => $row['name'],
        'quantity' => $qty,
        'price'    => $price,
        'subtotal' => $qty * $price
    ];
}

// Stats / insights
$stats = [
    'categories' => count($categories),
    'products'   => count($singleProducts),
    'bundles'    => count($bundles)
];
?>
?>
<!DOCTYPE html>
<html>
<head>
    <title>Products Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<style>
		/* Sticky table headers for scrollable table containers */
		.table-sticky-header thead th {
			position: sticky;
			top: 0;
			z-index: 2;
			background-color: #f8f9fa; /* same as .table-light */
		}

        /* Sidebar Styling */
        .sidebar {
            width: 240px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: #36454F;
            padding-top: 60px;
            color: white;
            overflow-y: auto;
        }
        .sidebar a {
            display: block;
            padding: 10px 18px;
            color: #ddd;
            text-decoration: none;
            font-size: 0.9rem;
        }
        .sidebar a:hover {
            background: #495057;
            color: #fff;
        }
        /* Push content to the right when sidebar exists */
        .content {
            margin-left: 240px;
            padding: 15px;
            padding: 10px 15px;
            text-align: center;
        }

        .table-center {
            display: flex;
            justify-content: center; /* horizontal center */
        }
	</style>
</head>

<body class="bg-light" style="font-size:0.875rem;">
<div class="sidebar">
    <h2 class="text-center mb-3">Admin Panel</h2>
    <a href="insights_&_statistics.php">Insights & Statistics</a>
    <a href="products.php">Products</a>
    <a href="categories.php">Categories</a>
    <a href="bundles.php">Bundles</a>
</div>

<div class="content">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-3">
    <div class="container-fluid">
        <span class="navbar-brand">Products Management</span>
        <a href="admin_dashboard.php" class="btn btn-outline-light btn-sm ms-auto">Back to Dashboard</a>
    </div>
</nav>

<div class="container mb-1">

    <!-- ROW 1: Insights + Products -->
    <div class="row g-3 mb-4">
        <div class="table-center">
            <!-- Insights / Stats col-4 -->
            <div class="col-md-12">
                <div class="card shadow-sm" style="max-height:380px;">
                    <div class="card-header bg-secondary text-white py-1">
                        <strong style="font-size:0.9rem;">Insights & Statistics</strong>
                    </div>
                    <div class="card-body py-2 small" style="max-height:250px; overflow-y:auto;">
                        <ul class="list-group list-group-flush mb-3">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Categories
                                <span class="badge bg-primary rounded-pill"><?= (int)$stats['categories'] ?></span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Products
                                <span class="badge bg-success rounded-pill"><?= (int)$stats['products'] ?></span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Bundles
                                <span class="badge bg-warning text-dark rounded-pill"><?= (int)$stats['bundles'] ?></span>
                            </li>
                        </ul>
                        <div class="text-muted">
                            <small>
                                These stats update automatically as you add or edit categories, products, and bundles.
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div> <!-- container -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
