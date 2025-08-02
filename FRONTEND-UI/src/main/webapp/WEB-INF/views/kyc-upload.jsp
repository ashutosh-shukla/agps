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
        .is-invalid {
            border-color: #dc3545 !important;
        }
        .invalid-feedback {
            display: block;
            color: #dc3545;
            font-size: 0.875em;
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

                    <%-- Corrected form action to point to the KYCUIController's upload method --%>
                    <form action="${pageContext.request.contextPath}/kyc/upload" method="post" enctype="multipart/form-data" id="kycForm">
                        <div class="row mb-4">
                            <div class="col-12">
                                <h5 class="text-primary"><i class="fas fa-user me-2"></i>Personal Information</h5>
                                <hr>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="fullName" class="form-label">AdharCard Number<span class="required-field">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                                <div class="invalid-feedback">Please enter a Adhar-Card details.</div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="email" class="form-label">PAN Card Number <span class="required-field">*</span></label>
                                <input type="text" class="form-control" id="email" name="email" required>
                                <div class="invalid-feedback">Please enter a PAN Card details.</div>
                            </div>
                           
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <h5 class="text-primary"><i class="fas fa-file-upload me-2"></i>Document Upload</h5>
                                <hr>
                            </div>

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
                                <div class="invalid-feedback file-feedback">Please upload Aadhar Card - Front Side.</div>
                            </div>

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
                                <div class="invalid-feedback file-feedback">Please upload Aadhar Card - Back Side.</div>
                            </div>

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
                                <div class="invalid-feedback file-feedback">Please upload your Photograph.</div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12 text-center">
                                <button type="submit" class="btn btn-primary btn-lg me-3">
                                    <i class="fas fa-upload me-2"></i>Submit KYC Documents
                                </button>
                                <a href="${pageContext.request.contextPath}/kyc/admin" class="btn btn-secondary btn-lg">
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
            const feedback = label.nextElementSibling; // Get the invalid-feedback div

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

                    // Remove invalid feedback on successful file selection
                    if (feedback) {
                        feedback.style.display = 'none';
                    }
                } else {
                    label.classList.remove('has-file');
                    preview.innerHTML = '';
                    // Show invalid feedback if file is removed
                    if (input.hasAttribute('required') && feedback) {
                        feedback.style.display = 'block';
                    }
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
            const form = e.target;
            let isValid = true;

            // Validate text inputs
            const textInputs = ['fullName', 'email', 'phoneNumber'];
            textInputs.forEach(function(fieldId) {
                const field = document.getElementById(fieldId);
                if (!field.value || field.value.trim() === '') {
                    isValid = false;
                    field.classList.add('is-invalid');
                } else {
                    field.classList.remove('is-invalid');
                    // Additional validation for email and phone number format
                    if (field.id === 'email' && !field.value.match(/^[A-Za-z0-9+_.-]+@(.+)$/)) {
                        isValid = false;
                        field.classList.add('is-invalid');
                        field.nextElementSibling.textContent = 'Please enter a valid email address.';
                    } else if (field.id === 'phoneNumber' && !field.value.match(/^[0-9]{10}$/)) {
                        isValid = false;
                        field.classList.add('is-invalid');
                        field.nextElementSibling.textContent = 'Please enter a valid 10-digit phone number.';
                    }
                }
            });

            // Validate file inputs
            const fileInputs = ['aadharFront', 'aadharBack', 'photograph']; // Only required ones
            fileInputs.forEach(function(fieldId) {
                const input = document.getElementById(fieldId);
                const feedback = input.nextElementSibling.nextElementSibling; // Get the invalid-feedback div

                if (input.hasAttribute('required') && (!input.files || input.files.length === 0)) {
                    isValid = false;
                    input.nextElementSibling.classList.add('is-invalid'); // Add to label for visual cue
                    if (feedback) feedback.style.display = 'block';
                } else {
                    input.nextElementSibling.classList.remove('is-invalid');
                    if (feedback) feedback.style.display = 'none';
                }
            });

            if (!isValid) {
                e.preventDefault(); // Prevent form submission
                // Alert can be annoying, using Bootstrap's invalid-feedback is better.
                // alert('Please correct the highlighted fields and upload all required documents.');
            }
        });
    </script>
</body>
</html>