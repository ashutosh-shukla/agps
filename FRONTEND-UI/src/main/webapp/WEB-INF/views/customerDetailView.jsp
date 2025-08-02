<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">

    <h3>Customer Details</h3>

    <table class="table table-striped">
        <tr><th>Customer ID:</th><td>${customer.customerId}</td></tr>
        <tr><th>Name:</th><td>${customer.firstName} ${customer.lastName}</td></tr>
        <tr><th>Email:</th><td>${customer.email}</td></tr>
        <tr><th>Phone:</th><td>${customer.phoneNumber}</td></tr>
        <tr><th>Address:</th><td>${customer.address}</td></tr>
        <tr><th>Date of Birth:</th><td>${customer.dateOfBirth}</td></tr>
        <tr><th>Status:</th><td>${customer.status}</td></tr>
    </table>

    <form action="updateKycStatus" method="post">
        <input type="hidden" name="customerId" value="${customer.customerId}" />

        <label>Status:</label>
        <select name="status" class="form-select mb-3">
            <option value="PENDING" ${customer.status=='PENDING' ? 'selected' : ''}>Pending</option>
            <option value="APPROVED" ${customer.status=='APPROVED' ? 'selected' : ''}>Approved</option>
            <option value="REJECTED" ${customer.status=='REJECTED' ? 'selected' : ''}>Rejected</option>
        </select>

        <button type="submit" class="btn btn-success">Update Status</button>
    </form>

</div>
</body>
</html>
