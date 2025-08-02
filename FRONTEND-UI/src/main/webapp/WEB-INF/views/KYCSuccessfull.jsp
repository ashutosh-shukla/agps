<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>KYC Upload Success</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="alert alert-success text-center fs-5">
        ✅ Your KYC documents were uploaded successfully.<br>
        Please wait for admin approval before account creation.
    </div>

   <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success">Back to Dashboard</button>
                            <a href="${pageContext.request.contextPath}/customer/dashboard/${customerId}" 
                               class="btn btn-secondary">Back to Dashboard</a>
                        </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
