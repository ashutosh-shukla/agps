<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard - AGPS Bank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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

        .dashboard-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 2rem 0;
        }

        .status-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
            margin-bottom: 1.5rem;
        }

        .status-pending {
            border-left: 5px solid var(--warning-color);
        }

        .status-approved {
            border-left: 5px solid var(--success-color);
        }

        .status-rejected {
            border-left: 5px solid var(--danger-color);
        }

        .step-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
        }

        .step {
            flex: 1;
            text-align: center;
            position: relative;
        }

        .step::after {
            content: '';
            position: absolute;
            top: 20px;
            left: 50%;
            width: 100%;
            height: 2px;
            background: var(--border-color);
            z-index: 1;
        }

        .step:last-child::after {
            display: none;
        }

        .step-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--border-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            position: relative;
            z-index: 2;
            font-weight: bold;
        }

        .step-active .step-circle {
            background: var(--accent-color);
        }

        .step-completed .step-circle {
            background: var(--success-color);
        }

        .action-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border-color);
            margin-bottom: 1rem;
        }

        .btn-primary {
            background: var(--primary-color);
            border-color: var(--primary-color);
            padding: 0.75rem 1.5rem;
            font-weight: 500;
        }

        .btn-success {
            background: var(--success-color);
            border-color: var(--success-color);
            padding: 0.75rem 1.5rem;
            font-weight: 500;
        }

        .notification-banner {
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border: 1px solid;
        }

        .notification-info {
            background: #dbeafe;
            border-color: #93c5fd;
            color: #1e40af;
        }

        .notification-success {
            background: #d1fae5;
            border-color: #6ee7b7;
            color: #065f46;
        }

        .notification-warning {
            background: #fef3c7;
            border-color: #fcd34d;
            color: #92400e;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }

        .quick-action-btn {
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            text-decoration: none;
            color: var(--text-dark);
            transition: all 0.3s ease;
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

        .nav-brand {
            color: white !important;
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="dashboard-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <a href="/home" class="nav-brand">
                        <i class="fas fa-university me-2"></i>AGPS Bank
                    </a>
                </div>
                <div class="col-md-6 text-end">
                    <span class="me-3">Welcome, ${customer.firstName} ${customer.lastName}</span>
                    <a href="/auth/logout" class="logout-btn">
                        <i class="fas fa-sign-out-alt me-1"></i>Logout
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <!-- Alert Messages -->
        <c:if test="${not empty success}">
            <div class="notification-banner notification-success">
                <i class="fas fa-check-circle me-2"></i>${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="notification-banner notification-warning">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
            </div>
        </c:if>

        <!-- Account Status Overview -->
        <div class="card status-card ${customer.status == 'APPROVED' ? 'status-approved' : customer.status == 'REJECTED' ? 'status-rejected' : 'status-pending'}">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-8">
                        <h4 class="card-title">
                            <i class="fas fa-user-circle me-2"></i>Account Status
                        </h4>
                        <p class="mb-2"><strong>Customer ID:</strong> ${customer.customerId}</p>
                        <p class="mb-2"><strong>Email:</strong> ${customer.email}</p>
                        <p class="mb-2"><strong>Phone:</strong> ${customer.phoneNumber}</p>
                        <p class="mb-0">
                            <strong>Current Status:</strong> 
                            <span class="badge ${customer.status == 'APPROVED' ? 'bg-success' : customer.status == 'REJECTED' ? 'bg-danger' : 'bg-warning'} fs-6">
                                ${customer.status}
                            </span>
                        </p>
                    </div>
                    <div class="col-md-4 text-end">
                        <c:choose>
                            <c:when test="${customer.status == 'PENDING'}">
                                <i class="fas fa-hourglass-half text-warning" style="font-size: 3rem;"></i>
                            </c:when>
                            <c:when test="${customer.status == 'APPROVED'}">
                                <i class="fas fa-check-circle text-success" style="font-size: 3rem;"></i>
                            </c:when>
                            <c:when test="${customer.status == 'REJECTED'}">
                                <i class="fas fa-times-circle text-danger" style="font-size: 3rem;"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-info-circle text-info" style="font-size: 3rem;"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Account Setup Progress -->
        <div class="card status-card">
            <div class="card-header bg-light">
                <h5 class="mb-0"><i class="fas fa-list-check me-2"></i>Account Setup Progress</h5>
            </div>
            <div class="card-body">
                <div class="step-indicator">
                    <div class="step step-completed">
                        <div class="step-circle">
                            <i class="fas fa-check"></i>
                        </div>
                        <div class="mt-2">
                            <small class="text-muted">Registration</small>
                        </div>
                    </div>
                    <div class="step ${kycStatus == 'COMPLETED' ? 'step-completed' : kycStatus == 'PENDING' ? 'step-active' : ''}">
                        <div class="step-circle">
                            <c:choose>
                                <c:when test="${kycStatus == 'COMPLETED'}">
                                    <i class="fas fa-check"></i>
                                </c:when>
                                <c:otherwise>
                                    2
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mt-2">
                            <small class="text-muted">KYC Documents</small>
                        </div>
                    </div>
                    <div class="step ${customer.status == 'APPROVED' ? 'step-completed' : customer.status == 'PENDING' ? 'step-active' : ''}">
                        <div class="step-circle">
                            <c:choose>
                                <c:when test="${customer.status == 'APPROVED'}">
                                    <i class="fas fa-check"></i>
                                </c:when>
                                <c:otherwise>
                                    3
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mt-2">
                            <small class="text-muted">Admin Approval</small>
                        </div>
                    </div>
                    <div class="step ${hasAccount == true ? 'step-completed' : customer.status == 'APPROVED' ? 'step-active' : ''}">
                        <div class="step-circle">
                            <c:choose>
                                <c:when test="${hasAccount == true}">
                                    <i class="fas fa-check"></i>
                                </c:when>
                                <c:otherwise>
                                    4
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mt-2">
                            <small class="text-muted">Account Active</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Current Action Required -->
        <c:choose>
            <c:when test="${customer.status == 'PENDING' && (kycStatus == null || kycStatus == 'NOT_STARTED')}">
                <!-- KYC Upload Required -->
                <div class="action-card">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5><i class="fas fa-upload me-2 text-warning"></i>Complete Your KYC</h5>
                            <p class="mb-0">Please upload your KYC documents to proceed with account activation. You'll need:</p>
                            <ul class="mt-2 mb-0">
                                <li>Aadhar Card (Front & Back)</li>
                                <li>PAN Card (Front & Back) - Optional</li>
                                <li>Recent Photograph</li>
                            </ul>
                        </div>
                        <div class="col-md-4 text-end">
                            <a href="/kyc/upload" class="btn btn-primary btn-lg">
                                <i class="fas fa-upload me-2"></i>Complete KYC
                            </a>
                        </div>
                    </div>
                </div>
            </c:when>
            
            <c:when test="${customer.status == 'PENDING' && kycStatus == 'PENDING'}">
                <!-- Waiting for Admin Approval -->
                <div class="notification-banner notification-info">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5><i class="fas fa-clock me-2"></i>Pending Admin Approval</h5>
                            <p class="mb-0">Your KYC documents have been submitted successfully. Our team is reviewing your documents. You will be notified once the review is complete.</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            
            <c:when test="${customer.status == 'APPROVED'}">
                <!-- Account Approved -->
                <div class="notification-banner notification-success">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5><i class="fas fa-check-circle me-2"></i>Account Approved!</h5>
                            <p class="mb-0">Congratulations! Your account has been approved and is now active. You can now access all banking services.</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <c:if test="${hasAccount == true}">
                                <a href="/account/dashboard" class="btn btn-success btn-lg">
                                    <i class="fas fa-university me-2"></i>Access Banking
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:when>
            
            <c:when test="${customer.status == 'REJECTED'}">
                <!-- Account Rejected -->
                <div class="notification-banner notification-warning">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5><i class="fas fa-exclamation-triangle me-2"></i>Account Verification Issues</h5>
                            <p class="mb-0">There were issues with your account verification. Please contact our support team for assistance or resubmit your documents.</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <a href="/kyc/upload" class="btn btn-warning me-2">
                                <i class="fas fa-redo me-1"></i>Resubmit KYC
                            </a>
                            <a href="/support" class="btn btn-outline-primary">
                                <i class="fas fa-headset me-1"></i>Contact Support
                            </a>
                        </div>
                    </div>
                </div>
            </c:when>
        </c:choose>

        <!-- Account Information (if approved and has account) -->
        <c:if test="${hasAccount == true && customer.status == 'APPROVED'}">
            <div class="card status-card status-approved">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-university me-2"></i>Account Information</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Account Number:</strong> ${account.accountNumber}</p>
                            <p><strong>Account Type:</strong> ${account.accountType}</p>
                            <p><strong>IFSC Code:</strong> AGPS0001234</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Current Balance:</strong> 
                                <span class="text-success fs-4">₹${account.balance}</span>
                            </p>
                            <p><strong>Account Status:</strong> 
                                <span class="badge bg-success">ACTIVE</span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions for Active Accounts -->
            <div class="quick-actions">
                <a href="/account/deposit" class="quick-action-btn">
                    <i class="fas fa-plus-circle text-success"></i>
                    <strong>Deposit Money</strong>
                </a>
                <a href="/account/withdraw" class="quick-action-btn">
                    <i class="fas fa-minus-circle text-warning"></i>
                    <strong>Withdraw Money</strong>
                </a>
                <a href="/account/transfer" class="quick-action-btn">
                    <i class="fas fa-exchange-alt text-primary"></i>
                    <strong>Transfer Funds</strong>
                </a>
                <a href="/account/transactions" class="quick-action-btn">
                    <i class="fas fa-history text-info"></i>
                    <strong>Transaction History</strong>
                </a>
                <a href="/customer/editProfile/${customer.customerId}" class="quick-action-btn">
                    <i class="fas fa-user-edit text-secondary"></i>
                    <strong>Edit Profile</strong>
                </a>
                <a href="/account/statement" class="quick-action-btn">
                    <i class="fas fa-file-alt text-dark"></i>
                    <strong>Account Statement</strong>
                </a>
            </div>
        </c:if>

        <!-- General Quick Actions for All Users -->
        <c:if test="${hasAccount != true || customer.status != 'APPROVED'}">
            <div class="quick-actions">
                <a href="/customer/editProfile/${customer.customerId}" class="quick-action-btn">
                    <i class="fas fa-user-edit text-secondary"></i>
                    <strong>Edit Profile</strong>
                </a>
                <a href="/support" class="quick-action-btn">
                    <i class="fas fa-headset text-info"></i>
                    <strong>Contact Support</strong>
                </a>
                <a href="/kyc/status" class="quick-action-btn">
                    <i class="fas fa-file-check text-primary"></i>
                    <strong>Check KYC Status</strong>
                </a>
                <a href="/faq" class="quick-action-btn">
                    <i class="fas fa-question-circle text-warning"></i>
                    <strong>FAQ</strong>
                </a>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-refresh page for pending status (every 30 seconds)
        <c:if test="${customer.status == 'PENDING'}">
            setTimeout(function() {
                location.reload();
            }, 30000);
        </c:if>

        // Show notification if user just completed KYC
        <c:if test="${param.kycCompleted == 'true'}">
            // Add a special notification
            const notification = document.createElement('div');
            notification.className = 'notification-banner notification-success';
            notification.innerHTML = '<i class="fas fa-check-circle me-2"></i>KYC documents uploaded successfully! Please wait for admin approval.';
            document.querySelector('.container').insertBefore(notification, document.querySelector('.card'));
        </c:if>
    </script>
</body>
</html>