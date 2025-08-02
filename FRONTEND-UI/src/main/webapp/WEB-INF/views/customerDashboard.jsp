<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Customer Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>Welcome, ${customer.firstName}</h2>
    <p>Account Number: ${account.accountNumber}</p>
    <p>Balance: ${account.balance}</p>


    <h3>Actions</h3>
   <a href="${pageContext.request.contextPath}/customers/depositPage/${customer.customerId}" class="btn btn-success">Deposit</a>
    <a href="${pageContext.request.contextPath}/customers/withdrawlPage/${customer.customerId}" class="btn btn-warning">Withdraw</a>
     <a href="${pageContext.request.contextPath}/customers/transferPage/${customer.customerId}" class="btn btn-primary">Transfer</a>
     <a href="${pageContext.request.contextPath}/customers/transactionHistory/${customer.customerId}" class="btn btn-info">Transaction History</a>
     <a href="${pageContext.request.contextPath}/customers/editProfile/${customer.customerId}" class="btn btn-dark">Edit Profile</a>
    
     <hr>
    
     

</div>
</body>
</html>
