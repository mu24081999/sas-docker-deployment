#!/bin/bash

# SAS - Sales Automation Software Deployment Script
# This script helps deploy the unified SAS application to a VPS server

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

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_status "Docker and Docker Compose are installed."
}

# Check if .env file exists
check_env() {
    if [ ! -f .env ]; then
        print_warning ".env file not found. Creating from example..."
        cp env.example .env
        print_warning "Please edit .env file with your production values before continuing."
        read -p "Press Enter to continue after editing .env file..."
    fi
    print_status ".env file found."
}

# Build and start development environment
dev_deploy() {
    print_status "Starting development environment..."
    docker-compose down --remove-orphans
    docker-compose up --build -d
    print_status "Development environment started!"
    print_status "Frontend: http://localhost:5173"
    print_status "Backend API: http://localhost:5000"
    print_status "MongoDB: localhost:27017"
}

# Build and start production environment
prod_deploy() {
    print_status "Starting production environment..."
    docker-compose -f docker-compose.prod.yml down --remove-orphans
    docker-compose -f docker-compose.prod.yml up --build -d
    print_status "Production environment started!"
    print_status "Application: http://localhost"
    print_status "API: http://localhost/api"
}

# Stop all services
stop_services() {
    print_status "Stopping all services..."
    docker-compose down --remove-orphans
    docker-compose -f docker-compose.prod.yml down --remove-orphans
    print_status "All services stopped."
}

# Show logs
show_logs() {
    if [ "$1" = "prod" ]; then
        docker-compose -f docker-compose.prod.yml logs -f
    else
        docker-compose logs -f
    fi
}

# Clean up Docker resources
cleanup() {
    print_status "Cleaning up Docker resources..."
    docker system prune -f
    docker volume prune -f
    print_status "Cleanup completed."
}

# Show help
show_help() {
    echo "SAS - Sales Automation Software Deployment Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  dev         Start development environment (Docker)"
    echo "  dev-local   Start development environment (Local)"
    echo "  prod        Start production environment"
    echo "  stop        Stop all services"
    echo "  logs        Show logs (add 'prod' for production logs)"
    echo "  cleanup     Clean up Docker resources"
    echo "  install     Install all dependencies"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 dev        # Start development with Docker"
    echo "  $0 dev-local  # Start development locally"
    echo "  $0 prod       # Start production"
    echo "  $0 logs       # Show development logs"
    echo "  $0 logs prod  # Show production logs"
    echo "  $0 install    # Install all dependencies"
}

# Install all dependencies
install_deps() {
    print_status "Installing all dependencies..."
    npm run install:all
    print_status "All dependencies installed!"
}

# Start local development
dev_local() {
    print_status "Starting local development environment..."
    print_status "Make sure MongoDB is running locally on port 27017"
    print_status "Starting backend and frontend concurrently..."
    npm run dev
}

# Main script logic
main() {
    case "${1:-help}" in
        "dev")
            check_docker
            check_env
            dev_deploy
            ;;
        "dev-local")
            install_deps
            dev_local
            ;;
        "prod")
            check_docker
            check_env
            prod_deploy
            ;;
        "stop")
            stop_services
            ;;
        "logs")
            show_logs "$2"
            ;;
        "cleanup")
            cleanup
            ;;
        "install")
            install_deps
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Run main function with all arguments
main "$@"
