<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KYC Document Upload</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .upload-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .file-upload-wrapper {
            position: relative;
            margin: 10px 0;
        }
        .file-upload-input {
            display: none;
        }
        .file-upload-label {
            display: block;
            padding: 20px;
            border: 2px dashed #ddd;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .file-upload-label:hover {
            border-color: #007bff;
            background-color: #f8f9fa;
        }
        .file-upload-label.has-file {
            border-color: #28a745;
            background-color: #d4edda;
        }
        .preview-container {
            margin-top: 10px;
            text-align: center;
        }
        .preview-image {
            max-width: 200px;
            max-height: 150px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .required-field {
            color: red;
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="upload-container">
            <div class="card shadow">
                <div class="card-header">
                    <h2 class="mb-0"><i class="fas fa-id-card me-2"></i>KYC Document Upload</h2>
                </div>
                <div class="card-body">
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

                    <form action="http://localhost:8080/kyc/upload" method="post" enctype="multipart/form-data" id="kycForm">
                        <!-- Personal Information -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <h5 class="text-primary"><i class="fas fa-user me-2"></i>Personal Information</h5>
                                <hr>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="fullName" class="form-label">Full Name <span class="required-field">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="email" class="form-label">Email <span class="required-field">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="phoneNumber" class="form-label">Phone Number <span class="required-field">*</span></label>
                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" required>
                            </div>
                        </div>

                        <!-- Document Uploads -->
                        <div class="row">
                            <div class="col-12">
                                <h5 class="text-primary"><i class="fas fa-file-upload me-2"></i>Document Upload</h5>
                                <hr>
                            </div>
                            
                            <!-- Aadhar Front -->
                            <div class="col-md-6 mb-4">
                                <label class="form-label">Aadhar Card - Front Side <span class="required-field">*</span></label>
                                <div class="file-upload-wrapper">
                                    <input type="file" id="aadharFront" name="aadharFront" class="file-upload-input" accept="image/*" required>
                                    <label for="aadharFront" class="file-upload-label">
                                        <i class="fas fa-cloud-upload-alt fa-2x mb-2"></i>
                                        <div>Click to upload Aadhar Front</div>
                                        <small class="text-muted">JPG, PNG, GIF up to 10MB</small>
                                    </label>
                                    <div class="preview-container" id="aadharFrontPreview"></div>
                                </div>
                            </div>

                            <!-- Aadhar Back -->
                            <div class="col-md-6 mb-4">
                                <label class="form-label">Aadhar Card - Back Side <span class="required-field">*</span></label>
                                <div class="file-upload-wrapper">
                                    <input type="file" id="aadharBack" name="aadharBack" class="file-upload-input" accept="image/*" required>
                                    <label for="aadharBack" class="file-upload-label">
                                        <i class="fas fa-cloud-upload-alt fa-2x mb-2"></i>
                                        <div>Click to upload Aadhar Back</div>
                                        <small class="text-muted">JPG, PNG, GIF up to 10MB</small>
                                    </label>
                                    <div class="preview-container" id="aadharBackPreview"></div>
                                </div>
                            </div>

                            <!-- PAN Front -->
                            <div class="col-md-6 mb-4">
                                <label class="form-label">PAN Card - Front Side</label>
                                <div class="file-upload-wrapper">
                                    <input type="file" id="panFront" name="panFront" class="file-upload-input" accept="image/*">
                                    <label for="panFront" class="file-upload-label">
                                        <i class="fas fa-cloud-upload-alt fa-2x mb-2"></i>
                                        <div>Click to upload PAN Front</div>
                                        <small class="text-muted">JPG, PNG, GIF up to 10MB</small>
                                    </label>
                                    <div class="preview-container" id="panFrontPreview"></div>
                                </div>
                            </div>

                            <!-- PAN Back -->
                            <div class="col-md-6 mb-4">
                                <label class="form-label">PAN Card - Back Side</label>
                                <div class="file-upload-wrapper">
                                    <input type="file" id="panBack" name="panBack" class="file-upload-input" accept="image/*">
                                    <label for="panBack" class="file-upload-label">
                                        <i class="fas fa-cloud-upload-alt fa-2x mb-2"></i>
                                        <div>Click to upload PAN Back</div>
                                        <small class="text-muted">JPG, PNG, GIF up to 10MB</small>
                                    </label>
                                    <div class="preview-container" id="panBackPreview"></div>
                                </div>
                            </div>

                            <!-- Photograph -->
                            <div class="col-md-12 mb-4">
                                <label class="form-label">Photograph <span class="required-field">*</span></label>
                                <div class="file-upload-wrapper">
                                    <input type="file" id="photograph" name="photograph" class="file-upload-input" accept="image/*" required>
                                    <label for="photograph" class="file-upload-label">
                                        <i class="fas fa-camera fa-2x mb-2"></i>
                                        <div>Click to upload your Photograph</div>
                                        <small class="text-muted">JPG, PNG, GIF up to 10MB</small>
                                    </label>
                                    <div class="preview-container" id="photographPreview"></div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12 text-center">
                                <button type="submit" class="btn btn-primary btn-lg me-3">
                                    <i class="fas fa-upload me-2"></i>Submit KYC Documents
                                </button>
                                <a href="/kyc/admin" class="btn btn-secondary btn-lg">
                                    <i class="fas fa-user-shield me-2"></i>Admin Panel
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // File upload preview functionality
        function setupFilePreview(inputId, previewId) {
            const input = document.getElementById(inputId);
            const label = input.nextElementSibling;
            const preview = document.getElementById(previewId);
            
            input.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    label.classList.add('has-file');
                    
                    // Simple file size display without complex calculations
                    let sizeText = 'File selected';
                    if (file.size) {
                        const kb = Math.round(file.size / 1024);
                        if (kb > 1024) {
                            sizeText = Math.round(kb / 1024) + ' MB';
                        } else {
                            sizeText = kb + ' KB';
                        }
                    }
                    
                    label.innerHTML = '<i class="fas fa-check-circle fa-2x mb-2 text-success"></i>' +
                                    '<div>' + file.name + '</div>' +
                                    '<small class="text-muted">' + sizeText + '</small>';
                    
                    // Show preview
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        preview.innerHTML = '<img src="' + e.target.result + '" class="preview-image" alt="Preview">';
                    };
                    reader.readAsDataURL(file);
                } else {
                    label.classList.remove('has-file');
                    preview.innerHTML = '';
                }
            });
        }

        // Setup preview for all file inputs
        setupFilePreview('aadharFront', 'aadharFrontPreview');
        setupFilePreview('aadharBack', 'aadharBackPreview');
        setupFilePreview('panFront', 'panFrontPreview');
        setupFilePreview('panBack', 'panBackPreview');
        setupFilePreview('photograph', 'photographPreview');

        // Form validation
        document.getElementById('kycForm').addEventListener('submit', function(e) {
            const requiredFields = ['fullName', 'email', 'phoneNumber', 'aadharFront', 'aadharBack', 'photograph'];
            let isValid = true;
            
            requiredFields.forEach(function(fieldId) {
                const field = document.getElementById(fieldId);
                if (!field.value || field.value.trim() === '') {
                    isValid = false;
                    field.classList.add('is-invalid');
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                alert('Please fill all required fields and upload required documents.');
            }
        });
    </script>
</body>
</html>
