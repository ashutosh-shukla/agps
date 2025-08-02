<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Banking App - Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .role-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .role-admin {
            background: rgba(255, 0, 0, 0.2);
            color: #ff6b6b;
        }

        .role-customer {
            background: rgba(0, 255, 0, 0.2);
            color: #51cf66;
        }

        .logout-btn {
            padding: 0.5rem 1rem;
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .welcome-section {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 2rem;
            text-align: center;
        }

        .welcome-section h1 {
            color: #333;
            margin-bottom: 1rem;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .service-card {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-align: center;
        }

        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .service-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .service-card h3 {
            color: #333;
            margin-bottom: 1rem;
        }

        .service-card p {
            color: #666;
            margin-bottom: 1.5rem;
        }

        .service-btn {
            padding: 0.75rem 1.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            font-weight: 500;
        }

        .service-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(102, 126, 234, 0.3);
        }

        .unauthorized {
            text-align: center;
            padding: 4rem 2rem;
        }

        .unauthorized h1 {
            color: #333;
            margin-bottom: 1rem;
        }

        .unauthorized p {
            color: #666;
            margin-bottom: 2rem;
        }

        .login-link {
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .login-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 1rem;
            }

            .services-grid {
                grid-template-columns: 1fr;
            }

            .container {
                padding: 0 1rem;
            }
        }
    </style>
</head>
<body>
    <c:choose>
        <c:when test="${authenticated}">
            <div class="header">
                <div class="header-content">
                    <div class="logo">🏦 SecureBank</div>
                    <div class="user-info">
                        <span>Welcome, ${firstName} ${lastName}</span>
                        <span class="role-badge role-${role.toLowerCase()}">${role}</span>
                        <a href="/login" class="logout-btn" onclick="logout()">Logout</a>
                    </div>
                </div>
            </div>

            <div class="container">
                <div class="welcome-section">
                    <h1>Welcome to Your Banking Dashboard</h1>
                    <p>Access all your banking services from one convenient location</p>
                </div>

                <div class="services-grid">
                    <c:if test="${role == 'CUSTOMER'}">
                        <div class="service-card">
                            <div class="service-icon">👤</div>
                            <h3>Account Management</h3>
                            <p>View and update your personal information and account details</p>
                            <a href="http://localhost:8080/customers" class="service-btn" onclick="navigateWithToken('http://localhost:8080/customers')">Manage Account</a>
                        </div>

                        <div class="service-card">
                            <div class="service-icon">💰</div>
                            <h3>Account Balance</h3>
                            <p>Check your current account balance and account information</p>
                            <a href="http://localhost:8080/account-api/accounts" class="service-btn" onclick="navigateWithToken('http://localhost:8080/account-api/accounts')">View Balance</a>
                        </div>

                        <div class="service-card">
                            <div class="service-icon">💸</div>
                            <h3>Transactions</h3>
                            <p>Make deposits, withdrawals, and transfers between accounts</p>
                            <a href="http://localhost:8080/account-api/accounts" class="service-btn" onclick="navigateWithToken('http://localhost:8080/account-api/accounts')">Transactions</a>
                        </div>

                        <div class="service-card">
                            <div class="service-icon">📄</div>
                            <h3>KYC Documents</h3>
                            <p>Upload and manage your Know Your Customer documents</p>
                            <a href="http://localhost:8080/kyc/api" class="service-btn" onclick="navigateWithToken('http://localhost:8080/kyc/api')">KYC Portal</a>
                        </div>
                    </c:if>

                    <c:if test="${role == 'ADMIN'}">
                        <div class="service-card">
                            <div class="service-icon">👥</div>
                            <h3>Customer Management</h3>
                            <p>View and manage all customer accounts and information</p>
                            <a href="http://localhost:8080/admin" class="service-btn" onclick="navigateWithToken('http://localhost:8080/admin')">Manage Customers</a>
                        </div>

                        <div class="service-card">
                            <div class="service-icon">🏦</div>
                            <h3>Account Oversight</h3>
                            <p>Monitor all customer accounts and financial activities</p>
                            <a href="http://localhost:8080/admin/dashboard" class="service-btn" onclick="navigateWithToken('http://localhost:8080/admin/dashboard')">Account Oversight</a>
                        </div>

                        <div class="service-card">
                            <div class="service-icon">📊</div>
                            <h3>KYC Management</h3>
                            <p>Review and approve customer KYC documents and applications</p>
                            <a href="http://localhost:8080/admin/kyc" class="service-btn" onclick="navigateWithToken('http://localhost:8080/admin/kyc')">KYC Review</a>
                        </div>

                        <div class="service-card">
                            <div class="service-icon">📈</div>
                            <h3>Reports & Analytics</h3>
                            <p>Generate reports and view banking analytics and insights</p>
                            <a href="http://localhost:8080/admin/reports" class="service-btn" onclick="navigateWithToken('http://localhost:8080/admin/reports')">View Reports</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="unauthorized">
                <h1>🔒 Access Denied</h1>
                <p>You need to be logged in to access the banking dashboard.</p>
                <a href="/login" class="login-link">Login to Continue</a>
            </div>
        </c:otherwise>
    </c:choose>

    <script>
        function logout() {
            // Clear stored authentication data
            localStorage.removeItem('authToken');
            localStorage.removeItem('userRole');
            localStorage.removeItem('userId');
            localStorage.removeItem('firstName');
            localStorage.removeItem('lastName');
        }

        function navigateWithToken(url) {
            const token = localStorage.getItem('authToken') || '${token}';
            if (token) {
                // Add token as a header or query parameter depending on your API design
                window.location.href = url + '?token=' + encodeURIComponent(token);
            } else {
                alert('Session expired. Please login again.');
                window.location.href = '/login';
            }
        }

        // Store token in localStorage if provided via URL params
        const urlParams = new URLSearchParams(window.location.search);
        const token = urlParams.get('token');
        if (token) {
            localStorage.setItem('authToken', token);
        }
    </script>
</body>
</html>