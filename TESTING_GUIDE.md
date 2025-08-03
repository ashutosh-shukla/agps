# AGPS Bank - Complete Testing Guide

## 🚀 Quick Start

This guide provides comprehensive testing instructions for the AGPS Bank application, covering both admin and customer workflows.

## 📋 Table of Contents

1. [Setup & Installation](#setup--installation)
2. [Service Health Checks](#service-health-checks)
3. [API Documentation (Swagger UI)](#api-documentation-swagger-ui)
4. [Customer Testing Workflow](#customer-testing-workflow)
5. [Admin Testing Workflow](#admin-testing-workflow)
6. [KYC Document Testing](#kyc-document-testing)
7. [JWT Authentication Testing](#jwt-authentication-testing)
8. [API Testing with Postman](#api-testing-with-postman)
9. [UI Testing Guide](#ui-testing-guide)
10. [Troubleshooting](#troubleshooting)

---

## 🔧 Setup & Installation

### Prerequisites
- Java 17+
- Oracle Database (localhost:1521/FREE)
- Maven 3.6+
- Chrome/Firefox browser

### Starting Services (Recommended Order)

1. **Start Eureka Server**
   ```bash
   cd eureka-server
   mvn spring-boot:run
   ```
   ✅ Verify: http://localhost:8761

2. **Start Auth Service**
   ```bash
   cd auth-service
   mvn spring-boot:run
   ```
   ✅ Verify: http://localhost:8085/login

3. **Start Customer Service**
   ```bash
   cd customer-service
   mvn spring-boot:run
   ```
   ✅ Verify: http://localhost:8081/customers/hello

4. **Start Account Service**
   ```bash
   cd account-service
   mvn spring-boot:run
   ```

5. **Start KYC Service**
   ```bash
   cd kyc-services
   mvn spring-boot:run
   ```
   ✅ Verify: http://localhost:8083/kyc/api/health

6. **Start Admin Service**
   ```bash
   cd admin-service
   mvn spring-boot:run
   ```

7. **Start API Gateway**
   ```bash
   cd apiGateway-service
   mvn spring-boot:run
   ```
   ✅ Verify: http://localhost:8080/health/auth

8. **Start Frontend UI**
   ```bash
   cd FRONTEND-UI
   mvn spring-boot:run
   ```
   ✅ Verify: http://localhost:7071/

**Quick Start Script:**
```bash
./start-services.sh
```

---

## ❤️ Service Health Checks

### Individual Service Health
| Service | Direct URL | Via Gateway |
|---------|------------|-------------|
| Eureka | http://localhost:8761 | - |
| Auth | http://localhost:8085/health | http://localhost:8080/health/auth |
| Customer | http://localhost:8081/customers/hello | http://localhost:8080/health/customer |
| Account | http://localhost:8082/account/hello | http://localhost:8080/health/account |
| KYC | http://localhost:8083/kyc/api/health | http://localhost:8080/health/kyc |
| Admin | http://localhost:8084/admin/hello | http://localhost:8080/health/admin |
| Frontend | http://localhost:7071/ | - |

### Complete System Health Check
```bash
curl http://localhost:8080/health/all
```

---

## 📚 API Documentation (Swagger UI)

### Access Swagger UI
**Main URL:** http://localhost:8080/swagger-ui.html

### Available API Groups
1. 🔐 **Authentication Service** - `/auth/**`
2. 👤 **Customer Service** - `/customers/**`, `/customer-api/**`
3. 👨‍💼 **Admin Service** - `/admin/**`
4. 📄 **KYC Service** - `/kyc/**`
5. 🏦 **Account Service** - `/account-api/**`
6. ❤️ **Health & Monitoring** - `/health/**`

### Testing with Swagger
1. Open http://localhost:8080/swagger-ui.html
2. Select API group from dropdown
3. Expand endpoints to test
4. For protected endpoints:
   - Click "Authorize" button
   - Enter: `Bearer <your-jwt-token>`
   - Test endpoints

---

## 👤 Customer Testing Workflow

### 1. Customer Registration

#### Via Web UI
1. Go to http://localhost:7071/
2. Click "Open Account" or "Sign Up Now"
3. Fill registration form:
   - First Name: John
   - Last Name: Doe
   - Email: john.doe@example.com
   - Phone: 9876543210
   - DOB: 1990-01-01
   - Address: 123 Main St, City
   - Password: password123
4. Submit form
5. ✅ **Expected:** Success message with login button

#### Via API
```bash
curl -X POST http://localhost:8080/customers/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "phoneNumber": "9876543210",
    "dateOfBirth": "1990-01-01",
    "address": "123 Main St, City",
    "password": "password123"
  }'
```

### 2. Customer Login

#### Via Web UI
1. Go to http://localhost:8085/login
2. Enter credentials:
   - Email: john.doe@example.com
   - Password: password123
3. ✅ **Expected:** Redirect to customer dashboard

#### Via API
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "password123"
  }'
```
✅ **Expected Response:**
```json
{
  "success": true,
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "userDetails": {
    "userId": "uuid",
    "email": "john.doe@example.com",
    "role": "CUSTOMER",
    "firstName": "John",
    "lastName": "Doe"
  }
}
```

### 3. Customer Dashboard Access
1. Login as customer
2. ✅ **Expected:** Dashboard shows:
   - Account status: PENDING
   - Progress steps (Registration ✅, KYC ⏳, Admin Approval ⏳, Account Active ⏳)
   - "Complete Your KYC" action card
   - Links to KYC upload

### 4. KYC Document Upload
1. From customer dashboard, click "Complete KYC"
2. Fill KYC form:
   - Full Name: John Doe
   - Email: john.doe@example.com
   - Phone: 9876543210
   - Upload Aadhar Front (image file)
   - Upload Aadhar Back (image file)
   - Upload Photograph (image file)
   - Upload PAN (optional)
3. Submit
4. ✅ **Expected:** Success message + redirect to dashboard with "Pending Admin Approval"

---

## 👨‍💼 Admin Testing Workflow

### 1. Admin Registration

#### Via Web UI
1. Go to http://localhost:8085/admin-register
2. Fill form:
   - First Name: Admin
   - Last Name: User
   - Email: admin@agpsbank.com
   - Password: admin123
3. Submit
4. ✅ **Expected:** Success message

#### Via API
```bash
curl -X POST http://localhost:8080/auth/admin/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Admin",
    "lastName": "User",
    "email": "admin@agpsbank.com",
    "password": "admin123"
  }'
```

### 2. Admin Login
1. Go to http://localhost:8085/login
2. Enter admin credentials
3. ✅ **Expected:** Redirect to admin home page

### 3. Admin Dashboard Access

#### Via Web UI
1. Login as admin
2. Go to http://localhost:7071/admin/dashboard
3. ✅ **Expected:** Admin dashboard with:
   - Customer statistics
   - Recent customers list
   - KYC documents pending review

#### Via API
```bash
# Get dashboard stats
curl -X GET http://localhost:8080/admin/api/dashboard/stats \
  -H "Authorization: Bearer <admin-jwt-token>"
```

### 4. Customer Management

#### View All Customers
```bash
curl -X GET http://localhost:8080/admin/api/customers \
  -H "Authorization: Bearer <admin-jwt-token>"
```

#### Update Customer Status
```bash
curl -X PUT http://localhost:8080/admin/api/customers/{customerId}/status \
  -H "Authorization: Bearer <admin-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{"status": "APPROVED"}'
```

#### View Customer Details
```bash
curl -X GET http://localhost:8080/admin/api/customers/{customerId} \
  -H "Authorization: Bearer <admin-jwt-token>"
```

### 5. KYC Document Review

#### View All KYC Documents
```bash
curl -X GET http://localhost:8080/admin/api/kyc \
  -H "Authorization: Bearer <admin-jwt-token>"
```

#### Approve KYC Document
```bash
curl -X PUT http://localhost:8080/admin/api/kyc/{documentId}/status \
  -H "Authorization: Bearer <admin-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "APPROVED",
    "remarks": "All documents verified successfully"
  }'
```

#### Reject KYC Document
```bash
curl -X PUT http://localhost:8080/admin/api/kyc/{documentId}/status \
  -H "Authorization: Bearer <admin-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "REJECTED",
    "remarks": "Document quality is poor. Please resubmit."
  }'
```

---

## 📄 KYC Document Testing

### Valid Test Files
Prepare these test files:
- **Aadhar Front:** `aadhar_front.jpg` (max 5MB, JPG/PNG)
- **Aadhar Back:** `aadhar_back.jpg` (max 5MB, JPG/PNG)
- **Photograph:** `photo.jpg` (max 5MB, JPG/PNG)
- **PAN Card:** `pan.jpg` (max 5MB, JPG/PNG) - Optional

### Upload via API
```bash
curl -X POST http://localhost:8080/kyc/api/upload \
  -F "fullName=John Doe" \
  -F "email=john.doe@example.com" \
  -F "phoneNumber=9876543210" \
  -F "aadharFront=@aadhar_front.jpg" \
  -F "aadharBack=@aadhar_back.jpg" \
  -F "photograph=@photo.jpg" \
  -F "panFront=@pan.jpg"
```

### Expected Validation Errors
- Missing required fields
- Invalid email format
- Invalid phone number (non-10 digits)
- File size too large (>5MB)
- Invalid file type (non-image)

---

## 🔐 JWT Authentication Testing

### 1. Get Token
```bash
# Customer login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "john.doe@example.com", "password": "password123"}'

# Admin login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@agpsbank.com", "password": "admin123"}'
```

### 2. Validate Token
```bash
curl -X POST http://localhost:8080/auth/validate-token \
  -H "Content-Type: application/json" \
  -d '{"token": "your-jwt-token"}'
```

### 3. Access Protected Endpoints
```bash
# Customer endpoint
curl -X GET http://localhost:8080/customers/{customerId} \
  -H "Authorization: Bearer <customer-token>"

# Admin-only endpoint
curl -X GET http://localhost:8080/admin/api/customers \
  -H "Authorization: Bearer <admin-token>"
```

### 4. Expected Errors
- **401 Unauthorized:** Missing or invalid token
- **403 Forbidden:** Valid token but insufficient permissions
- **Token Expired:** Token past expiration time

---

## 🧪 API Testing with Postman

### Import Collection
1. Create new Postman collection: "AGPS Bank API"
2. Set base URL variable: `{{baseUrl}}` = `http://localhost:8080`

### Environment Variables
```json
{
  "baseUrl": "http://localhost:8080",
  "customerToken": "",
  "adminToken": "",
  "customerId": "",
  "kycDocumentId": ""
}
```

### Test Scenarios

#### Scenario 1: Complete Customer Journey
1. Register customer
2. Login customer (save token)
3. Upload KYC documents
4. Check customer dashboard
5. Login as admin
6. Approve KYC
7. Approve customer
8. Check customer dashboard (should show approved)

#### Scenario 2: Admin Management
1. Login as admin
2. View all customers
3. View customer details
4. Update customer status
5. View KYC documents
6. Approve/Reject KYC

#### Scenario 3: Error Handling
1. Invalid login credentials
2. Expired token usage
3. Unauthorized access (customer accessing admin endpoints)
4. Invalid data submission

---

## 🌐 UI Testing Guide

### Browser Testing
Test on:
- ✅ Chrome (latest)
- ✅ Firefox (latest)
- ✅ Safari (latest)
- ✅ Edge (latest)

### Responsive Testing
Test screen sizes:
- 📱 Mobile: 375px width
- 📱 Tablet: 768px width
- 💻 Desktop: 1200px width
- 🖥️ Large: 1920px width

### Key UI Test Cases

#### Homepage (http://localhost:7071/)
1. ✅ Navigation links work
2. ✅ "Open Account" → Customer Registration
3. ✅ "LOGIN" → Login page
4. ✅ "ADMIN" → Admin registration
5. ✅ Responsive design on mobile

#### Customer Registration
1. ✅ Form validation works
2. ✅ Required field validation
3. ✅ Email format validation
4. ✅ Phone number format validation
5. ✅ Password confirmation
6. ✅ Age validation (18+)
7. ✅ Success → redirect to login

#### Customer Dashboard
1. ✅ Shows correct status based on account state
2. ✅ Progress indicator updates
3. ✅ Action cards show based on status
4. ✅ KYC upload link works
5. ✅ Auto-refresh for pending status

#### Admin Dashboard
1. ✅ Statistics load correctly
2. ✅ Customer list displays
3. ✅ KYC documents list
4. ✅ Status update buttons work
5. ✅ Customer details modal

#### Login Page
1. ✅ Validates credentials
2. ✅ Shows error for invalid login
3. ✅ Redirects correctly after login
4. ✅ Role-based redirection

---

## 🔍 Test Data Sets

### Valid Customer Data
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com",
  "phoneNumber": "9876543210",
  "dateOfBirth": "1990-01-01",
  "address": "123 Main St, New York, NY 10001",
  "password": "SecurePass123"
}
```

### Valid Admin Data
```json
{
  "firstName": "Admin",
  "lastName": "User",
  "email": "admin@agpsbank.com",
  "password": "AdminPass123"
}
```

### Invalid Test Cases
```json
{
  "invalidEmail": "not-an-email",
  "shortPassword": "123",
  "invalidPhone": "123",
  "underage": "2010-01-01",
  "emptyFields": ""
}
```

---

## 🚨 Troubleshooting

### Common Issues

#### 1. Service Not Starting
**Problem:** Service fails to start
**Solutions:**
- Check Oracle DB is running
- Verify port availability
- Check Eureka Server is running first
- Review application logs

#### 2. Database Connection Failed
**Problem:** Cannot connect to Oracle DB
**Solutions:**
```sql
-- Check Oracle DB status
SELECT 1 FROM DUAL;

-- Verify connection settings
-- URL: jdbc:oracle:thin:@localhost:1521:FREE
-- Username: system
-- Password: system
```

#### 3. JWT Token Issues
**Problem:** Token authentication failing
**Solutions:**
- Check token format: `Bearer <token>`
- Verify token not expired
- Ensure consistent JWT secret across services
- Validate token with `/auth/validate-token`

#### 4. CORS Issues
**Problem:** Frontend cannot call API
**Solutions:**
- Check API Gateway CORS configuration
- Verify frontend origin in CORS settings
- Use browser dev tools to check CORS headers

#### 5. File Upload Issues
**Problem:** KYC file upload failing
**Solutions:**
- Check file size < 5MB
- Verify file type (JPG/PNG only)
- Ensure multipart/form-data content type
- Check server disk space

#### 6. Service Discovery Issues
**Problem:** Services cannot find each other
**Solutions:**
- Verify Eureka Server running on port 8761
- Check service registration in Eureka dashboard
- Wait for heartbeat intervals (30 seconds)
- Restart services in correct order

### Logs to Check
1. **Application Logs:** `logs/application.log`
2. **Eureka Dashboard:** http://localhost:8761
3. **Browser Console:** F12 → Console tab
4. **Network Tab:** F12 → Network tab for API calls

### Performance Monitoring
- **Response Times:** Should be < 2 seconds
- **Memory Usage:** Monitor with `jvisualvm`
- **Database Connections:** Check connection pool
- **File Storage:** Monitor disk space for uploads

---

## ✅ Test Completion Checklist

### Functional Testing
- [ ] Customer registration works
- [ ] Customer login works
- [ ] Customer dashboard displays correctly
- [ ] KYC upload works
- [ ] Admin registration works
- [ ] Admin login works
- [ ] Admin can view customers
- [ ] Admin can approve/reject KYC
- [ ] Admin can update customer status
- [ ] JWT authentication works
- [ ] Role-based access control works

### UI Testing
- [ ] Homepage navigation works
- [ ] All forms validate correctly
- [ ] Error messages display properly
- [ ] Success messages display properly
- [ ] Responsive design works
- [ ] Cross-browser compatibility

### API Testing
- [ ] All endpoints respond correctly
- [ ] Authentication endpoints work
- [ ] Protected endpoints require tokens
- [ ] Error responses are proper
- [ ] Swagger documentation accessible

### Integration Testing
- [ ] Services communicate correctly
- [ ] Database operations work
- [ ] File uploads work
- [ ] Email notifications work (if implemented)
- [ ] End-to-end workflows complete

---

## 🎯 Performance Benchmarks

### Expected Response Times
- Login: < 1 second
- Registration: < 2 seconds
- Dashboard load: < 1.5 seconds
- File upload: < 5 seconds
- API calls: < 500ms

### Load Testing
Use tools like Apache JMeter or Postman to test:
- 100 concurrent users
- 1000 requests per minute
- File upload with 10MB files

---

## 📞 Support

For testing issues:
1. Check this guide first
2. Review application logs
3. Check Swagger UI for API details
4. Contact development team

**Happy Testing! 🎉**