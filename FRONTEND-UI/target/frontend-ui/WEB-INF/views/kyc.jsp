<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>KYC Upload Form</title>
</head>
<body>
    <h1>Upload KYC Documents</h1>
    <form method="post" action="/kyc/upload" enctype="multipart/form-data">
        <label for="photo">Photograph:</label>
        <input type="file" name="photo" /><br><br>
        <input type="submit" value="Upload" />
    </form>
</body>
</html>
