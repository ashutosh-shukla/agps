# AGPS Bank - Complete Banking Application with JWT Authentication

A comprehensive microservices-based banking application with JWT authentication, role-based access control, admin panel, KYC management, and modern web interface.

## 🏛️ System Architecture

```
Frontend (JSP Pages) → API Gateway → Authentication Service → Business Services
                    ↘                                      ↗
                      Customer Service ← ─ ─ ─ ─ ─ ─ ─ ─ ┘
                      Account Service
                      KYC Service
                      Admin Service
                      Eureka Server
```

## 🚀 Key Features

### 🔐 Authentication & Security
- **JWT Token Authentication** with role-based access control
- **Admin Panel** with comprehensive customer and KYC management
- **Password Encryption** using BCrypt
- **Route Protection** with API Gateway security

### 👤 Customer Features
- **Customer Registration** with complete form validation
- **Customer Dashboard** with status tracking and progress indicators
- **KYC Document Upload** with file validation and Base64 storage
- **Real-time Status Updates** with auto-refresh functionality
- **Profile Management** with edit capabilities

### 👨‍💼 Admin Features
- **Comprehensive Admin Panel** with tabbed interface
- **Customer Management** - view, approve, reject customers
- **KYC Document Review** with document preview and approval workflow
- **Account Management** with activation/deactivation controls
- **Real-time Dashboard** with statistics and recent activity
- **Notification System** for customer actions

### 🏦 Banking Operations
- **Account Creation** after customer approval
- **Fund Transfer** with secure transaction processing
- **Deposit/Withdrawal** operations
- **Transaction History** with detailed records
- **Balance Management** with real-time updates

### 📄 KYC Management
- **Document Upload** (Aadhar, PAN, Photograph)
- **Admin Review Workflow** with approval/rejection
- **Notification System** for status updates
- **Document Validation** with file type and size checks
- **Progress Tracking** for customers

## 🌐 Access URLs

### Main Application Pages
- **Homepage**: http://localhost:7071/
- **Customer Registration**: http://localhost:7071/customers/register  
- **Login**: http://localhost:8085/login
- **Admin Registration**: http://localhost:8085/admin-register
- **Customer Dashboard**: http://localhost:7071/customer/dashboard
- **Admin Panel**: http://localhost:7071/comprehensive-admin-panel.jsp
- **KYC Upload**: http://localhost:7071/kyc/upload

### API Documentation
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **API Groups Available**:
  - 🔐 Authentication Service
  - 👤 Customer Service  
  - 👨‍💼 Admin Service
  - 📄 KYC Service
  - 🏦 Account Service
  - ❤️ Health & Monitoring

### Service Health Checks
- **Auth Service**: http://localhost:8080/health/auth
- **Customer Service**: http://localhost:8080/health/customer
- **Account Service**: http://localhost:8080/health/account
- **KYC Service**: http://localhost:8080/health/kyc
- **Admin Service**: http://localhost:8080/health/admin
- **Eureka Dashboard**: http://localhost:8761

## 🛠️ Complete Setup Instructions

### Prerequisites
- Java 17+
- Oracle Database (localhost:1521/FREE)
- Maven 3.6+
- Chrome/Firefox browser

### Quick Start
```bash
# Clone the repository
git clone <repository-url>
cd agps-bank

# Start all services
./start-services.sh

# Or start manually in order:
cd eureka-server && mvn spring-boot:run &
cd auth-service && mvn spring-boot:run &
cd customer-service && mvn spring-boot:run &
cd account-service && mvn spring-boot:run &
cd kyc-services && mvn spring-boot:run &
cd admin-service && mvn spring-boot:run &
cd apiGateway-service && mvn spring-boot:run &
cd FRONTEND-UI && mvn spring-boot:run &
```

### Database Setup
```sql
-- Oracle Database should be running on localhost:1521/FREE
-- Username: system
-- Password: system
-- Tables will be auto-created by JPA
```

## 🔄 Complete User Workflow

### Customer Journey
1. **Visit Homepage** → http://localhost:7071/
2. **Register Account** → Click "Open Account" → Fill registration form
3. **Login** → Use email and password
4. **Customer Dashboard** → View account status (PENDING)
5. **Complete KYC** → Upload Aadhar, PAN, Photo
6. **Wait for Approval** → Dashboard shows "Pending Admin Approval"
7. **Account Activated** → After admin approval, access banking features

### Admin Journey
1. **Register as Admin** → http://localhost:8085/admin-register
2. **Login** → Use admin credentials
3. **Admin Panel** → http://localhost:7071/comprehensive-admin-panel.jsp
4. **Review Customers** → View all registered customers
5. **Review KYC Documents** → Approve/reject uploaded documents
6. **Manage Accounts** → Activate/deactivate customer accounts
7. **Monitor System** → View statistics and notifications

## 🧪 Testing Guide

For comprehensive testing instructions, see [TESTING_GUIDE.md](TESTING_GUIDE.md)

### Quick Test Scenarios

#### Test Customer Registration & KYC
```bash
# 1. Register customer via API
curl -X POST http://localhost:8080/customers/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe", 
    "email": "john.doe@example.com",
    "phoneNumber": "9876543210",
    "password": "password123",
    "address": "123 Main St",
    "dateOfBirth": "1990-01-01"
  }'

# 2. Login customer
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "password123"
  }'

# 3. Upload KYC (use form data)
curl -X POST http://localhost:8080/kyc/api/upload \
  -F "fullName=John Doe" \
  -F "email=john.doe@example.com" \
  -F "phoneNumber=9876543210" \
  -F "aadharFront=@aadhar_front.jpg" \
  -F "aadharBack=@aadhar_back.jpg" \
  -F "photograph=@photo.jpg"
```

#### Test Admin Operations
```bash
# 1. Register admin
curl -X POST http://localhost:8080/auth/admin/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Admin",
    "lastName": "User",
    "email": "admin@agpsbank.com", 
    "password": "admin123"
  }'

# 2. Login admin
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@agpsbank.com",
    "password": "admin123"
  }'

# 3. Get all customers (use admin token)
curl -X GET http://localhost:8080/admin/api/customers \
  -H "Authorization: Bearer <admin-jwt-token>"

# 4. Approve customer
curl -X PUT http://localhost:8080/admin/api/customers/{customerId}/status \
  -H "Authorization: Bearer <admin-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{"status": "APPROVED"}'

# 5. Approve KYC
curl -X PUT http://localhost:8080/admin/api/kyc/{documentId}/status \
  -H "Authorization: Bearer <admin-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "APPROVED",
    "remarks": "All documents verified successfully"
  }'
```

## 🔐 JWT Token Usage

### Getting Tokens
```javascript
// Customer login response
{
  "success": true,
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "userDetails": {
    "userId": "uuid",
    "email": "user@example.com",
    "role": "CUSTOMER",
    "firstName": "John",
    "lastName": "Doe"
  }
}
```

### Using Tokens
```bash
# Include in Authorization header
curl -H "Authorization: Bearer <your-jwt-token>" \
     http://localhost:8080/customers/{customerId}
```

## 📊 API Documentation

### Swagger UI Groups
Access http://localhost:8080/swagger-ui.html and explore:

1. **🔐 Authentication Service** (`/auth/**`)
   - POST `/auth/login` - Login
   - POST `/auth/validate-token` - Validate JWT
   - POST `/auth/admin/register` - Admin registration

2. **👤 Customer Service** (`/customers/**`, `/customer-api/**`) 
   - POST `/customers/register` - Customer registration
   - GET `/customers/{id}` - Get customer details
   - PUT `/customers/{id}` - Update customer

3. **👨‍💼 Admin Service** (`/admin/**`)
   - GET `/admin/api/dashboard/stats` - Dashboard statistics
   - GET `/admin/api/customers` - List all customers
   - PUT `/admin/api/customers/{id}/status` - Update customer status
   - GET `/admin/api/kyc` - List KYC documents
   - PUT `/admin/api/kyc/{id}/status` - Update KYC status

4. **📄 KYC Service** (`/kyc/**`)
   - POST `/kyc/api/upload` - Upload documents
   - GET `/kyc/api/all` - Get all documents
   - GET `/kyc/api/{id}` - Get document by ID

5. **🏦 Account Service** (`/account-api/**`)
   - Account operations and transactions

6. **❤️ Health & Monitoring** (`/health/**`)
   - Service health checks and monitoring

## 🔧 Configuration

### JWT Configuration
```properties
# auth-service/src/main/resources/application.properties
jwt.secret=mySecretKey12345678901234567890123456789012345678901234567890
jwt.expiration=86400000
```

### Database Configuration (All Services)
```properties
spring.datasource.url=jdbc:oracle:thin:@localhost:1521:FREE
spring.datasource.username=system
spring.datasource.password=system
spring.jpa.hibernate.ddl-auto=create-drop
```

### CORS Configuration
```properties
# API Gateway allows all origins for development
cors.allowed-origins=*
cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS
cors.allowed-headers=*
```

## 🚨 Troubleshooting

### Common Issues

#### Service Discovery Problems
```bash
# Check Eureka Server
curl http://localhost:8761/eureka/apps

# Restart services in order
./stop-services.sh
./start-services.sh
```

#### Database Connection Issues
```sql
-- Test Oracle connection
sqlplus system/system@localhost:1521/FREE
SELECT 1 FROM DUAL;
```

#### JWT Token Issues
```bash
# Validate token
curl -X POST http://localhost:8080/auth/validate-token \
  -H "Content-Type: application/json" \
  -d '{"token": "your-jwt-token"}'
```

#### File Upload Issues
- Check file size < 5MB
- Ensure JPG/PNG format
- Verify multipart/form-data content type

## 📈 Performance & Monitoring

### Expected Performance
- **Login**: < 1 second
- **Registration**: < 2 seconds  
- **Dashboard Load**: < 1.5 seconds
- **File Upload**: < 5 seconds
- **API Calls**: < 500ms

### Monitoring Tools
- **Eureka Dashboard**: http://localhost:8761
- **Service Health**: http://localhost:8080/health/*
- **Application Logs**: Check console output
- **Database Monitoring**: Oracle Enterprise Manager

## 🎯 Production Deployment

### Environment Variables
```bash
export JWT_SECRET=your-production-secret-key
export DB_URL=jdbc:oracle:thin:@prod-db:1521:PROD
export DB_USERNAME=prod_user
export DB_PASSWORD=prod_password
```

### Docker Deployment
```dockerfile
# Dockerfile for each service
FROM openjdk:17-jdk-slim
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

### Security Considerations
- Use strong JWT secrets (256-bit minimum)
- Enable HTTPS in production
- Implement rate limiting
- Add input validation and sanitization
- Use production database with proper credentials
- Enable security headers

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check this README and TESTING_GUIDE.md
- **API Documentation**: http://localhost:8080/swagger-ui.html
- **Issue Tracking**: Create issues in the repository
- **Email Support**: support@agpsbank.com

## 🎉 Features Completed

✅ **Complete Banking Application**  
✅ **JWT Authentication & Authorization**  
✅ **Admin Panel with Customer Management**  
✅ **KYC Document Upload & Review System**  
✅ **Customer Dashboard with Status Tracking**  
✅ **Real-time Notifications**  
✅ **Comprehensive API Documentation**  
✅ **Complete Testing Guide**  
✅ **Responsive Web UI**  
✅ **Microservices Architecture**  
✅ **Service Discovery with Eureka**  
✅ **API Gateway with Route Protection**  
✅ **Database Integration with Oracle**  
✅ **File Upload with Validation**  
✅ **Role-based Access Control**  

---

**🏦 AGPS Bank - Your Trust, Our Innovation! 💳**