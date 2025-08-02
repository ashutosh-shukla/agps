<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .dashboard-card { margin-bottom: 20px; }
        .action-btn { margin: 5px; }
        .status-badge { font-size: 0.9em; }
    </style>
</head>
<body>
<div class="container mt-4">
    <div class="row">
        <div class="col-md-12">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-user-circle"></i> Welcome, ${customer.firstName} ${customer.lastName}</h2>
                <a href="/customer/editProfile/${customer.customerId}" class="btn btn-outline-secondary">
                    <i class="fas fa-edit"></i> Edit Profile
                </a>
            </div>
            
            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle"></i> ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <!-- Customer Status Card -->
            <div class="card dashboard-card">
                <div class="card-header bg-primary text-white">
                    <h5><i class="fas fa-info-circle"></i> Account Status</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Customer ID:</strong> ${customer.customerId}</p>
                            <p><strong>Email:</strong> ${customer.email}</p>
                            <p><strong>Phone:</strong> ${customer.phoneNumber}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Status:</strong> 
                                <span class="badge ${customer.status == 'APPROVED' ? 'bg-success' : 'bg-warning'} status-badge">
                                    ${customer.status}
                                </span>
                            </p>
                            <c:if test="${not empty statusMessage}">
                                <p><strong>Message:</strong> <span class="text-info">${statusMessage}</span></p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Account Information -->
            <c:choose>
                <c:when test="${hasAccount == true and canPerformTransactions == true}">
                    <!-- Active Account Card -->
                    <div class="card dashboard-card">
                        <div class="card-header bg-success text-white">
                            <h5><i class="fas fa-university"></i> Account Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Account Number:</strong> ${account.accountNumber}</p>
                                    <p><strong>Account Type:</strong> ${account.accountType}</p>
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
                    
                    <!-- Transaction Actions -->
                    <div class="card dashboard-card">
                        <div class="card-header bg-info text-white">
                            <h5><i class="fas fa-exchange-alt"></i> Banking Services</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/customers/depositPage/${customer.customerId}" 
                                       class="btn btn-success w-100 action-btn">
                                        <i class="fas fa-plus-circle"></i><br>Deposit Money
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/customers/withdrawlPage/${customer.customerId}" 
                                       class="btn btn-warning w-100 action-btn">
                                        <i class="fas fa-minus-circle"></i><br>Withdraw Money
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/customers/transferPage/${customer.customerId}" 
                                       class="btn btn-primary w-100 action-btn">
                                        <i class="fas fa-paper-plane"></i><br>Transfer Money
                                    </a>
                                </div>
                                <div class="col-md-3">
                                    <a href="${pageContext.request.contextPath}/customers/transactionHistory/${customer.customerId}" 
                                       class="btn btn-info w-100 action-btn">
                                        <i class="fas fa-history"></i><br>Transaction History
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                
                <c:otherwise>
                    <!-- No Account / Pending Status -->
                    <div class="card dashboard-card">
                        <div class="card-header bg-warning text-dark">
                            <h5><i class="fas fa-exclamation-triangle"></i> Account Setup Required</h5>
                        </div>
                        <div class="card-body text-center">
                            <c:choose>
                                <c:when test="${needsKyc == true}">
                                    <div class="alert alert-warning">
                                        <h6><i class="fas fa-file-upload"></i> KYC Verification Required</h6>
                                        <p>Complete your KYC verification to create your bank account and access banking services.</p>
                                        <a href="${pageContext.request.contextPath}/kyc/form/${customer.customerId}" 
                                           class="btn btn-warning btn-lg">
                                            <i class="fas fa-upload"></i> Complete KYC Verification
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-info">
                                        <h6><i class="fas fa-clock"></i> Account Setup in Progress</h6>
                                        <p>${statusMessage}</p>
                                        <p>Your account will be activated soon. Please check back later.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <!-- Quick Links -->
            <div class="card dashboard-card">
                <div class="card-header bg-secondary text-white">
                    <h5><i class="fas fa-link"></i> Quick Links</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <a href="/customer/editProfile/${customer.customerId}" class="btn btn-outline-secondary w-100">
                                <i class="fas fa-user-edit"></i> Update Profile
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="/customer/changePassword/${customer.customerId}" class="btn btn-outline-secondary w-100">
                                <i class="fas fa-key"></i> Change Password
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="/logout" class="btn btn-outline-danger w-100">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>