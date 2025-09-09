#!/bin/bash

# SAS VPS Deployment Script
# This script helps deploy the complete SAS application to a VPS server

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required files exist
check_files() {
    print_status "Checking required files..."
    
    local missing_files=()
    
    # Check backend files
    if [ ! -f "backend/Dockerfile" ]; then
        missing_files+=("backend/Dockerfile")
    fi
    if [ ! -f "backend/Dockerfile.dev" ]; then
        missing_files+=("backend/Dockerfile.dev")
    fi
    if [ ! -f "backend/.dockerignore" ]; then
        missing_files+=("backend/.dockerignore")
    fi
    
    # Check frontend files
    if [ ! -f "frontend/Dockerfile" ]; then
        missing_files+=("frontend/Dockerfile")
    fi
    if [ ! -f "frontend/Dockerfile.dev" ]; then
        missing_files+=("frontend/Dockerfile.dev")
    fi
    if [ ! -f "frontend/.dockerignore" ]; then
        missing_files+=("frontend/.dockerignore")
    fi
    if [ ! -f "frontend/nginx.conf" ]; then
        missing_files+=("frontend/nginx.conf")
    fi
    
    # Check root files
    if [ ! -f "docker-compose.yml" ]; then
        missing_files+=("docker-compose.yml")
    fi
    if [ ! -f "docker-compose.prod.yml" ]; then
        missing_files+=("docker-compose.prod.yml")
    fi
    if [ ! -f "env.example" ]; then
        missing_files+=("env.example")
    fi
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        print_error "Missing required files:"
        for file in "${missing_files[@]}"; do
            echo "  - $file"
        done
        print_error "Please run this script from the project root directory with all files present."
        exit 1
    fi
    
    print_status "All required files found!"
}

# Create deployment package
create_package() {
    print_status "Creating deployment package..."
    
    # Create deployment directory
    rm -rf sas-deployment
    mkdir -p sas-deployment
    
    # Copy all necessary files
    cp -r backend sas-deployment/
    cp -r frontend sas-deployment/
    cp -r nginx sas-deployment/
    cp docker-compose.yml sas-deployment/
    cp docker-compose.prod.yml sas-deployment/
    cp env.example sas-deployment/
    cp deploy.sh sas-deployment/
    cp README.md sas-deployment/
    cp .gitignore sas-deployment/
    
    # Create deployment instructions
    cat > sas-deployment/DEPLOYMENT_INSTRUCTIONS.md << 'EOF'
# VPS Deployment Instructions

## Quick Deploy

1. **Upload files to VPS:**
   ```bash
   # Upload the entire sas-deployment folder to your VPS
   scp -r sas-deployment/ user@your-vps-ip:/root/
   ```

2. **SSH into your VPS:**
   ```bash
   ssh user@your-vps-ip
   cd /root/sas-deployment
   ```

3. **Set up environment:**
   ```bash
   cp env.example .env
   nano .env  # Edit with your production values
   ```

4. **Deploy:**
   ```bash
   # For development
   docker compose up --build -d
   
   # For production
   docker compose -f docker-compose.prod.yml up --build -d
   ```

## Access Points
- Frontend: http://your-vps-ip:5173 (dev) or http://your-vps-ip (prod)
- Backend API: http://your-vps-ip:5000
- MongoDB: your-vps-ip:27017

## Troubleshooting
- Check logs: `docker compose logs -f`
- Check status: `docker compose ps`
- Stop services: `docker compose down`
EOF

    print_status "Deployment package created in 'sas-deployment' directory"
}

# Show deployment instructions
show_instructions() {
    print_status "Deployment package ready!"
    echo ""
    echo "To deploy to your VPS:"
    echo ""
    echo "1. Upload the sas-deployment folder to your VPS:"
    echo "   scp -r sas-deployment/ user@your-vps-ip:/root/"
    echo ""
    echo "2. SSH into your VPS:"
    echo "   ssh user@your-vps-ip"
    echo "   cd /root/sas-deployment"
    echo ""
    echo "3. Set up environment:"
    echo "   cp env.example .env"
    echo "   nano .env  # Edit with your production values"
    echo ""
    echo "4. Deploy:"
    echo "   docker compose up --build -d"
    echo ""
    echo "Access your application at:"
    echo "  Frontend: http://your-vps-ip:5173"
    echo "  Backend: http://your-vps-ip:5000"
}

# Main function
main() {
    print_status "SAS VPS Deployment Package Creator"
    echo ""
    
    check_files
    create_package
    show_instructions
}

# Run main function
main "$@"
