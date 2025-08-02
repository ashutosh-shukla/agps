<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KYC Document View - ${document.fullName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .document-image {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: transform 0.2s;
        }
        .document-image:hover {
            transform: scale(1.02);
        }
        .document-container {
            margin-bottom: 30px;
        }
        .document-title {
            background: #f8f9fa;
            padding: 10px 15px;
            border-left: 4px solid #007bff;
            margin-bottom: 15px;
        }
        .info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .status-badge {
            font-size: 1em;
            padding: 8px 16px;
        }
        .modal-img {
            max-width: 100%;
            max-height: 80vh;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid mt-4">
        <!-- Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2><i class="fas fa-file-alt me-2"></i>KYC Document Details</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/kyc/admin">Admin Panel</a></li>
                                <li class="breadcrumb-item active">Document #${document.id}</li>
                            </ol>
                        </nav>
                    </div>
                    <div>
                        <a href="/kyc/admin" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Admin Panel
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Personal Information Card -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card info-card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <h6><i class="fas fa-user me-2"></i>Full Name</h6>
                                <p class="mb-0">${document.fullName}</p>
                            </div>
                            <div class="col-md-3">
                                <h6><i class="fas fa-envelope me-2"></i>Email</h6>
                                <p class="mb-0">${document.email}</p>
                            </div>
                            <div class="col-md-2">
                                <h6><i class="fas fa-phone me-2"></i>Phone</h6>
                                <p class="mb-0">${document.phoneNumber}</p>
                            </div>
                            <div class="col-md-2">
                                <h6><i class="fas fa-calendar me-2"></i>Submitted</h6>
                                <p class="mb-0">
                                    <fmt:formatDate value="${document.createdAt}" pattern="dd/MM/yyyy"/>
                                </p>
                            </div>
                            <div class="col-md-2">
                                <h6><i class="fas fa-info-circle me-2"></i>Status</h6>
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
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Status Update Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h6 class="card-title"><i class="fas fa-edit me-2"></i>Update Status</h6>
                        <div class="btn-group" role="group">
                            <form action="/kyc/admin/update-status/${document.id}" method="post" style="display: inline;">
                                <input type="hidden" name="status" value="APPROVED">
                                <button type="submit" class="btn btn-success me-2">
                                    <i class="fas fa-check me-2"></i>Approve
                                </button>
                            </form>
                            <form action="/kyc/admin/update-status/${document.id}" method="post" style="display: inline;">
                                <input type="hidden" name="status" value="REJECTED">
                                <button type="submit" class="btn btn-danger me-2">
                                    <i class="fas fa-times me-2"></i>Reject
                                </button>
                            </form>
                            <form action="/kyc/admin/update-status/${document.id}" method="post" style="display: inline;">
                                <input type="hidden" name="status" value="PENDING">
                                <button type="submit" class="btn btn-warning">
                                    <i class="fas fa-clock me-2"></i>Mark as Pending
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Documents Display -->
        <div class="row">
            <!-- Aadhar Front -->
            <c:if test="${not empty document.aadharFront}">
                <div class="col-md-6 document-container">
                    <div class="card">
                        <div class="document-title">
                            <h5 class="mb-0"><i class="fas fa-id-card me-2"></i>Aadhar Card - Front Side</h5>
                        </div>
                        <div class="card-body text-center">
                            <img src="${document.aadharFront}" 
                                 class="document-image" 
                                 alt="Aadhar Front"
                                 data-bs-toggle="modal" 
                                 data-bs-target="#imageModal"
                                 onclick="showImage('${document.aadharFront}', 'Aadhar Card - Front Side')">
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Aadhar Back -->
            <c:if test="${not empty document.aadharBack}">
                <div class="col-md-6 document-container">
                    <div class="card">
                        <div class="document-title">
                            <h5 class="mb-0"><i class="fas fa-id-card me-2"></i>Aadhar Card - Back Side</h5>
                        </div>
                        <div class="card-body text-center">
                            <img src="${document.aadharBack}" 
                                 class="document-image" 
                                 alt="Aadhar Back"
                                 data-bs-toggle="modal" 
                                 data-bs-target="#imageModal"
                                 onclick="showImage('${document.aadharBack}', 'Aadhar Card - Back Side')">
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- PAN Front -->
            <c:if test="${not empty document.panFront}">
                <div class="col-md-6 document-container">
                    <div class="card">
                        <div class="document-title">
                            <h5 class="mb-0"><i class="fas fa-credit-card me-2"></i>PAN Card - Front Side</h5>
                        </div>
                        <div class="card-body text-center">
                            <img src="${document.panFront}" 
                                 class="document-image" 
                                 alt="PAN Front"
                                 data-bs-toggle="modal" 
                                 data-bs-target="#imageModal"
                                 onclick="showImage('${document.panFront}', 'PAN Card - Front Side')">
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- PAN Back -->
            <c:if test="${not empty document.panBack}">
                <div class="col-md-6 document-container">
                    <div class="card">
                        <div class="document-title">
                            <h5 class="mb-0"><i class="fas fa-credit-card me-2"></i>PAN Card - Back Side</h5>
                        </div>
                        <div class="card-body text-center">
                            <img src="${document.panBack}" 
                                 class="document-image" 
                                 alt="PAN Back"
                                 data-bs-toggle="modal" 
                                 data-bs-target="#imageModal"
                                 onclick="showImage('${document.panBack}', 'PAN Card - Back Side')">
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Photograph -->
            <c:if test="${not empty document.photograph}">
                <div class="col-md-6 document-container">
                    <div class="card">
                        <div class="document-title">
                            <h5 class="mb-0"><i class="fas fa-camera me-2"></i>Photograph</h5>
                        </div>
                        <div class="card-body text-center">
                            <img src="${document.photograph}" 
                                 class="document-image" 
                                 alt="Photograph"
                                 data-bs-toggle="modal" 
                                 data-bs-target="#imageModal"
                                 onclick="showImage('${document.photograph}', 'Photograph')">
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Image Modal -->
    <div class="modal fade" id="imageModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="imageModalTitle">Document Image</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImage" src="/placeholder.svg" class="modal-img" alt="Document">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showImage(imageSrc, title) {
            document.getElementById('modalImage').src = imageSrc;
            document.getElementById('imageModalTitle').textContent = title;
        }
    </script>
</body>
</html>
