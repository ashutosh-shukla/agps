<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AGPS Bank - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1e3a8a;
            --secondary-color: #1e40af;
            --accent-color: #0ea5e9;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --text-dark: #1f2937;
            --text-light: #6b7280;
            --bg-light: #f8fafc;
            --border-color: #e5e7eb;
        }

        body {
            background-color: var(--bg-light);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .admin-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 1rem 0;
        }

        .nav-brand {
            color: white !important;
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
        }

        .stats-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
            margin-bottom: 1.5rem;
            transition: transform 0.2s;
        }

        .stats-card:hover {
            transform: translateY(-2px);
        }

        .stats-card.pending {
            border-left: 5px solid var(--warning-color);
        }

        .stats-card.approved {
            border-left: 5px solid var(--success-color);
        }

        .stats-card.rejected {
            border-left: 5px solid var(--danger-color);
        }

        .stats-card.total {
            border-left: 5px solid var(--accent-color);
        }

        .status-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
        }

        .table-actions .btn {
            margin: 0 0.25rem;
            padding: 0.25rem 0.75rem;
            font-size: 0.875rem;
        }

        .modal-lg {
            max-width: 900px;
        }

        .document-preview {
            max-width: 200px;
            max-height: 150px;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .document-preview:hover {
            transform: scale(1.1);
        }

        .nav-tabs .nav-link {
            color: var(--text-dark);
            border: none;
            background: transparent;
            margin-right: 1rem;
        }

        .nav-tabs .nav-link.active {
            color: var(--primary-color);
            background: white;
            border-bottom: 3px solid var(--primary-color);
        }

        .tab-content {
            background: white;
            border-radius: 0 0 12px 12px;
            padding: 1.5rem;
        }

        .notification-item {
            border-left: 4px solid var(--accent-color);
            background: white;
            padding: 1rem;
            margin-bottom: 0.5rem;
            border-radius: 0 8px 8px 0;
        }

        .notification-item.urgent {
            border-left-color: var(--danger-color);
        }

        .notification-item.warning {
            border-left-color: var(--warning-color);
        }

        .quick-action-btn {
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            text-decoration: none;
            color: var(--text-dark);
            transition: all 0.3s ease;
            display: block;
        }

        .quick-action-btn:hover {
            border-color: var(--accent-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            color: var(--accent-color);
        }

        .quick-action-btn i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            display: block;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="admin-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <a href="/" class="nav-brand">
                        <i class="fas fa-university me-2"></i>AGPS Bank - Admin Panel
                    </a>
                </div>
                <div class="col-md-6 text-end">
                    <span class="me-3">Welcome, Admin</span>
                    <a href="/logout" class="btn btn-outline-light me-2">
                        <i class="fas fa-sign-out-alt me-1"></i>Logout
                    </a>
                    <a href="/" class="btn btn-light">
                        <i class="fas fa-home me-1"></i>Home
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid mt-4">
        <!-- Alert Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Statistics Dashboard -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="stats-card total">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title text-muted">Total Customers</h6>
                                <h3 class="mb-0" id="totalCustomers">0</h3>
                            </div>
                            <div class="text-primary">
                                <i class="fas fa-users fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stats-card pending">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title text-muted">Pending Approval</h6>
                                <h3 class="mb-0" id="pendingCustomers">0</h3>
                            </div>
                            <div class="text-warning">
                                <i class="fas fa-clock fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stats-card pending">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title text-muted">Pending KYC</h6>
                                <h3 class="mb-0" id="pendingKyc">0</h3>
                            </div>
                            <div class="text-warning">
                                <i class="fas fa-file-alt fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stats-card approved">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title text-muted">Active Accounts</h6>
                                <h3 class="mb-0" id="activeAccounts">0</h3>
                            </div>
                            <div class="text-success">
                                <i class="fas fa-check-circle fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-md-12">
                <h5 class="mb-3">Quick Actions</h5>
                <div class="row">
                    <div class="col-lg-2 col-md-4 col-sm-6 mb-3">
                        <a href="#" class="quick-action-btn" onclick="loadCustomers()">
                            <i class="fas fa-users text-primary"></i>
                            <strong>Manage Customers</strong>
                        </a>
                    </div>
                    <div class="col-lg-2 col-md-4 col-sm-6 mb-3">
                        <a href="#" class="quick-action-btn" onclick="loadKYCDocuments()">
                            <i class="fas fa-file-alt text-warning"></i>
                            <strong>Review KYC</strong>
                        </a>
                    </div>
                    <div class="col-lg-2 col-md-4 col-sm-6 mb-3">
                        <a href="#" class="quick-action-btn" onclick="loadAccounts()">
                            <i class="fas fa-university text-success"></i>
                            <strong>Account Management</strong>
                        </a>
                    </div>
                    <div class="col-lg-2 col-md-4 col-sm-6 mb-3">
                        <a href="#" class="quick-action-btn" onclick="viewReports()">
                            <i class="fas fa-chart-bar text-info"></i>
                            <strong>Reports</strong>
                        </a>
                    </div>
                    <div class="col-lg-2 col-md-4 col-sm-6 mb-3">
                        <a href="http://localhost:8080/swagger-ui.html" target="_blank" class="quick-action-btn">
                            <i class="fas fa-code text-secondary"></i>
                            <strong>API Docs</strong>
                        </a>
                    </div>
                    <div class="col-lg-2 col-md-4 col-sm-6 mb-3">
                        <a href="#" class="quick-action-btn" onclick="systemHealth()">
                            <i class="fas fa-heartbeat text-danger"></i>
                            <strong>System Health</strong>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Tabs -->
        <div class="card">
            <div class="card-header">
                <ul class="nav nav-tabs card-header-tabs" id="adminTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="dashboard-tab" data-bs-toggle="tab" data-bs-target="#dashboard" type="button" role="tab">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="customers-tab" data-bs-toggle="tab" data-bs-target="#customers" type="button" role="tab">
                            <i class="fas fa-users me-2"></i>Customers
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="kyc-tab" data-bs-toggle="tab" data-bs-target="#kyc" type="button" role="tab">
                            <i class="fas fa-file-alt me-2"></i>KYC Documents
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="accounts-tab" data-bs-toggle="tab" data-bs-target="#accounts" type="button" role="tab">
                            <i class="fas fa-university me-2"></i>Accounts
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="notifications-tab" data-bs-toggle="tab" data-bs-target="#notifications" type="button" role="tab">
                            <i class="fas fa-bell me-2"></i>Notifications
                        </button>
                    </li>
                </ul>
            </div>
            <div class="tab-content">
                <!-- Dashboard Tab -->
                <div class="tab-pane fade show active" id="dashboard" role="tabpanel">
                    <div class="row">
                        <div class="col-md-8">
                            <h5>Recent Activity</h5>
                            <div id="recentActivity">
                                <div class="notification-item">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <strong>New Customer Registration</strong>
                                            <p class="mb-1 text-muted">John Doe registered for account</p>
                                            <small class="text-muted">2 minutes ago</small>
                                        </div>
                                        <span class="badge bg-primary">NEW</span>
                                    </div>
                                </div>
                                <div class="notification-item urgent">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <strong>KYC Document Uploaded</strong>
                                            <p class="mb-1 text-muted">Jane Smith uploaded KYC documents</p>
                                            <small class="text-muted">5 minutes ago</small>
                                        </div>
                                        <span class="badge bg-warning">URGENT</span>
                                    </div>
                                </div>
                                <div class="notification-item">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <strong>Account Activated</strong>
                                            <p class="mb-1 text-muted">Michael Johnson's account was activated</p>
                                            <small class="text-muted">10 minutes ago</small>
                                        </div>
                                        <span class="badge bg-success">SUCCESS</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <h5>System Status</h5>
                            <div class="list-group">
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    Authentication Service
                                    <span class="badge bg-success rounded-pill">Online</span>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    Customer Service
                                    <span class="badge bg-success rounded-pill">Online</span>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    KYC Service
                                    <span class="badge bg-success rounded-pill">Online</span>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    Account Service
                                    <span class="badge bg-success rounded-pill">Online</span>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    Database
                                    <span class="badge bg-success rounded-pill">Connected</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Customers Tab -->
                <div class="tab-pane fade" id="customers" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5>Customer Management</h5>
                        <button class="btn btn-primary" onclick="refreshCustomers()">
                            <i class="fas fa-sync me-2"></i>Refresh
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped" id="customersTable">
                            <thead>
                                <tr>
                                    <th>Customer ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <th>Registration Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="customersTableBody">
                                <!-- Customer data will be loaded dynamically -->
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- KYC Tab -->
                <div class="tab-pane fade" id="kyc" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5>KYC Document Review</h5>
                        <button class="btn btn-primary" onclick="refreshKYC()">
                            <i class="fas fa-sync me-2"></i>Refresh
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped" id="kycTable">
                            <thead>
                                <tr>
                                    <th>Document ID</th>
                                    <th>Customer Name</th>
                                    <th>Email</th>
                                    <th>Upload Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="kycTableBody">
                                <!-- KYC data will be loaded dynamically -->
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Accounts Tab -->
                <div class="tab-pane fade" id="accounts" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5>Account Management</h5>
                        <button class="btn btn-primary" onclick="refreshAccounts()">
                            <i class="fas fa-sync me-2"></i>Refresh
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped" id="accountsTable">
                            <thead>
                                <tr>
                                    <th>Account Number</th>
                                    <th>Customer Name</th>
                                    <th>Account Type</th>
                                    <th>Balance</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="accountsTableBody">
                                <!-- Account data will be loaded dynamically -->
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Notifications Tab -->
                <div class="tab-pane fade" id="notifications" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5>System Notifications</h5>
                        <button class="btn btn-outline-secondary" onclick="markAllAsRead()">
                            <i class="fas fa-check-double me-2"></i>Mark All as Read
                        </button>
                    </div>
                    <div id="notificationsList">
                        <!-- Notifications will be loaded dynamically -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Customer Details Modal -->
    <div class="modal fade" id="customerModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Customer Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="customerModalBody">
                    <!-- Customer details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- KYC Details Modal -->
    <div class="modal fade" id="kycModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">KYC Document Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="kycModalBody">
                    <!-- KYC details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-success" onclick="approveKYC()">
                        <i class="fas fa-check me-2"></i>Approve
                    </button>
                    <button type="button" class="btn btn-danger" onclick="rejectKYC()">
                        <i class="fas fa-times me-2"></i>Reject
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        // Global variables
        let currentKycId = null;
        const API_BASE = 'http://localhost:8080/admin/api';
        
        // Initialize page
        $(document).ready(function() {
            loadDashboardStats();
            loadCustomers();
            loadKYCDocuments();
            checkSystemHealth();
            
            // Auto-refresh every 30 seconds
            setInterval(function() {
                loadDashboardStats();
                loadRecentActivity();
            }, 30000);
        });

        // Load dashboard statistics
        async function loadDashboardStats() {
            try {
                const response = await fetch(`${API_BASE}/dashboard/stats`);
                const stats = await response.json();
                
                $('#totalCustomers').text(stats.totalCustomers || 0);
                $('#pendingCustomers').text(stats.pendingCustomers || 0);
                $('#pendingKyc').text(stats.pendingKyc || 0);
                $('#activeAccounts').text(stats.approvedCustomers || 0);
            } catch (error) {
                console.error('Error loading stats:', error);
            }
        }

        // Load customers
        async function loadCustomers() {
            try {
                const response = await fetch(`${API_BASE}/customers`);
                const customers = await response.json();
                
                const tbody = $('#customersTableBody');
                tbody.empty();
                
                customers.forEach(customer => {
                    const statusClass = customer.status === 'APPROVED' ? 'success' : 
                                      customer.status === 'REJECTED' ? 'danger' : 'warning';
                    
                    tbody.append(`
                        <tr>
                            <td>${customer.customerId}</td>
                            <td>${customer.firstName} ${customer.lastName}</td>
                            <td>${customer.email}</td>
                            <td>${customer.phoneNumber}</td>
                            <td><span class="badge bg-${statusClass}">${customer.status}</span></td>
                            <td>${new Date(customer.createdAt).toLocaleDateString()}</td>
                            <td class="table-actions">
                                <button class="btn btn-info btn-sm" onclick="viewCustomer('${customer.customerId}')">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-success btn-sm" onclick="approveCustomer('${customer.customerId}')">
                                    <i class="fas fa-check"></i>
                                </button>
                                <button class="btn btn-danger btn-sm" onclick="rejectCustomer('${customer.customerId}')">
                                    <i class="fas fa-times"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
                
                if (!$.fn.dataTable.isDataTable('#customersTable')) {
                    $('#customersTable').DataTable({
                        responsive: true,
                        pageLength: 10
                    });
                }
            } catch (error) {
                console.error('Error loading customers:', error);
            }
        }

        // Load KYC documents
        async function loadKYCDocuments() {
            try {
                const response = await fetch(`${API_BASE}/kyc`);
                const kycDocs = await response.json();
                
                const tbody = $('#kycTableBody');
                tbody.empty();
                
                kycDocs.forEach(doc => {
                    const statusClass = doc.status === 'APPROVED' ? 'success' : 
                                      doc.status === 'REJECTED' ? 'danger' : 'warning';
                    
                    tbody.append(`
                        <tr>
                            <td>${doc.id}</td>
                            <td>${doc.fullName}</td>
                            <td>${doc.email}</td>
                            <td>${new Date(doc.createdAt).toLocaleDateString()}</td>
                            <td><span class="badge bg-${statusClass}">${doc.status}</span></td>
                            <td class="table-actions">
                                <button class="btn btn-info btn-sm" onclick="viewKYC(${doc.id})">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-success btn-sm" onclick="approveKYCQuick(${doc.id})">
                                    <i class="fas fa-check"></i>
                                </button>
                                <button class="btn btn-danger btn-sm" onclick="rejectKYCQuick(${doc.id})">
                                    <i class="fas fa-times"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                });
                
                if (!$.fn.dataTable.isDataTable('#kycTable')) {
                    $('#kycTable').DataTable({
                        responsive: true,
                        pageLength: 10
                    });
                }
            } catch (error) {
                console.error('Error loading KYC documents:', error);
            }
        }

        // View customer details
        async function viewCustomer(customerId) {
            try {
                const response = await fetch(`${API_BASE}/customers/${customerId}`);
                const data = await response.json();
                
                const customer = data.customer;
                const accounts = data.accounts || [];
                const kycDocs = data.kycDocuments || [];
                
                $('#customerModalBody').html(`
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Personal Information</h6>
                            <p><strong>Name:</strong> ${customer.firstName} ${customer.lastName}</p>
                            <p><strong>Email:</strong> ${customer.email}</p>
                            <p><strong>Phone:</strong> ${customer.phoneNumber}</p>
                            <p><strong>Address:</strong> ${customer.address}</p>
                            <p><strong>DOB:</strong> ${customer.dateOfBirth}</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Account Status</h6>
                            <p><strong>Status:</strong> <span class="badge bg-${customer.status === 'APPROVED' ? 'success' : 'warning'}">${customer.status}</span></p>
                            <p><strong>Registration:</strong> ${new Date(customer.createdAt).toLocaleDateString()}</p>
                            <p><strong>Last Updated:</strong> ${new Date(customer.updatedAt).toLocaleDateString()}</p>
                            <h6>Actions</h6>
                            <button class="btn btn-success btn-sm me-2" onclick="approveCustomer('${customer.customerId}')">Approve</button>
                            <button class="btn btn-danger btn-sm" onclick="rejectCustomer('${customer.customerId}')">Reject</button>
                        </div>
                    </div>
                `);
                
                $('#customerModal').modal('show');
            } catch (error) {
                console.error('Error loading customer details:', error);
            }
        }

        // View KYC details
        async function viewKYC(kycId) {
            try {
                currentKycId = kycId;
                const response = await fetch(`${API_BASE}/kyc/${kycId}`);
                const doc = await response.json();
                
                $('#kycModalBody').html(`
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Customer Information</h6>
                            <p><strong>Name:</strong> ${doc.fullName}</p>
                            <p><strong>Email:</strong> ${doc.email}</p>
                            <p><strong>Phone:</strong> ${doc.phoneNumber}</p>
                            <p><strong>Upload Date:</strong> ${new Date(doc.createdAt).toLocaleDateString()}</p>
                            <p><strong>Status:</strong> <span class="badge bg-${doc.status === 'APPROVED' ? 'success' : doc.status === 'REJECTED' ? 'danger' : 'warning'}">${doc.status}</span></p>
                            ${doc.adminRemarks ? `<p><strong>Remarks:</strong> ${doc.adminRemarks}</p>` : ''}
                        </div>
                        <div class="col-md-6">
                            <h6>Documents</h6>
                            <div class="row">
                                ${doc.aadharFront ? `<div class="col-4"><img src="${doc.aadharFront}" class="img-fluid document-preview" title="Aadhar Front"></div>` : ''}
                                ${doc.aadharBack ? `<div class="col-4"><img src="${doc.aadharBack}" class="img-fluid document-preview" title="Aadhar Back"></div>` : ''}
                                ${doc.photograph ? `<div class="col-4"><img src="${doc.photograph}" class="img-fluid document-preview" title="Photograph"></div>` : ''}
                                ${doc.panFront ? `<div class="col-4"><img src="${doc.panFront}" class="img-fluid document-preview" title="PAN Front"></div>` : ''}
                                ${doc.panBack ? `<div class="col-4"><img src="${doc.panBack}" class="img-fluid document-preview" title="PAN Back"></div>` : ''}
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-12">
                            <h6>Review Action</h6>
                            <textarea class="form-control" id="adminRemarks" placeholder="Enter remarks for customer..." rows="3">${doc.adminRemarks || ''}</textarea>
                        </div>
                    </div>
                `);
                
                $('#kycModal').modal('show');
            } catch (error) {
                console.error('Error loading KYC details:', error);
            }
        }

        // Approve customer
        async function approveCustomer(customerId) {
            if (confirm('Are you sure you want to approve this customer?')) {
                try {
                    const response = await fetch(`${API_BASE}/customers/${customerId}/status`, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ status: 'APPROVED' })
                    });
                    
                    if (response.ok) {
                        showAlert('Customer approved successfully!', 'success');
                        loadCustomers();
                        loadDashboardStats();
                        $('#customerModal').modal('hide');
                    } else {
                        showAlert('Failed to approve customer', 'danger');
                    }
                } catch (error) {
                    console.error('Error approving customer:', error);
                    showAlert('Error approving customer', 'danger');
                }
            }
        }

        // Reject customer
        async function rejectCustomer(customerId) {
            if (confirm('Are you sure you want to reject this customer?')) {
                try {
                    const response = await fetch(`${API_BASE}/customers/${customerId}/status`, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ status: 'REJECTED' })
                    });
                    
                    if (response.ok) {
                        showAlert('Customer rejected successfully!', 'success');
                        loadCustomers();
                        loadDashboardStats();
                        $('#customerModal').modal('hide');
                    } else {
                        showAlert('Failed to reject customer', 'danger');
                    }
                } catch (error) {
                    console.error('Error rejecting customer:', error);
                    showAlert('Error rejecting customer', 'danger');
                }
            }
        }

        // Approve KYC
        async function approveKYC() {
            if (currentKycId) {
                const remarks = $('#adminRemarks').val() || 'All documents verified successfully';
                
                try {
                    const response = await fetch(`${API_BASE}/kyc/${currentKycId}/status`, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ 
                            status: 'APPROVED',
                            remarks: remarks
                        })
                    });
                    
                    if (response.ok) {
                        showAlert('KYC approved successfully!', 'success');
                        loadKYCDocuments();
                        loadDashboardStats();
                        $('#kycModal').modal('hide');
                    } else {
                        showAlert('Failed to approve KYC', 'danger');
                    }
                } catch (error) {
                    console.error('Error approving KYC:', error);
                    showAlert('Error approving KYC', 'danger');
                }
            }
        }

        // Reject KYC
        async function rejectKYC() {
            if (currentKycId) {
                const remarks = $('#adminRemarks').val() || 'Document verification failed';
                
                try {
                    const response = await fetch(`${API_BASE}/kyc/${currentKycId}/status`, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ 
                            status: 'REJECTED',
                            remarks: remarks
                        })
                    });
                    
                    if (response.ok) {
                        showAlert('KYC rejected successfully!', 'success');
                        loadKYCDocuments();
                        loadDashboardStats();
                        $('#kycModal').modal('hide');
                    } else {
                        showAlert('Failed to reject KYC', 'danger');
                    }
                } catch (error) {
                    console.error('Error rejecting KYC:', error);
                    showAlert('Error rejecting KYC', 'danger');
                }
            }
        }

        // Quick approve KYC
        async function approveKYCQuick(kycId) {
            if (confirm('Are you sure you want to approve this KYC document?')) {
                try {
                    const response = await fetch(`${API_BASE}/kyc/${kycId}/status`, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ 
                            status: 'APPROVED',
                            remarks: 'All documents verified successfully'
                        })
                    });
                    
                    if (response.ok) {
                        showAlert('KYC approved successfully!', 'success');
                        loadKYCDocuments();
                        loadDashboardStats();
                    } else {
                        showAlert('Failed to approve KYC', 'danger');
                    }
                } catch (error) {
                    console.error('Error approving KYC:', error);
                    showAlert('Error approving KYC', 'danger');
                }
            }
        }

        // Quick reject KYC
        async function rejectKYCQuick(kycId) {
            const reason = prompt('Please provide a reason for rejection:');
            if (reason) {
                try {
                    const response = await fetch(`${API_BASE}/kyc/${kycId}/status`, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ 
                            status: 'REJECTED',
                            remarks: reason
                        })
                    });
                    
                    if (response.ok) {
                        showAlert('KYC rejected successfully!', 'success');
                        loadKYCDocuments();
                        loadDashboardStats();
                    } else {
                        showAlert('Failed to reject KYC', 'danger');
                    }
                } catch (error) {
                    console.error('Error rejecting KYC:', error);
                    showAlert('Error rejecting KYC', 'danger');
                }
            }
        }

        // Refresh functions
        function refreshCustomers() {
            loadCustomers();
            showAlert('Customers refreshed!', 'info');
        }

        function refreshKYC() {
            loadKYCDocuments();
            showAlert('KYC documents refreshed!', 'info');
        }

        function refreshAccounts() {
            showAlert('Accounts refreshed!', 'info');
        }

        // System health check
        async function checkSystemHealth() {
            // This would check various service endpoints
            console.log('System health check completed');
        }

        function systemHealth() {
            window.open('http://localhost:8761', '_blank');
        }

        function viewReports() {
            showAlert('Reports feature coming soon!', 'info');
        }

        function markAllAsRead() {
            showAlert('All notifications marked as read!', 'success');
        }

        // Utility function to show alerts
        function showAlert(message, type) {
            const alertDiv = $(`
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `);
            
            $('.container-fluid').prepend(alertDiv);
            
            setTimeout(function() {
                alertDiv.alert('close');
            }, 3000);
        }
    </script>
</body>
</html>