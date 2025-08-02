<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AGPS Bank - Authentication Test</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .auth-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .status-box {
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
        }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        .info { background-color: #d1ecf1; color: #0c5460; }
        .test-section {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container">
        <div class="auth-container bg-white">
            <h2 class="text-center mb-4">🏦 AGPS Bank Authentication Test</h2>
            
            <!-- Login Form -->
            <div class="test-section">
                <h4>🔐 Login Test</h4>
                <form id="loginForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" value="testuser" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" value="password123" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Login</button>
                    <button type="button" id="adminLogin" class="btn btn-warning ms-2">Admin Login</button>
                </form>
            </div>
            
            <!-- Status Display -->
            <div id="statusDisplay"></div>
            
            <!-- Protected Actions -->
            <div id="protectedSection" class="test-section" style="display: none;">
                <h4>🛡️ Protected Actions</h4>
                <div class="d-flex flex-wrap gap-2">
                    <button id="testCustomerApi" class="btn btn-success">Test Customer API</button>
                    <button id="testDashboard" class="btn btn-info">Test Dashboard</button>
                    <button id="testProfile" class="btn btn-secondary">Test Profile</button>
                    <button id="validateToken" class="btn btn-warning">Validate Token</button>
                    <button id="logoutBtn" class="btn btn-danger">Logout</button>
                </div>
            </div>
            
            <!-- API Response Display -->
            <div id="apiResponse"></div>
            
            <!-- Registration Test -->
            <div class="test-section">
                <h4>📝 Registration Test</h4>
                <form id="registerForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="regUsername" class="form-label">New Username</label>
                            <input type="text" class="form-control" id="regUsername" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="regPassword" class="form-label">Password</label>
                            <input type="password" class="form-control" id="regPassword" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-success">Register New User</button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const API_BASE_URL = 'http://localhost:8080'; // API Gateway URL
        
        // Login functionality
        document.getElementById('loginForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            await performLogin('testuser', 'password123');
        });
        
        // Admin login
        document.getElementById('adminLogin').addEventListener('click', async function() {
            await performLogin('admin', 'admin123');
        });
        
        async function performLogin(username, password) {
            try {
                showStatus('🔄 Attempting login...', 'info');
                
                const response = await fetch(`${API_BASE_URL}/auth/login`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    credentials: 'include',
                    body: JSON.stringify({ username, password })
                });
                
                const data = await response.json();
                
                if (response.ok && data.success) {
                    showStatus(`✅ Login successful! Role: ${data.role}. JWT token stored in cookie.`, 'success');
                    document.getElementById('protectedSection').style.display = 'block';
                } else {
                    showStatus('❌ Login failed: ' + data.message, 'error');
                }
            } catch (error) {
                showStatus('❌ Login error: ' + error.message, 'error');
            }
        }
        
        // Registration
        document.getElementById('registerForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const username = document.getElementById('regUsername').value;
            const password = document.getElementById('regPassword').value;
            
            try {
                showStatus('🔄 Registering user...', 'info');
                
                const response = await fetch(`${API_BASE_URL}/auth/register`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ username, password })
                });
                
                const data = await response.json();
                
                if (response.ok && data.success) {
                    showStatus('✅ Registration successful!', 'success');
                    document.getElementById('regUsername').value = '';
                    document.getElementById('regPassword').value = '';
                } else {
                    showStatus('❌ Registration failed: ' + data.message, 'error');
                }
            } catch (error) {
                showStatus('❌ Registration error: ' + error.message, 'error');
            }
        });
        
        // Test Customer API
        document.getElementById('testCustomerApi').addEventListener('click', async function() {
            await testApi('/customer/hello', 'Customer Hello API');
        });
        
        // Test Dashboard
        document.getElementById('testDashboard').addEventListener('click', async function() {
            await testApi('/customer/dashboard', 'Customer Dashboard API');
        });
        
        // Test Profile
        document.getElementById('testProfile').addEventListener('click', async function() {
            await testApi('/customer/profile', 'Customer Profile API');
        });
        
        // Validate Token
        document.getElementById('validateToken').addEventListener('click', async function() {
            try {
                showApiResponse('🔄 Validating token...', 'info');
                
                const response = await fetch(`${API_BASE_URL}/auth/validate`, {
                    method: 'GET',
                    credentials: 'include'
                });
                
                const data = await response.json();
                
                if (response.ok && data.success) {
                    showApiResponse(`✅ Token Valid! Role: ${data.role}`, 'success');
                } else {
                    showApiResponse('❌ Token Invalid: ' + data.message, 'error');
                }
            } catch (error) {
                showApiResponse('❌ Validation error: ' + error.message, 'error');
            }
        });
        
        async function testApi(endpoint, name) {
            try {
                showApiResponse(`🔄 Testing ${name}...`, 'info');
                
                const response = await fetch(`${API_BASE_URL}${endpoint}`, {
                    method: 'GET',
                    credentials: 'include'
                });
                
                if (response.ok) {
                    const data = await response.text();
                    showApiResponse(`✅ ${name} Response: ${data}`, 'success');
                } else {
                    showApiResponse(`❌ ${name} failed: ${response.status}`, 'error');
                }
            } catch (error) {
                showApiResponse(`❌ ${name} error: ${error.message}`, 'error');
            }
        }
        
        // Logout functionality
        document.getElementById('logoutBtn').addEventListener('click', async function() {
            try {
                const response = await fetch(`${API_BASE_URL}/auth/logout`, {
                    method: 'POST',
                    credentials: 'include'
                });
                
                if (response.ok) {
                    showStatus('✅ Logged out successfully!', 'success');
                    document.getElementById('protectedSection').style.display = 'none';
                    document.getElementById('apiResponse').innerHTML = '';
                } else {
                    showStatus('❌ Logout failed', 'error');
                }
            } catch (error) {
                showStatus('❌ Logout error: ' + error.message, 'error');
            }
        });
        
        function showStatus(message, type) {
            document.getElementById('statusDisplay').innerHTML = 
                `<div class="status-box ${type}">${message}</div>`;
        }
        
        function showApiResponse(message, type) {
            document.getElementById('apiResponse').innerHTML = 
                `<div class="status-box ${type}"><strong>API Response:</strong><br>${message}</div>`;
        }
        
        // Check if already logged in on page load
        window.addEventListener('load', async function() {
            try {
                const response = await fetch(`${API_BASE_URL}/auth/validate`, {
                    credentials: 'include'
                });
                
                if (response.ok) {
                    const data = await response.json();
                    if (data.success) {
                        showStatus(`✅ Already logged in! Role: ${data.role}`, 'success');
                        document.getElementById('protectedSection').style.display = 'block';
                    }
                }
            } catch (error) {
                // User not logged in, show login form
            }
        });
    </script>
</body>
</html>