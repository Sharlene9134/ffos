<?php
require_once 'config.php'; 

// --- Calculate time frames ---
$today = date('Y-m-d');
$thisWeekStart = date('Y-m-d', strtotime('monday this week'));
$thisMonthStart = date('Y-m-01');
$thisYearStart = date('Y-01-01');

// --- Function to fetch sales data ---
function getSalesData($pdo, $startDate, $endDate = null) {
    $query = "SELECT SUM(total_amount) AS total, COUNT(*) AS orders_count
              FROM orders
              WHERE created_at >= ? ";
    $params = [$startDate];
    if ($endDate) {
        $query .= " AND created_at <= ?";
        $params[] = $endDate;
    }
    $stmt = $pdo->prepare($query);
    $stmt->execute($params);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

// Sales summaries
$salesToday = getSalesData($pdo, $today);
$salesWeek  = getSalesData($pdo, $thisWeekStart);
$salesMonth = getSalesData($pdo, $thisMonthStart);
$salesYear  = getSalesData($pdo, $thisYearStart);

// Fetch today's orders for table
$stmtDetails = $pdo->prepare("
    SELECT id, total_amount, created_at 
    FROM orders 
    WHERE DATE(created_at) = ? 
    ORDER BY created_at DESC
");

$stmtDetails->execute([$today]);
$ordersToday = $stmtDetails->fetchAll(PDO::FETCH_ASSOC);

// Breakdown: last 7 days
$stmtDays = $pdo->prepare("SELECT DATE(created_at) AS day, COUNT(*) AS orders_count, SUM(total_amount) AS total
    FROM orders
    WHERE DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
    GROUP BY DATE(created_at)
    ORDER BY DATE(created_at) ASC");
$stmtDays->execute();
$breakdownDays = $stmtDays->fetchAll(PDO::FETCH_ASSOC);

// Breakdown: last 8 weeks (ISO weeks)
$stmtWeeks = $pdo->prepare("SELECT YEAR(created_at) AS yr, WEEK(created_at, 1) AS wk, COUNT(*) AS orders_count, SUM(total_amount) AS total
    FROM orders
    WHERE YEARWEEK(created_at,1) >= YEARWEEK(DATE_SUB(CURDATE(), INTERVAL 7 WEEK),1)
    GROUP BY YEARWEEK(created_at,1)
    ORDER BY YEARWEEK(created_at,1) ASC");
$stmtWeeks->execute();
$breakdownWeeks = $stmtWeeks->fetchAll(PDO::FETCH_ASSOC);

// Breakdown: last 12 months
$stmtMonths = $pdo->prepare("SELECT DATE_FORMAT(created_at, '%Y-%m') AS month, COUNT(*) AS orders_count, SUM(total_amount) AS total
    FROM orders
    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 11 MONTH)
    GROUP BY month
    ORDER BY month ASC");
$stmtMonths->execute();
$breakdownMonths = $stmtMonths->fetchAll(PDO::FETCH_ASSOC);

// Breakdown: last 5 years
$stmtYears = $pdo->prepare("SELECT YEAR(created_at) AS year, COUNT(*) AS orders_count, SUM(total_amount) AS total
    FROM orders
    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 4 YEAR)
    GROUP BY year
    ORDER BY year ASC");
$stmtYears->execute();
$breakdownYears = $stmtYears->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Summary Cards */
        .summary-cards {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 30px;
        }
        .summary-card {
            flex: 1 1 calc(50% - 15px);
            background-color: #D3D3D3;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 6px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .summary-card h6 {
            color: #000000;
            margin-bottom: 10px;
            font-weight: 500;
        }
        .summary-card h4 {
            font-weight: 700;
            margin-bottom: 5px;
        }
        .summary-card small {
            color: #000000;
        }
        .container{
            padding: 10px;
        }
        .table-card{
            background-color: #FFFFFF;
            padding: 15px;
            border-radius: 8px;
            border: #000000 1px solid;
            margin-bottom: 30px;
            text-align: center;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-3">
    <div class="container-fluid">
        <span class="navbar-brand">Sales Report</span>
        <a href="admin_dashboard.php" class="btn btn-outline-light btn-sm ms-auto">Back to Dashboard</a>
    </div>
</nav>
<div class="container">
    <div class="summary-cards">
        <div class="summary-card">
            <h6>Sales Today</h6>
            <h4>₱<?= number_format($salesToday['total'] ?? 0, 2) ?></h4>
            <small><?= $salesToday['orders_count'] ?? 0 ?> Orders</small>
        </div>
        <div class="summary-card">
            <h6>Sales This Week</h6>
            <h4>₱<?= number_format($salesWeek['total'] ?? 0, 2) ?></h4>
            <small><?= $salesWeek['orders_count'] ?? 0 ?> Orders</small>
        </div>
        <div class="summary-card">
            <h6>Sales This Month</h6>
            <h4>₱<?= number_format($salesMonth['total'] ?? 0, 2) ?></h4>
            <small><?= $salesMonth['orders_count'] ?? 0 ?> Orders</small>
        </div>
        <div class="summary-card">
            <h6>Sales This Year</h6>
            <h4>₱<?= number_format($salesYear['total'] ?? 0, 2) ?></h4>
            <small><?= $salesYear['orders_count'] ?? 0 ?> Orders</small>
        </div>
    </div>
    <div>
        <div class="table-card">
            <h5>Today's Orders</h5>
            <table class="table table-sm table-bordered">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Total</th>
                        <th>Time</th>
                    </tr>
                </thead>
                <tbody>
                <?php foreach ($ordersToday as $o): ?>
                    <tr>
                        <td><?= htmlspecialchars($o['id']) ?></td>
                        <td>₱<?= number_format($o['total_amount'], 2) ?></td>
                        <td><?= htmlspecialchars($o['created_at']) ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        </div>
        
        <div class="table-card">
            <h5>Last 7 Days</h5>
            <table class="table table-sm table-striped">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Orders</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                <?php foreach ($breakdownDays as $d): ?>
                    <tr>
                        <td><?= htmlspecialchars($d['day']) ?></td>
                        <td><?= (int)$d['orders_count'] ?></td>
                        <td>₱<?= number_format($d['total'] ?? 0, 2) ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        </div>    
        <div class="table-card">
            <h5>Last 8 Weeks</h5>
            <table class="table table-sm table-striped">
                <thead>
                    <tr>
                        <th>Week</th>
                        <th>Orders</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                <?php foreach ($breakdownWeeks as $w):
                    $label = $w['yr'] . '-W' . str_pad($w['wk'],2,'0',STR_PAD_LEFT);
                ?>
                    <tr>
                        <td><?= htmlspecialchars($label) ?></td>
                        <td><?= (int)$w['orders_count'] ?></td>
                        <td>₱<?= number_format($w['total'] ?? 0, 2) ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        </div>

        <div class="table-card">
            <h5>Last 12 Months</h5>
            <table class="table table-sm table-striped">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th>Orders</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                <?php foreach ($breakdownMonths as $m): ?>
                    <tr>
                        <td><?= htmlspecialchars($m['month']) ?></td>
                        <td><?= (int)$m['orders_count'] ?></td>
                        <td>₱<?= number_format($m['total'] ?? 0, 2) ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>