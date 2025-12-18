<?php
require_once 'config.php';
if (empty($_SESSION['admin'])) {
    header("Location: " . $_SERVER['HTTP_REFERER']);
    exit;
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-3">
    <div class="container-fluid">
        <span class="navbar-brand">Admin Dashboard</span>
        <a href="admin_login.php" class="btn btn-outline-light btn-sm ms-auto">Admin Home</a>
    </div>
</nav>

<div class="container">
    <div class="card shadow-sm">
        <div class="card-body">
            <h1 class="h4">Admin Dashboard</h1>
            <ul class="list-group mt-3">
				<li class="list-group-item">
					<a href="admin_terminals.php" class="text-decoration-none">Terminal Management</a>
				</li>
				<li class="list-group-item">
					<a href="insights_&_statistics.php" class="text-decoration-none">Products Management</a>
				</li>
                <li class="list-group-item">
					<a href="sales_report.php" class="text-decoration-none">Sales Report</a>
				</li>
			</ul>

            <p class="mt-3 mb-0">
                <a href="logout.php" class="btn btn-outline-secondary btn-sm">Logout Terminal Session</a>
                <span class="text-muted ms-2">(Admin session uses separate page; add admin logout if needed.)</span>
            </p>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
