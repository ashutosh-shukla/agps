<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
        .container { max-width: 1400px; margin: 0 auto; }
        .header { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .header h1 { margin: 0; color: #333; }
        .nav-menu { margin-top: 15px; }
        .nav-menu a { color: #007bff; text-decoration: none; margin-right: 20px; padding: 8px 16px; border-radius: 5px; }
        .nav-menu a:hover { background-color: #e7f3ff; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); text-align: center; }
        .stat-number { font-size: 36px; font-weight: bold; color: #007bff; margin-bottom: 10px; }
        .stat-label { font-size: 16px; color: #666; }
        .content-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .content-section { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .content-section h3 { margin-top: 0; color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #eee; }
        th { background-color: #f8f9fa; font-weight: bold; }
        .status-pending { color: #ffc107; font-weight: bold; }
        .status-approved { color: #28a745; font-weight: bold; }
        .status-rejected { color: #dc3545; font-weight: bold; }
        .status-active { color: #28a745; font-weight: bold; }
        .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 12px; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-success { background-color: #28a745; color: white; }
        .btn:hover { opacity: 0.8; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Banking System - Admin Dashboard</h1>
            <div class="nav-menu">
                <a href="/admin/dashboard">Dashboard</a>
                <a href="/admin/customers">Customers</a>
                <a href="/admin/accounts">Accounts</a>
                <a href="/admin/kyc">KYC Documents</a>
                <a href="http://localhost:7071/kyc/form">Frontend</a>
            </div>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${stats.totalCustomers}</div>
                <div class="stat-label">Total Customers</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${stats.totalAccounts}</div>
                <div class="stat-label">Total Accounts</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${stats.pendingKYC}</div>
                <div class="stat-label">Pending KYC</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${stats.approvedKYC}</div>
                <div class="stat-label">Approved KYC</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${stats.rejectedKYC}</div>
                <div class="stat-label">Rejected KYC</div>
            </div>
        </div>
        
        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Recent Customers -->
            <div class="content-section">
                <h3>Recent Customers</h3>
                <c:choose>
                    <c:when test="${not empty recentCustomers}">
                        <table>
                            <thead>
                                <tr>
                                    <th>Customer ID</th>
                                    <th>Name</th>
                                    <th>Status</th>
                                    <th>KYC Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="customer" items="${recentCustomers}">
                                    <tr>
                                        <td>${customer.customer_id}</td>
                                        <td>${customer.first_name} ${customer.last_name}</td>
                                        <td><span class="status-${customer.status.toLowerCase()}">${customer.status}</span></td>
                                        <td><span class="status-${customer.kyc_status.toLowerCase()}">${customer.kyc_status}</span></td>
                                        <td>
                                            <a href="/admin/customers/${customer.customer_id}" class="btn btn-primary">View</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div style="text-align: center; margin-top: 15px;">
                            <a href="/admin/customers" class="btn btn-success">View All Customers</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p>No customers found.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Recent KYC Documents -->
            <div class="content-section">
                <h3>Recent KYC Documents</h3>
                <c:choose>
                    <c:when test="${not empty recentKYC}">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="kyc" items="${recentKYC}">
                                    <tr>
                                        <td>${kyc.id}</td>
                                        <td>${kyc.full_name}</td>
                                        <td>${kyc.email}</td>
                                        <td><span class="status-${kyc.status.toLowerCase()}">${kyc.status}</span></td>
                                        <td>
                                            <a href="/admin/kyc/${kyc.id}" class="btn btn-primary">View</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div style="text-align: center; margin-top: 15px;">
                            <a href="/admin/kyc" class="btn btn-success">View All KYC</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p>No KYC documents found.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
