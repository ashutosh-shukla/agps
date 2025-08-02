# SecureBank - Complete Banking Application with JWT Authentication

A comprehensive microservices-based banking application with JWT authentication, role-based access control, and modern web interface.

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

## 🚀 Services Overview

### 1. Eureka Server (Port 8761)
- Service discovery and registration
- All microservices register here

### 2. API Gateway (Port 8080)
- Entry point for all requests
- JWT token validation
- Route protection with role-based access
- Load balancing

### 3. Auth Service (Port 8085)
- JWT token generation and validation
- User authentication (Customer + Admin)
- Admin registration
- Modern login and registration pages

### 4. Customer Service (Port 8081)
- Customer account management
- Customer registration
- Password management
- Credential validation for auth service

### 5. Account Service (Port 8082)
- Banking operations (deposit, withdrawal, transfer)
- Account balance management
- Transaction history

### 6. KYC Service (Port 8083)
- Know Your Customer document management
- Document verification

### 7. Admin Service (Port 8084)
- Administrative functions
- Customer oversight
- System management

## 🔐 Authentication Flow

### Customer Authentication
1. Customer registers via `/customers/register`
2. Customer logs in via `/login` (Auth Service)
3. Auth Service validates credentials with Customer Service
4. JWT token generated with customer role
5. Token used for protected route access

### Admin Authentication
1. Admin registers via `/admin-register` (Auth Service)
2. Admin logs in via `/login` (Auth Service)
3. JWT token generated with ADMIN role
4. Token provides access to admin-only routes

## 🛠️ Setup Instructions

### Prerequisites
- Java 17
- Oracle Database (localhost:1521/FREE)
- Maven
- Docker (optional)

### Database Setup
```sql
-- Oracle Database should be running on localhost:1521/FREE
-- Username: system
-- Password: system
```

### Running the Services

1. **Start Eureka Server**
```bash
cd eureka-server
mvn spring-boot:run
```

2. **Start Auth Service**
```bash
cd auth-service
mvn spring-boot:run
```

3. **Start Customer Service**
```bash
cd customer-service
mvn spring-boot:run
```

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

## 🌐 Access URLs

### Authentication Pages
- **Login**: http://localhost:8085/login
- **Admin Registration**: http://localhost:8085/admin-register
- **Customer Registration**: http://localhost:8081/customers/register
- **Dashboard**: http://localhost:8085/home

### Service Health Checks
- **Auth Service**: http://localhost:8080/health/auth
- **Customer Service**: http://localhost:8080/health/customer
- **Account Service**: http://localhost:8080/health/account
- **KYC Service**: http://localhost:8080/health/kyc
- **Admin Service**: http://localhost:8080/health/admin

### Protected Routes (via API Gateway)
- **Customer Operations**: http://localhost:8080/customers/**
- **Account Operations**: http://localhost:8080/account-api/**
- **KYC Operations**: http://localhost:8080/kyc/api/**
- **Admin Operations**: http://localhost:8080/admin/** (Admin role required)

## 🔑 JWT Token Usage

### Getting a Token
1. Register as customer or admin
2. Login via `/login` page
3. Token is automatically stored in localStorage
4. Token included in Authorization header for API calls

### Token Format
```
Authorization: Bearer <your-jwt-token>
```

### Token Claims
```json
{
  "userId": "user-uuid",
  "email": "user@example.com",
  "role": "CUSTOMER|ADMIN",
  "firstName": "John",
  "lastName": "Doe",
  "iat": 1635724800,
  "exp": 1635811200
}
```

## 👥 User Roles

### CUSTOMER Role
- Access to customer service endpoints
- Account management
- KYC document upload
- Transaction operations

### ADMIN Role
- All customer permissions
- Administrative functions
- Customer oversight
- System management

## 🖥️ User Interface

### Modern Features
- Responsive design
- Beautiful gradient backgrounds
- Loading animations
- Form validation
- Role-based navigation
- Success/Error messaging

### Pages
1. **Login Page**: Universal login for customers and admins
2. **Admin Registration**: Admin account creation
3. **Customer Registration**: Customer account creation
4. **Dashboard**: Role-based home page with service links

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
```

## 🚀 Usage Examples

### 1. Register as Admin
```
GET http://localhost:8085/admin-register
```

### 2. Register as Customer
```
GET http://localhost:8081/customers/register
```

### 3. Login (Customer or Admin)
```
GET http://localhost:8085/login
```

### 4. Access Protected Customer Endpoint
```bash
curl -H "Authorization: Bearer <token>" \
     http://localhost:8080/customers/{customerId}
```

### 5. Access Admin-Only Endpoint
```bash
curl -H "Authorization: Bearer <admin-token>" \
     http://localhost:8080/admin/dashboard
```

## 🛡️ Security Features

1. **JWT Token Authentication**
   - Stateless authentication
   - Secure token generation
   - Token expiration handling

2. **Role-Based Access Control**
   - Route-level protection
   - Role validation in API Gateway
   - Admin-only endpoints

3. **Password Security**
   - BCrypt encryption
   - Password validation
   - Secure credential storage

4. **API Gateway Security**
   - Centralized authentication
   - Token validation
   - Request filtering

## 🐛 Troubleshooting

### Common Issues

1. **Service Discovery Issues**
   - Ensure Eureka Server is running first
   - Check service registration in Eureka dashboard

2. **Database Connection**
   - Verify Oracle DB is running
   - Check connection credentials

3. **JWT Token Issues**
   - Ensure JWT secret is consistent across services
   - Check token expiration
   - Verify Authorization header format

4. **CORS Issues**
   - CORS is configured in API Gateway
   - Check allowed origins in configuration

### Port Conflicts
If ports are in use, update `application.properties` files:
```properties
server.port=<new-port>
```

## 📝 API Documentation

### Auth Service Endpoints
- `POST /auth/login` - User login
- `POST /auth/validate-token` - Token validation
- `POST /auth/admin/register` - Admin registration

### Customer Service Endpoints
- `POST /customers/register` - Customer registration
- `POST /customers/validate-credentials` - Credential validation
- `GET /customers/{id}` - Get customer details
- `PUT /customers/{id}` - Update customer

### Protected Routes
All routes through API Gateway require JWT token except:
- `/auth/**`
- `/customers/register`
- `/customers/validate-credentials`
- Health check endpoints

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the troubleshooting section

---

**Happy Banking! 🏦💳**