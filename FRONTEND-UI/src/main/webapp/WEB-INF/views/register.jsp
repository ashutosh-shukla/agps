<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f5f7fa; font-family: 'Segoe UI', sans-serif; }
        .form-container {
            background: white; padding: 40px; border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1); margin-top: 50px;
        }
        .btn-custom {
            background-color: #003366; color: #fff; border-radius: 25px;
            padding: 10px 30px;
        }
        .btn-custom:hover { background-color: #001f4d; }
        .alert { margin-bottom: 20px; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 form-container">
            <h2 class="text-center mb-4">New Customer Registration</h2>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form:form modelAttribute="customer"
                       action="${pageContext.request.contextPath}/customer/registerCustomer"
                       method="post" onsubmit="return validateForm()">
                
                <div class="mb-3">
                    <label>First Name *</label>
                    <form:input path="firstName" cssClass="form-control" required="true"/>
                </div>
                
                <div class="mb-3">
                    <label>Last Name *</label>
                    <form:input path="lastName" cssClass="form-control" required="true"/>
                </div>
                
                <div class="mb-3">
                    <label>Email *</label>
                    <form:input path="email" type="email" cssClass="form-control" required="true"/>
                </div>
                
                <div class="mb-3">
                    <label>Phone Number *</label>
                    <form:input path="phoneNumber" cssClass="form-control" required="true"/>
                </div>
                
                <div class="mb-3">
                    <label>Address *</label>
                    <form:textarea path="address" cssClass="form-control" required="true"/>
                </div>
                
                <div class="mb-3">
                    <label>Date of Birth *</label>
                    <form:input path="dateOfBirth" type="date" cssClass="form-control" required="true"/>
                </div>
                
                <div class="mb-3">
                    <label>Password *</label>
                    <form:password path="password" cssClass="form-control" required="true"
                                   pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
                                   title="Min 8 chars, 1 uppercase, 1 number, 1 special char"/>
                </div>
                
                <div class="d-grid">
                    <button type="submit" class="btn btn-custom">Register</button>
                </div>
            </form:form>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        const phone = document.querySelector('input[name="phoneNumber"]').value;
        if (!/^\d{10,15}$/.test(phone)) {
            alert("Phone number must be between 10 and 15 digits.");
            return false;
        }
        return true;
    }
</script>
</body>
</html>