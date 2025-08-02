#!/bin/bash

# SecureBank - Stop All Services Script
# This script stops all microservices gracefully

echo "🛑 Stopping SecureBank Microservices..."
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to stop a service
stop_service() {
    local service_name=$1
    
    if [ -f "pids/${service_name}.pid" ]; then
        local pid=$(cat "pids/${service_name}.pid")
        echo -e "${BLUE}Stopping $service_name (PID: $pid)...${NC}"
        
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            sleep 5
            
            # Force kill if still running
            if kill -0 "$pid" 2>/dev/null; then
                echo -e "${YELLOW}Force stopping $service_name...${NC}"
                kill -9 "$pid"
            fi
            
            echo -e "${GREEN}✓ $service_name stopped${NC}"
        else
            echo -e "${YELLOW}⚠ $service_name was not running${NC}"
        fi
        
        rm -f "pids/${service_name}.pid"
    else
        echo -e "${YELLOW}⚠ No PID file found for $service_name${NC}"
    fi
}

# Stop services in reverse order
echo "Stopping services..."
echo

stop_service "API Gateway"
stop_service "Admin Service"
stop_service "KYC Service"
stop_service "Account Service"
stop_service "Customer Service"
stop_service "Auth Service"
stop_service "Eureka Server"

# Clean up any remaining Maven processes
echo
echo -e "${BLUE}Cleaning up any remaining Maven processes...${NC}"
pkill -f "spring-boot:run" 2>/dev/null || true

# Clean up PID directory
rm -rf pids

echo
echo -e "${GREEN}🎉 All services stopped successfully!${NC}"
echo
echo "📝 Logs are still available in the 'logs' directory"
echo "🚀 To start services again, run: ./start-services.sh"