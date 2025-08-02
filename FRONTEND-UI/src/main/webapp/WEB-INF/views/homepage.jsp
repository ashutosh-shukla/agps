<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<html>
<head>
    <title>Register Customer</title>
</head>
<body>

<h2>Register New Customer</h2>

<form:form method="post" modelAttribute="customer">

    First Name: <form:input path="firstName" /><br><br>
    Last Name: <form:input path="lastName" /><br><br>
    Email: <form:input path="email" /><br><br>
    Phone Number: <form:input path="phoneNumber" /><br><br>
    Address: <form:input path="address" /><br><br>
    Date of Birth (YYYY-MM-DD): <form:input path="dateOfBirth" /><br><br>
    Status: <form:input path="status" value="PENDING"/><br><br>

    <input type="submit" value="Register"/>

</form:form>

</body>
</html>
