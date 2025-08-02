<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head><title>KYC Health Check</title></head>
<body>
    <h2>KYC Service Connection Test</h2>
    <p>Status: <strong>${status}</strong></p>
    <a href="/ui/kyc/test-connection">Refresh</a>
</body>
</html>
