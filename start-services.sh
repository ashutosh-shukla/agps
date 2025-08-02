#!/bin/bash

# SecureBank - Start All Services Script
# This script starts all microservices in the correct order

echo "🏦 Starting SecureBank Microservices..."
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to start a service
start_service() {
    local service_name=$1
    local service_dir=$2
    local port=$3
    
    echo -e "${BLUE}Starting $service_name on port $port...${NC}"
    
    if [ -d "$service_dir" ]; then
        cd "$service_dir"
        mvn spring-boot:run > "../logs/${service_name}.log" 2>&1 &
        echo $! > "../pids/${service_name}.pid"
        cd ..
        echo -e "${GREEN}✓ $service_name started${NC}"
        sleep 10  # Wait for service to start
    else
        echo -e "${RED}✗ Directory $service_dir not found${NC}"
    fi
}

# Function to check if service is running
check_service() {
    local service_name=$1
    local port=$2
    
    if curl -s "http://localhost:$port" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ $service_name is running on port $port${NC}"
    else
        echo -e "${YELLOW}⚠ $service_name may still be starting on port $port${NC}"
    fi
}

# Create directories for logs and PIDs
mkdir -p logs
mkdir -p pids

# Clean up old log files
rm -f logs/*.log
rm -f pids/*.pid

echo "Starting services in order..."
echo

# 1. Start Eureka Server first (service discovery)
start_service "Eureka Server" "eureka-server" "8761"

echo "Waiting for Eureka Server to be ready..."
sleep 30

# 2. Start Auth Service (authentication)
start_service "Auth Service" "auth-service" "8085"

# 3. Start Customer Service (customer management)
start_service "Customer Service" "customer-service" "8081"

# 4. Start Account Service (account operations)
start_service "Account Service" "account-service" "8082"

# 5. Start KYC Service (document management)
start_service "KYC Service" "kyc-services" "8083"

# 6. Start Admin Service (administration)
start_service "Admin Service" "admin-service" "8084"

# 7. Start API Gateway last (routing)
start_service "API Gateway" "apiGateway-service" "8080"

echo
echo "Waiting for all services to fully start..."
sleep 60

echo
echo "🔍 Checking service status..."
echo "=========================="

check_service "Eureka Server" "8761"
check_service "Auth Service" "8085"
check_service "Customer Service" "8081"
check_service "Account Service" "8082"
check_service "KYC Service" "8083"
check_service "Admin Service" "8084"
check_service "API Gateway" "8080"

echo
echo "🌐 Service URLs:"
echo "==============="
echo -e "${BLUE}Eureka Dashboard:${NC} http://localhost:8761"
echo -e "${BLUE}API Gateway:${NC} http://localhost:8080"
echo -e "${BLUE}Auth Service:${NC} http://localhost:8085"
echo
echo "🔐 Authentication URLs:"
echo "======================"
echo -e "${GREEN}Login:${NC} http://localhost:8085/login"
echo -e "${GREEN}Admin Registration:${NC} http://localhost:8085/admin-register"
echo -e "${GREEN}Customer Registration:${NC} http://localhost:8081/customers/register"
echo -e "${GREEN}Dashboard:${NC} http://localhost:8085/home"
echo
echo "🛡️ Protected API Endpoints (via Gateway):"
echo "========================================="
echo -e "${YELLOW}Customer API:${NC} http://localhost:8080/customers/**"
echo -e "${YELLOW}Account API:${NC} http://localhost:8080/account-api/**"
echo -e "${YELLOW}KYC API:${NC} http://localhost:8080/kyc/api/**"
echo -e "${YELLOW}Admin API:${NC} http://localhost:8080/admin/**"
echo
echo "📋 Health Checks:"
echo "================="
echo -e "${BLUE}Auth Health:${NC} http://localhost:8080/health/auth"
echo -e "${BLUE}Customer Health:${NC} http://localhost:8080/health/customer"
echo -e "${BLUE}Account Health:${NC} http://localhost:8080/health/account"
echo -e "${BLUE}KYC Health:${NC} http://localhost:8080/health/kyc"
echo -e "${BLUE}Admin Health:${NC} http://localhost:8080/health/admin"
echo
echo "📝 Logs:"
echo "========"
echo "Service logs are available in the 'logs' directory"
echo "Use 'tail -f logs/<service-name>.log' to view real-time logs"
echo
echo "🛑 To stop all services:"
echo "======================="
echo "Run: ./stop-services.sh"
echo
echo -e "${GREEN}🎉 All services started! Happy Banking! 🏦${NC}"