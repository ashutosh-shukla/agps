<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Deposit Money</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h2 class="text-center">Deposit Money</h2>
                </div>
                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                    
                    <c:if test="${not empty account}">
                        <div class="alert alert-info">
                            <strong>Current Balance:</strong> ₹${account.balance}
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/customers/deposit/${customerId}" method="post">
                        <div class="mb-3">
                            <label for="amount" class="form-label">Amount to Deposit</label>
                            <input type="number" step="0.01" min="1" name="amount" id="amount" 
                                   class="form-control" placeholder="Enter amount" required>
                            <small class="form-text text-muted">Maximum deposit limit: ₹1,00,000 per transaction</small>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success">Deposit Money</button>
                            <a href="${pageContext.request.contextPath}/customer/dashboard/${customerId}" 
                               class="btn btn-secondary">Back to Dashboard</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>