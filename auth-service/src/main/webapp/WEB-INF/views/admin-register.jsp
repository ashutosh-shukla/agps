<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Banking App - Admin Registration</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }

        .register-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }

        .logo {
            margin-bottom: 2rem;
        }

        .logo h1 {
            color: #333;
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }

        .logo p {
            color: #666;
            font-size: 1rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .links {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e1e5e9;
        }

        .links a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .links a:hover {
            color: #764ba2;
        }

        .alert {
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
        }

        .alert.success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        .alert.error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        @media (max-width: 600px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="logo">
            <h1>👨‍💼</h1>
            <h1>Admin Registration</h1>
            <p>Register as a bank administrator</p>
        </div>

        <c:if test="${not empty message}">
            <div class="alert ${messageType}">
                ${message}
            </div>
        </c:if>

        <form:form method="post" modelAttribute="admin" action="/admin-register">
            <div class="form-row">
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <form:input path="firstName" id="firstName" required="true" />
                </div>

                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <form:input path="lastName" id="lastName" required="true" />
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <form:input path="email" type="email" id="email" required="true" />
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <form:password path="password" id="password" required="true" />
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" required>
            </div>

            <button type="submit" class="btn" id="registerBtn">
                Register Admin
            </button>
        </form:form>

        <div class="links">
            <p>Already have an account? <a href="/login">Sign In</a></p>
            <p>Customer registration? <a href="http://localhost:8080/customers/register">Register as Customer</a></p>
        </div>
    </div>

    <script>
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return;
            }

            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long!');
                return;
            }

            // Show loading state
            const btn = document.getElementById('registerBtn');
            btn.disabled = true;
            btn.textContent = 'Registering...';
        });

        // Auto-hide success message and redirect to login
        <c:if test="${messageType == 'success'}">
            setTimeout(function() {
                window.location.href = '/login';
            }, 2000);
        </c:if>
    </script>
</body>
</html>