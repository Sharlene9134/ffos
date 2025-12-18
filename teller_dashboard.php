<?php
require_once 'auth_terminal.php';

if ($_SESSION['terminal_type'] !== 'TELLER') {
    header('Location: index.php');
    exit;
}

require_once 'config.php';

// Only today's orders, ordered by updated_at ASC
$stmt = $pdo->prepare("
    SELECT id, display_number, total_amount, status, created_at, updated_at, paid_at
    FROM orders
    WHERE DATE(created_at) = CURDATE()
    ORDER BY updated_at ASC
");
$stmt->execute();
$orders = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Products for teller to add to orders
$prodStmt = $pdo->query("
    SELECT id, name, price, image_path
    FROM menu_items
    WHERE is_active = 1
    ORDER BY name
");
$menuItems = $prodStmt->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html>
<head>
    <title>Teller Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-size: 0.9rem; }

        .table-scroll {
            max-height: 340px;
            overflow-y: auto;
            overflow-x: hidden;
        }
        .table-scroll table { margin-bottom: 0; }
        .table-scroll thead th {
            position: sticky;
            top: 0;
            z-index: 5;
            background-color: #f8f9fa;
        }

        .table-scroll-small {
            max-height: 170px;
            overflow-y: scroll;
            overflow-x: hidden;
        }
		.table-scroll-small2 {
            height: 340px;
            overflow-y: scroll;
            overflow-x: hidden;
        }
        .table-scroll-small table,.table-scroll-small2 table { margin-bottom: 0; }
        .table-scroll-small thead th, .table-scroll-small2 thead th {
            position: sticky;
            top: 0;
            z-index: 5;
            background-color: #f8f9fa;
        }

        .menu-card-img {
            height: 90px;
            object-fit: cover;
        }
        .order-item-row input[type="number"]::-webkit-outer-spin-button,
        .order-item-row input[type="number"]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        .order-item-row input[type="number"] {
            -moz-appearance: textfield;
        }

        .status-filter-btn.active {
            font-weight: 600;
        }
    </style>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-3">
    <div class="container-fluid">
        <span class="navbar-brand">Teller Dashboard</span>
        <div class="ms-auto d-flex align-items-center">
            <span class="navbar-text text-white me-3">
                <?= htmlspecialchars($_SESSION['employee_name']) ?>
            </span>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="container-fluid mb-4">
    <div class="card shadow-sm">
        <div class="card-header py-2">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center">
                <div class="mb-2 mb-md-0">
                    <strong>Orders for Today</strong>
                    <span class="text-muted small ms-2">(Ordered by last update)</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <input type="text"
                           id="orderSearch"
                           class="form-control form-control-sm"
                           placeholder="Search Order #"
                           style="width:180px;">
                </div>
            </div>
            <div class="mt-2">
                <div class="btn-group btn-group-sm" role="group">
                    <button type="button" class="btn btn-outline-secondary status-filter-btn active"
                            data-status="ALL" onclick="setStatusFilter('ALL')">
                        ALL
                    </button>
                    <button type="button" class="btn btn-outline-secondary status-filter-btn"
                            data-status="UNPAID" onclick="setStatusFilter('UNPAID')">
                        UNPAID
                    </button>
                    <button type="button" class="btn btn-outline-secondary status-filter-btn"
                            data-status="IN_PROCESS" onclick="setStatusFilter('IN_PROCESS')">
                        IN_PROCESS
                    </button>
                    <button type="button" class="btn btn-outline-secondary status-filter-btn"
                            data-status="READY_FOR_CLAIM" onclick="setStatusFilter('READY_FOR_CLAIM')">
                        READY_FOR_CLAIM
                    </button>
                    <button type="button" class="btn btn-outline-secondary status-filter-btn"
                            data-status="CLAIMED" onclick="setStatusFilter('CLAIMED')">
                        CLAIMED
                    </button>
                    <button type="button" class="btn btn-outline-secondary status-filter-btn"
                            data-status="CANCELLED" onclick="setStatusFilter('CANCELLED')">
                        CANCELLED
                    </button>
                </div>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-scroll">
                <table class="table table-sm align-middle">
                    <thead class="table-light">
                    <tr>
                        <th style="width:80px;">Order #</th>
                        <th class="text-end">Total</th>
                        <th>Status</th>
                        <th>Ordered On</th>
                        <th>Paid On</th>
                        <th style="width:150px;" class="text-end">Action</th>
                    </tr>
                    </thead>
                    <tbody id="ordersTbody">
                    <?php
                    $seq = 1;
                    foreach ($orders as $o):
                        $displayNo = isset($o['display_number']) && $o['display_number'] !== null
                            ? (int)$o['display_number']
                            : $seq;
                        $displayStr = str_pad($displayNo, 4, '0', STR_PAD_LEFT);
                        $seq++;
                        $orderedOn = $o['created_at'] ? date('Y-m-d H:i', strtotime($o['created_at'])) : '';
                        $paidOn    = $o['paid_at'] ? date('Y-m-d H:i', strtotime($o['paid_at'])) : '';
                        // Normalize status (handle legacy values like PENDING, null, etc.)
						$rawStatus = strtoupper(trim($o['status'] ?? ''));
						if ($rawStatus === '' || $rawStatus === 'PENDING') {
							$status = 'UNPAID';
						} else {
							$status = $rawStatus;
						}

						// Build action buttons based on normalized status
						$actionsHtml = '';
						if ($status === 'UNPAID') {
							$actionsHtml =
								'<button class="btn btn-sm btn-warning me-1" ' .
								'onclick="openOrderModal(' . (int)$o['id'] . ', \'' . $displayStr . '\')">Pay</button>' .
								'<button class="btn btn-sm btn-outline-danger" ' .
								'onclick="cancelOrder(' . (int)$o['id'] . ', \'' . $displayStr . '\')">Cancel</button>';
						} else {
							$actionsHtml =
								'<button class="btn btn-sm btn-secondary" ' .
								'onclick="openOrderModal(' . (int)$o['id'] . ', \'' . $displayStr . '\')">View</button>';
						}

                    ?>
                        <tr data-order-id="<?= (int)$o['id'] ?>"
                            data-display-number="<?= htmlspecialchars($displayStr) ?>"
                            data-status="<?= htmlspecialchars($status) ?>">
                            <td><?= htmlspecialchars($displayStr) ?></td>
                            <td class="text-end">₱<?= number_format((float)$o['total_amount'], 2) ?></td>
                            <td><?= htmlspecialchars($status) ?></td>
                            <td><?= htmlspecialchars($orderedOn) ?></td>
                            <td><?= $paidOn ? htmlspecialchars($paidOn) : '<span class="text-muted">-</span>' ?></td>
                            <td class="text-end"><?= $actionsHtml ?></td>
                        </tr>
                    <?php endforeach; ?>
                    <?php if (!$orders): ?>
                        <tr>
                            <td colspan="6" class="text-center text-muted py-3">
                                No orders for today.
                            </td>
                        </tr>
                    <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Order View/Pay Modal -->
<div class="modal fade" id="orderModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header py-2">
        <h5 class="modal-title">
            Order #<span id="modalOrderId"></span>
            <span class="text-muted small ms-2">(Seq <span id="modalOrderSeq"></span>)</span>
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body small">
        <div class="row g-3">
            <!-- Left: order items -->
            <div class="col-md-7">
                <div class="card border-0">
                    <div class="card-header bg-warning py-2">
                        <strong>Order Items</strong>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-scroll-small2">
                            <table class="table table-sm align-middle" id="orderItemsTable">
                                <thead class="table-light">
                                <tr>
                                    <th>Item</th>
                                    <th class="text-center" style="width:80px;">Qty</th>
                                    <th class="text-end">Price</th>
                                    <th class="text-end">Sub</th>
                                    <th style="width:80px;">Source</th>
                                    <th style="width:40px;"></th>
                                </tr>
                                </thead>
                                <tbody id="orderItemsBody">
                                <!-- JS inject -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer py-2">
                        <div class="d-flex justify-content-between">
                            <span>Total:</span>
                            <strong>₱<span id="modalOrderTotal">0.00</span></strong>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: product listing to add items -->
            <div class="col-md-5">
                <div class="card border-0">
                    <div class="card-header bg-info py-2 d-flex justify-content-between align-items-center">
                        <strong>Add Products</strong>
                        <small class="text-muted">Click "Add" to include items (marked as Teller).</small>
                    </div>
                    <div class="card-body p-2">
                        <div class="table-scroll-small">
                            <table class="table table-sm align-middle">
                                <thead class="table-light">
                                <tr>
                                    <th>Product</th>
                                    <th class="text-end">Price</th>
                                    <th style="width:80px;" class="text-end">Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <?php foreach ($menuItems as $p): ?>
                                    <tr>
                                        <td>
                                            <div class="fw-semibold"><?= htmlspecialchars($p['name'] ?? '') ?></div>
                                        </td>
                                        <td class="text-end">₱<?= number_format((float)$p['price'], 2) ?></td>
                                        <td class="text-end">
                                            <button type="button"
                                                    class="btn btn-sm btn-outline-primary"
                                                    onclick="tellerAddItem(
                                                        <?= (int)$p['id'] ?>,
                                                        '<?= htmlspecialchars($p['name'] ?? '', ENT_QUOTES) ?>',
                                                        <?= (float)$p['price'] ?>
                                                    )">
                                                Add
                                            </button>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                                <?php if (!$menuItems): ?>
                                    <tr>
                                        <td colspan="3" class="text-center text-muted py-2">
                                            No products configured.
                                        </td>
                                    </tr>
                                <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Payment area -->
                <div class="card border-0 mt-3">
                    <div class="card-header bg-success py-2">
                        <strong>Payment</strong>
                    </div>
                    <div class="card-body py-2">
                        <div class="mb-2">
                            <label class="form-label mb-1">
                                Cash Received <span class="text-danger">*</span>
                            </label>
                            <div class="input-group input-group-sm" style="max-width:220px;">
                                <span class="input-group-text">₱</span>
                                <input type="text"
                                       id="cashInput"
                                       class="form-control"
                                       placeholder="0"
                                       autocomplete="off">
                            </div>
                            <div class="form-text">
                                Comma-separated as you type. Only digits will be used.
                            </div>
                        </div>
                        <div class="mb-0">
                            <strong>Change:</strong>
                            ₱<span id="changeAmount">0.00</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
      </div>
      <div class="modal-footer py-2">
        <!-- No explicit Cancel button, only X at top -->
        <button type="button" class="btn btn-success btn-sm" onclick="confirmPayment()">
            Confirm Payment
        </button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
let orderModal;
let currentOrderId = null;
let currentOrderSeq = '';
let orderItems = []; // {id?, menu_item_id, name, price, qty, source}
let currentStatusFilter = 'ALL';
let currentOrderStatus = 'UNPAID';

// WebSocket variable
let ws = null;

document.addEventListener('DOMContentLoaded', () => {
    orderModal = new bootstrap.Modal(document.getElementById('orderModal'));

    const searchInput = document.getElementById('orderSearch');
    searchInput.addEventListener('input', applyFilters);

    const cashInput = document.getElementById('cashInput');
    cashInput.addEventListener('input', handleCashInput);

    initWebSocket();
});

function pad4(n) {
    n = parseInt(n, 10) || 0;
    return n.toString().padStart(4, '0');
}

// STATUS FILTERS
function setStatusFilter(status) {
    currentStatusFilter = status;
    document.querySelectorAll('.status-filter-btn').forEach(btn => {
        if (btn.dataset.status === status) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
    applyFilters();
}

function applyFilters() {
    const q = (document.getElementById('orderSearch').value || '').trim().toLowerCase();
    document.querySelectorAll('#ordersTbody tr[data-order-id]').forEach(tr => {
        const disp = (tr.dataset.displayNumber || '').toLowerCase();
        const status = tr.dataset.status || '';
        let visible = true;

        if (q && !disp.includes(q)) {
            visible = false;
        }
        if (currentStatusFilter !== 'ALL' && status !== currentStatusFilter) {
            visible = false;
        }

        if (visible) tr.classList.remove('d-none');
        else tr.classList.add('d-none');
    });
}

// WebSocket connection
function initWebSocket() {
    try {
        const loc = window.location;
        const wsUrl = (loc.protocol === 'https:' ? 'wss://' : 'ws://') + loc.hostname + ':8080';
        ws = new WebSocket(wsUrl);

        ws.onmessage = (event) => {
            try {
                const data = JSON.parse(event.data);
                if (data.type === 'order_created' || data.type === 'order_updated') {
                    reloadOrders();
                }
            } catch (e) {
                console.error('Bad WS message', e);
            }
        };
        ws.onclose = () => {
            setTimeout(initWebSocket, 3000);
        };
    } catch (e) {
        console.error('WS init error', e);
    }
}

// Reload orders via AJAX
function reloadOrders() {
    fetch('api_get_orders_today.php')
        .then(r => r.json())
        .then(res => {
            if (!res.success) return;
            const tbody = document.getElementById('ordersTbody');
            tbody.innerHTML = '';
            const orders = res.orders || [];
            if (!orders.length) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="6" class="text-center text-muted py-3">
                            No orders for today.
                        </td>
                    </tr>`;
                return;
            }

            orders.forEach(o => {
                const displayNo = o.display_number ? pad4(o.display_number) : pad4(o.seq);
                const orderedOn = o.ordered_on || '';
                const paidOn = o.paid_on ? o.paid_on : '<span class="text-muted">-</span>';
                const status = o.status || 'UNPAID';

                let actionsHtml = '';
                if (status === 'UNPAID') {
                    actionsHtml =
                        `<button class="btn btn-sm btn-warning me-1"
                                  onclick="openOrderModal(${o.id}, '${displayNo}')">Pay</button>` +
                        `<button class="btn btn-sm btn-outline-danger"
                                  onclick="cancelOrder(${o.id}, '${displayNo}')">Cancel</button>`;
                } else {
                    actionsHtml =
                        `<button class="btn btn-sm btn-secondary"
                                  onclick="openOrderModal(${o.id}, '${displayNo}')">View</button>`;
                }

                const tr = document.createElement('tr');
                tr.dataset.orderId = o.id;
                tr.dataset.displayNumber = displayNo;
                tr.dataset.status = status;
                tr.innerHTML = `
                    <td>${displayNo}</td>
                    <td class="text-end">₱${parseFloat(o.total_amount).toFixed(2)}</td>
                    <td>${status}</td>
                    <td>${orderedOn}</td>
                    <td>${paidOn}</td>
                    <td class="text-end">${actionsHtml}</td>
                `;
                tbody.appendChild(tr);
            });

            applyFilters();
        })
        .catch(err => console.error('reloadOrders error', err));
}

function openOrderModal(orderId, displayNumber) {
    currentOrderId = orderId;
    currentOrderSeq = displayNumber || '';
    currentOrderStatus = 'UNPAID';

    document.getElementById('modalOrderId').textContent = displayNumber;
    document.getElementById('modalOrderSeq').textContent = displayNumber;

    // reset items + payment UI
    orderItems = [];
    renderOrderItems();
    document.getElementById('cashInput').value = '';
    document.getElementById('changeAmount').textContent = '0.00';

    fetch('api_get_order.php?order_id=' + encodeURIComponent(orderId))
        .then(r => r.json())
        .then(res => {
            if (!res.success) {
                alert(res.error || 'Error fetching order.');
                return;
            }

            const order = res.order || {};
            const items = res.items || [];

            currentOrderStatus = (order.status || 'UNPAID').toUpperCase();

            // hydrate items
            orderItems = items.map(it => ({
                id: it.id || null,
                menu_item_id: it.menu_item_id,
                name: it.name,
                price: parseFloat(it.price),
                qty: parseInt(it.quantity),
                source: it.source === 'TELLER' ? 'TELLER' : 'CUSTOMER'
            }));
            renderOrderItems(); // recompute total

            // always show stored cash + change
            const cashReceived = order.cash_received != null ? Number(order.cash_received) : 0;
            const changeAmount = order.change_amount != null ? Number(order.change_amount) : 0;

            if (cashReceived > 0) {
                document.getElementById('cashInput').value =
                    cashReceived.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            } else {
                document.getElementById('cashInput').value = '';
            }

            if (changeAmount > 0) {
                document.getElementById('changeAmount').textContent = changeAmount.toFixed(2);
            } else {
                if (currentOrderStatus === 'UNPAID') {
                    updateChange();
                } else {
                    document.getElementById('changeAmount').textContent = '0.00';
                }
            }

            updatePaymentUiState();   // lock/unlock fields based on status
            orderModal.show();
        })
        .catch(err => {
            console.error('api_get_order error', err);
            alert('Network error fetching order');
        });
}



function updatePaymentUiState() {
    const isEditable = (currentOrderStatus === 'UNPAID');

    const confirmBtn = document.querySelector('#orderModal .btn-success');
    if (confirmBtn) {
        confirmBtn.style.display = isEditable ? 'inline-block' : 'none';
    }

    const cashInput = document.getElementById('cashInput');
    if (cashInput) {
        cashInput.disabled = !isEditable;
    }

    const qtyInputs = document.querySelectorAll('#orderItemsBody input[type="number"]');
    qtyInputs.forEach(inp => { inp.disabled = !isEditable; });

    const removeButtons = document.querySelectorAll('#orderItemsBody button');
    removeButtons.forEach(btn => { btn.disabled = !isEditable; });

    const addButtons = document.querySelectorAll('button[onclick^="tellerAddItem"]');
    addButtons.forEach(btn => { btn.disabled = !isEditable; });
}





function renderOrderItems() {
    const tbody = document.getElementById('orderItemsBody');
    tbody.innerHTML = '';
    let total = 0;

    orderItems.forEach((item, idx) => {
        const sub = item.price * item.qty;
        total += sub;

        const tr = document.createElement('tr');
        tr.className = 'order-item-row';
        tr.innerHTML = `
            <td>${item.name}</td>
            <td class="text-center">
                <input type="number"
                       min="1"
                       class="form-control form-control-sm text-center"
                       style="width:70px;"
                       value="${item.qty}"
                       onchange="updateItemQty(${idx}, this.value)">
            </td>
            <td class="text-end">₱${item.price.toFixed(2)}</td>
            <td class="text-end">₱${sub.toFixed(2)}</td>
            <td>${item.source === 'TELLER'
                ? '<span class="badge bg-info">Teller</span>'
                : '<span class="badge bg-secondary">Customer</span>'}</td>
            <td class="text-end">
                <button type="button"
                        class="btn btn-sm btn-outline-danger py-0 px-1"
                        onclick="removeOrderItem(${idx})">
                    &times;
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });

    document.getElementById('modalOrderTotal').textContent = total.toFixed(2);
    updateChange();
	updatePaymentUiState(); // ensure UI reflects currentOrderStatus after any re-render
}

function updateItemQty(index, value) {
    let qty = parseInt(value);
    if (isNaN(qty) || qty <= 0) {
        removeOrderItem(index);
        return;
    }
    if (!orderItems[index]) return;
    orderItems[index].qty = qty;
    renderOrderItems();
}

function removeOrderItem(index) {
    if (!orderItems[index]) return;
    orderItems.splice(index, 1);
    renderOrderItems();
}

function tellerAddItem(menuItemId, name, price) {
    price = parseFloat(price);
    const existingIndex = orderItems.findIndex(i => i.menu_item_id === menuItemId && i.source === 'TELLER');
    if (existingIndex !== -1) {
        orderItems[existingIndex].qty++;
    } else {
        orderItems.push({
            id: null,
            menu_item_id: menuItemId,
            name: name,
            price: price,
            qty: 1,
            source: 'TELLER'
        });
    }
    renderOrderItems();
}

// Cash input formatting with commas
function handleCashInput(e) {
    let val = e.target.value;
    val = val.replace(/[^0-9]/g, '');
    if (val === '') {
        e.target.value = '';
        updateChange();
        return;
    }
    const num = parseInt(val, 10);
    if (isNaN(num)) {
        e.target.value = '';
        updateChange();
        return;
    }
    e.target.value = num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    updateChange();
}

function getCashNumeric() {
    const raw = document.getElementById('cashInput').value.replace(/,/g, '');
    const num = parseInt(raw, 10);
    return isNaN(num) ? 0 : num;
}

function updateChange() {
    const total = parseFloat(document.getElementById('modalOrderTotal').textContent) || 0;
    const cash = getCashNumeric();
    const change = cash - total;
    document.getElementById('changeAmount').textContent = change > 0 ? change.toFixed(2) : '0.00';
}

function confirmPayment() {
    if (!currentOrderId) return;
    if (!orderItems.length) {
        alert('Order has no items.');
        return;
    }
    const cash = getCashNumeric();
    const total = parseFloat(document.getElementById('modalOrderTotal').textContent) || 0;
    if (cash < total) {
        alert('Cash received is less than total.');
        return;
    }

    const payload = {
        order_id: currentOrderId,
        items: orderItems.map(i => ({
            id: i.id,
            menu_item_id: i.menu_item_id,
            quantity: i.qty,
            price: i.price,
            source: i.source
        })),
        cash: cash
    };

    const fd = new FormData();
    fd.append('payload', JSON.stringify(payload));

    fetch('api_teller_update_order.php', {
        method: 'POST',
        body: fd
    })
        .then(r => r.json())
        .then(res => {
            if (!res.success) {
                alert(res.error || 'Error saving payment.');
                return;
            }
            alert('Payment recorded. Change: ₱' + (res.change ?? 0).toFixed(2));
            reloadOrders();
            orderModal.hide();
        })
        .catch(() => {
            alert('Network error saving payment.');
        });
}

function cancelOrder(orderId, displayNumber) {
    if (!confirm('Cancel order #' + displayNumber + '?')) return;
    const fd = new FormData();
    fd.append('order_id', orderId);

    fetch('api_teller_cancel_order.php', {
        method: 'POST',
        body: fd
    })
        .then(r => r.json())
        .then(res => {
            if (!res.success) {
                alert(res.error || 'Error cancelling order.');
                return;
            }
            reloadOrders();
        })
        .catch(() => {
            alert('Network error cancelling order.');
        });
}
</script>
</body>
</html>
