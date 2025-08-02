<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Transaction History</title>
    <style>
        table, th, td { border: 1px solid black; border-collapse: collapse; padding: 8px; }
    </style>
</head>
<body>

<h2>Transaction History for Customer ID: ${customerId}</h2>

<c:if test="${not empty error}">
    <p style="color:red;">${error}</p>
</c:if>

<c:if test="${noTransactions}">
    <p>${message}</p>
</c:if>

<c:if test="${not empty transactions}">
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Type</th>
                <th>Amount</th>
                <th>Date</th>
                <th>To Account</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${transactions}" var="txn">
                <tr>
                    <td>${txn.transactionId}</td>
                    <td>${txn.type}</td>
                    <td>${txn.amount}</td>
                    <td>${txn.date}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty txn.toAccount}">
                                ${txn.toAccount}
                            </c:when>
                            <c:otherwise>
                                N/A
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</c:if>

</body>
</html>
