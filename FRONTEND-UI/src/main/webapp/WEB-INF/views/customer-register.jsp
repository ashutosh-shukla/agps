<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Registration - AGPS Bank</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1e3a8a;
            --secondary-color: #1e40af;
            --accent-color: #0ea5e9;
            --success-color: #059669;
            --warning-color: #d97706;
            --text-dark: #1f2937;
            --text-light: #6b7280;
            --bg-light: #f8fafc;
            --border-color: #e5e7eb;
        }

        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            background: linear-gradient(135deg, var(--bg-light) 0%, #e0e7ff 100%);
            min-height: 100vh;
        }

        .header {
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

        .container { 
            max-width: 600px; 
            margin: 2rem auto; 
            background: white; 
            padding: 2rem; 
            border-radius: 15px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.1); 
        }

        .form-group { 
            margin-bottom: 1.5rem; 
        }

        label { 
            display: block; 
            margin-bottom: 0.5rem; 
            font-weight: 600; 
            color: var(--text-dark); 
        }

        input[type="text"], input[type="email"], input[type="tel"], input[type="password"], input[type="date"], textarea { 
            width: 100%; 
            padding: 0.75rem; 
            border: 2px solid var(--border-color); 
            border-radius: 8px; 
            font-size: 1rem; 
            transition: all 0.3s ease;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(30, 58, 138, 0.1);
        }

        .submit-btn { 
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white; 
            padding: 1rem 2rem; 
            border: none; 
            border-radius: 8px; 
            cursor: pointer; 
            font-size: 1.1rem; 
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
        }

        .submit-btn:hover { 
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(30, 58, 138, 0.3);
        }

        .alert { 
            padding: 1rem; 
            margin-bottom: 1.5rem; 
            border-radius: 8px; 
            border: none;
        }

        .alert-success { 
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            color: var(--success-color); 
            border-left: 4px solid var(--success-color);
        }

        .alert-error { 
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #dc2626; 
            border-left: 4px solid #dc2626;
        }

        h1 { 
            color: var(--text-dark); 
            text-align: center; 
            margin-bottom: 2rem; 
            font-weight: 700;
        }

        .links { 
            text-align: center; 
            margin-top: 2rem; 
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-color);
        }

        .links a { 
            color: var(--primary-color); 
            text-decoration: none; 
            margin: 0 1rem; 
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .links a:hover { 
            color: var(--accent-color);
            text-decoration: underline; 
        }

        .required {
            color: #dc2626;
        }

        .progress-steps {
            display: flex;
            justify-content: center;
            margin-bottom: 2rem;
            position: relative;
        }

        .step {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--border-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            position: relative;
            margin: 0 1rem;
        }

        .step.active {
            background: var(--primary-color);
        }

        .step.completed {
            background: var(--success-color);
        }

        .step::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 100%;
            width: 2rem;
            height: 2px;
            background: var(--border-color);
            transform: translateY(-50%);
        }

        .step:last-child::after {
            display: none;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="container-fluid">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <a href="/" class="nav-brand">
                        <i class="fas fa-university me-2"></i>AGPS Bank
                    </a>
                </div>
                <div class="col-md-6 text-end">
                    <a href="/login" class="btn btn-outline-light me-2">
                        <i class="fas fa-sign-in-alt me-1"></i>Login
                    </a>
                    <a href="/" class="btn btn-light">
                        <i class="fas fa-home me-1"></i>Home
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <h1><i class="fas fa-user-plus me-3 text-primary"></i>Create Your Account</h1>
        
        <!-- Progress Steps -->
        <div class="progress-steps">
            <div class="step active">1</div>
            <div class="step">2</div>
            <div class="step">3</div>
        </div>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle me-2"></i>${success}
                <div class="mt-2">
                    <a href="/login" class="btn btn-success">
                        <i class="fas fa-sign-in-alt me-2"></i>Login to Your Account
                    </a>
                </div>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
            </div>
        </c:if>
        
        <form action="/customers/register" method="post" id="registrationForm">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="firstName">First Name <span class="required">*</span></label>
                        <input type="text" id="firstName" name="firstName" required minlength="2" maxlength="50">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="lastName">Last Name <span class="required">*</span></label>
                        <input type="text" id="lastName" name="lastName" required minlength="2" maxlength="50">
                    </div>
                </div>
            </div>
            
            <div class="form-group">
                <label for="email">Email Address <span class="required">*</span></label>
                <input type="email" id="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label for="phoneNumber">Phone Number <span class="required">*</span></label>
                <input type="tel" id="phoneNumber" name="phoneNumber" pattern="[0-9]{10}" required 
                       placeholder="Enter 10-digit mobile number">
            </div>

            <div class="form-group">
                <label for="dateOfBirth">Date of Birth <span class="required">*</span></label>
                <input type="date" id="dateOfBirth" name="dateOfBirth" required>
            </div>

            <div class="form-group">
                <label for="address">Address <span class="required">*</span></label>
                <textarea id="address" name="address" rows="3" required 
                          placeholder="Enter your complete address"></textarea>
            </div>
            
            <div class="form-group">
                <label for="password">Create Password <span class="required">*</span></label>
                <input type="password" id="password" name="password" required minlength="8"
                       placeholder="Minimum 8 characters">
                <small class="text-muted">Password should contain at least 8 characters</small>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>

            <div class="form-group">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="terms" required>
                    <label class="form-check-label" for="terms">
                        I agree to the <a href="/terms" target="_blank">Terms & Conditions</a> and 
                        <a href="/privacy" target="_blank">Privacy Policy</a> <span class="required">*</span>
                    </label>
                </div>
            </div>
            
            <div class="form-group">
                <button type="submit" class="submit-btn">
                    <i class="fas fa-user-plus me-2"></i>Create Account
                </button>
            </div>
        </form>
        
        <div class="links">
            <p class="text-muted">Already have an account?</p>
            <a href="/login"><i class="fas fa-sign-in-alt me-1"></i>Login Here</a>
            <span class="text-muted mx-2">|</span>
            <a href="/"><i class="fas fa-home me-1"></i>Back to Home</a>
            <span class="text-muted mx-2">|</span>
            <a href="/support"><i class="fas fa-headset me-1"></i>Need Help?</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            // Show loading state
            const submitBtn = document.querySelector('.submit-btn');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Creating Account...';
            submitBtn.disabled = true;
        });

        // Date of birth validation (minimum age 18)
        document.getElementById('dateOfBirth').addEventListener('change', function() {
            const today = new Date();
            const birthDate = new Date(this.value);
            const age = today.getFullYear() - birthDate.getFullYear();
            const monthDiff = today.getMonth() - birthDate.getMonth();
            
            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            
            if (age < 18) {
                this.setCustomValidity('You must be at least 18 years old to open an account');
            } else {
                this.setCustomValidity('');
            }
        });

        // Phone number formatting
        document.getElementById('phoneNumber').addEventListener('input', function() {
            this.value = this.value.replace(/\D/g, '').substring(0, 10);
        });
    </script>
</body>
</html>
