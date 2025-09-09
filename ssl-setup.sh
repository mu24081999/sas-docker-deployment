#!/bin/bash

# SSL Setup Script for SAS Production
# This script helps set up SSL certificates with Let's Encrypt

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

# Check if .env file exists
check_env() {
    if [ ! -f .env ]; then
        print_error ".env file not found. Please create it first."
        print_status "Copy env.example to .env and configure your settings:"
        print_status "cp env.example .env"
        print_status "nano .env"
        exit 1
    fi
    print_status ".env file found."
}

# Load environment variables
load_env() {
    export $(cat .env | grep -v '^#' | xargs)
    print_status "Environment variables loaded."
}

# Check if domain is configured
check_domain() {
    if [ -z "$DOMAIN_NAME" ] || [ "$DOMAIN_NAME" = "your-domain.com" ]; then
        print_error "Domain name not configured in .env file."
        print_status "Please set DOMAIN_NAME in your .env file to your actual domain."
        exit 1
    fi
    
    if [ -z "$SSL_EMAIL" ] || [ "$SSL_EMAIL" = "your-email@example.com" ]; then
        print_error "SSL email not configured in .env file."
        print_status "Please set SSL_EMAIL in your .env file to your actual email."
        exit 1
    fi
    
    print_status "Domain: $DOMAIN_NAME"
    print_status "Email: $SSL_EMAIL"
}

# Create SSL directory
create_ssl_dir() {
    print_status "Creating SSL directory..."
    mkdir -p nginx/ssl
    print_status "SSL directory created."
}

# Generate self-signed certificate for initial setup
generate_self_signed() {
    print_status "Generating self-signed certificate for initial setup..."
    
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout nginx/ssl/key.pem \
        -out nginx/ssl/cert.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=$DOMAIN_NAME"
    
    print_status "Self-signed certificate generated."
}

# Get Let's Encrypt certificate
get_letsencrypt_cert() {
    print_status "Getting Let's Encrypt certificate..."
    
    # Stop nginx if running
    docker-compose -f docker-compose.prod.yml stop nginx 2>/dev/null || true
    
    # Start nginx without SSL first
    print_status "Starting nginx for certificate challenge..."
    docker-compose -f docker-compose.prod.yml up -d nginx
    
    # Wait for nginx to start
    sleep 10
    
    # Get certificate
    print_status "Requesting SSL certificate from Let's Encrypt..."
    docker-compose -f docker-compose.prod.yml run --rm certbot
    
    # Copy certificate to nginx ssl directory
    print_status "Copying certificate to nginx ssl directory..."
    docker cp sas-certbot:/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem nginx/ssl/cert.pem
    docker cp sas-certbot:/etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem nginx/ssl/key.pem
    
    print_status "SSL certificate obtained and configured."
}

# Setup certificate renewal
setup_renewal() {
    print_status "Setting up certificate renewal..."
    
    # Create renewal script
    cat > renew-ssl.sh << 'EOF'
#!/bin/bash
# SSL Certificate Renewal Script

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Renew certificate
docker-compose -f docker-compose.prod.yml run --rm certbot renew

# Copy renewed certificate
docker cp sas-certbot:/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem nginx/ssl/cert.pem
docker cp sas-certbot:/etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem nginx/ssl/key.pem

# Reload nginx
docker-compose -f docker-compose.prod.yml exec nginx nginx -s reload

echo "SSL certificate renewed successfully"
EOF

    chmod +x renew-ssl.sh
    
    # Add to crontab
    print_status "Adding renewal to crontab (runs every 3 months)..."
    (crontab -l 2>/dev/null; echo "0 3 1 */3 * $(pwd)/renew-ssl.sh") | crontab -
    
    print_status "Certificate renewal configured."
}

# Start production with SSL
start_production() {
    print_status "Starting production environment with SSL..."
    docker-compose -f docker-compose.prod.yml up -d
    print_status "Production environment started with SSL!"
    print_status "Your application is now available at: https://$DOMAIN_NAME"
}

# Main function
main() {
    print_status "SAS SSL Setup Script"
    echo ""
    
    check_env
    load_env
    check_domain
    create_ssl_dir
    
    echo ""
    print_status "Choose SSL setup method:"
    echo "1. Generate self-signed certificate (for testing)"
    echo "2. Get Let's Encrypt certificate (for production)"
    echo "3. Setup certificate renewal only"
    echo ""
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1)
            generate_self_signed
            print_warning "Self-signed certificate generated. This is for testing only."
            print_status "To get a real SSL certificate, run this script again and choose option 2."
            ;;
        2)
            get_letsencrypt_cert
            setup_renewal
            start_production
            ;;
        3)
            setup_renewal
            print_status "Certificate renewal configured."
            ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
