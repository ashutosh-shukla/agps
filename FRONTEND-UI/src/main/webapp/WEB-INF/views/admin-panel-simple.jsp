<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KYC Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.8em;
        }
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 0;
        }
        .stats-card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-2px);
        }
        .stats-card.pending {
            border-left-color: #ffc107;
        }
        .stats-card.approved {
            border-left-color: #28a745;
        }
        .stats-card.rejected {
            border-left-color: #dc3545;
        }
        .action-buttons .btn {
            margin: 2px;
        }
    </style>
</head>
<body class="bg-light">
    <div class="admin-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1><i class="fas fa-user-shield me-2"></i>KYC Admin Panel</h1>
                    <p class="mb-0">Manage and review KYC documents</p>
                </div>
                <div class="col-md-6 text-end">
                    <a href="/kyc/upload" class="btn btn-light">
                        <i class="fas fa-plus me-2"></i>New KYC Upload
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

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card pending">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title text-muted">Pending</h6>
                                <h3 class="mb-0" id="pendingCount">0</h3>
                            </div>
                            <div class="text-warning">
                                <i class="fas fa-clock fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card approved">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title text-muted">Approved</h6>
                                <h3 class="mb-0" id="approvedCount">0</h3>
                            </div>
                            <div class="text-success">
                                <i class="fas fa-check-circle fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card rejected">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title text-muted">Rejected</h6>
                                <h3 class="mb-0" id="rejectedCount">0</h3>
                            </div>
                            <div class="text-danger">
                                <i class="fas fa-times-circle fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title text-muted">Total</h6>
                                <h3 class="mb-0">${documents.size()}</h3>
                            </div>
                            <div class="text-info">
                                <i class="fas fa-file-alt fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Documents Table -->
        <div class="card shadow">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-table me-2"></i>KYC Documents</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Status</th>
                                <th>Submitted</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="document" items="${documents}">
                                <tr>
                                    <td>${document.id}</td>
                                    <td>${document.fullName}</td>
                                    <td>${document.email}</td>
                                    <td>${document.phoneNumber}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${document.status == 'PENDING'}">
                                                <span class="badge bg-warning status-badge">PENDING</span>
                                            </c:when>
                                            <c:when test="${document.status == 'APPROVED'}">
                                                <span class="badge bg-success status-badge">APPROVED</span>
                                            </c:when>
                                            <c:when test="${document.status == 'REJECTED'}">
                                                <span class="badge bg-danger status-badge">REJECTED</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary status-badge">${document.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty document.createdAt}">
                                                ${document.createdAt}
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="action-buttons">
                                        <a href="/kyc/admin/view/${document.id}" class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                        <div class="btn-group" role="group">
                                            <button type="button" class="btn btn-secondary btn-sm dropdown-toggle" 
                                                    data-bs-toggle="dropdown">
                                                <i class="fas fa-edit"></i> Status
                                            </button>
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <form action="/kyc/admin/update-status/${document.id}" method="post" style="display: inline;">
                                                        <input type="hidden" name="status" value="APPROVED">
                                                        <button type="submit" class="dropdown-item text-success">
                                                            <i class="fas fa-check me-2"></i>Approve
                                                        </button>
                                                    </form>
                                                </li>
                                                <li>
                                                    <form action="/kyc/admin/update-status/${document.id}" method="post" style="display: inline;">
                                                        <input type="hidden" name="status" value="REJECTED">
                                                        <button type="submit" class="dropdown-item text-danger">
                                                            <i class="fas fa-times me-2"></i>Reject
                                                        </button>
                                                    </form>
                                                </li>
                                                <li>
                                                    <form action="/kyc/admin/update-status/${document.id}" method="post" style="display: inline;">
                                                        <input type="hidden" name="status" value="PENDING">
                                                        <button type="submit" class="dropdown-item text-warning">
                                                            <i class="fas fa-clock me-2"></i>Pending
                                                        </button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>
                                        <form action="/kyc/admin/delete/${document.id}" method="post" 
                                              style="display: inline;" 
                                              onsubmit="return confirm('Are you sure you want to delete this document?')">
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Calculate and display statistics
        function updateStatistics() {
            let pendingCount = 0;
            let approvedCount = 0;
            let rejectedCount = 0;
            
            // Count status badges
            const badges = document.querySelectorAll('.status-badge');
            badges.forEach(function(badge) {
                const status = badge.textContent.trim();
                switch(status) {
                    case 'PENDING':
                        pendingCount++;
                        break;
                    case 'APPROVED':
                        approvedCount++;
                        break;
                    case 'REJECTED':
                        rejectedCount++;
                        break;
                }
            });
            
            // Update counters
            document.getElementById('pendingCount').textContent = pendingCount;
            document.getElementById('approvedCount').textContent = approvedCount;
            document.getElementById('rejectedCount').textContent = rejectedCount;
        }
        
        // Update statistics when page loads
        document.addEventListener('DOMContentLoaded', function() {
            updateStatistics();
        });
    </script>
</body>
</html>
