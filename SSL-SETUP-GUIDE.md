# SSL Setup Guide for SAS Production

This guide will help you set up HTTPS with SSL certificates for your SAS application in production.

## 🔒 SSL Configuration Overview

Your production setup now includes:

- **HTTPS on port 443** (with HTTP redirect on port 80)
- **Let's Encrypt SSL certificates** (free, auto-renewing)
- **Strong SSL security settings**
- **Security headers** for enhanced protection

## 📋 Prerequisites

1. **Domain Name**: You need a domain name pointing to your VPS
2. **VPS Access**: SSH access to your VPS server
3. **Docker & Docker Compose**: Installed on your VPS
4. **Open Ports**: 80 and 443 must be open on your VPS

## 🚀 Quick Setup

### 1. Configure Environment Variables

```bash
# Edit your .env file
nano .env

# Set these values:
DOMAIN_NAME=your-domain.com
SSL_EMAIL=your-email@example.com
```

### 2. Run SSL Setup Script

```bash
# Linux/Mac
chmod +x ssl-setup.sh
./ssl-setup.sh

# Windows
ssl-setup.bat
```

### 3. Choose Setup Method

The script will ask you to choose:

1. **Self-signed certificate** (for testing)
2. **Let's Encrypt certificate** (for production) ← **Choose this**
3. **Setup renewal only** (if certificates already exist)

## 🔧 Manual Setup (Alternative)

If you prefer to set up SSL manually:

### Step 1: Create SSL Directory

```bash
mkdir -p nginx/ssl
```

### Step 2: Get Let's Encrypt Certificate

```bash
# Start nginx first
docker-compose -f docker-compose.prod.yml up -d nginx

# Get certificate
docker-compose -f docker-compose.prod.yml run --rm certbot

# Copy certificate
docker cp sas-certbot:/etc/letsencrypt/live/your-domain.com/fullchain.pem nginx/ssl/cert.pem
docker cp sas-certbot:/etc/letsencrypt/live/your-domain.com/privkey.pem nginx/ssl/key.pem
```

### Step 3: Start Production

```bash
docker-compose -f docker-compose.prod.yml up -d
```

## 🔄 Certificate Renewal

SSL certificates from Let's Encrypt expire every 90 days. The setup script automatically configures renewal.

### Manual Renewal

```bash
# Renew certificates
docker-compose -f docker-compose.prod.yml run --rm certbot renew

# Copy renewed certificates
docker cp sas-certbot:/etc/letsencrypt/live/your-domain.com/fullchain.pem nginx/ssl/cert.pem
docker cp sas-certbot:/etc/letsencrypt/live/your-domain.com/privkey.pem nginx/ssl/key.pem

# Reload nginx
docker-compose -f docker-compose.prod.yml exec nginx nginx -s reload
```

### Automatic Renewal (Cron)

The setup script adds a cron job to automatically renew certificates every 3 months:

```bash
# Check cron job
crontab -l

# Manual renewal script
./renew-ssl.sh
```

## 🌐 Access Your Application

After SSL setup, your application will be available at:

- **HTTPS**: `https://your-domain.com`
- **HTTP**: `http://your-domain.com` (redirects to HTTPS)
- **API**: `https://your-domain.com/api`

## 🔒 SSL Security Features

Your SSL configuration includes:

- **TLS 1.2 and 1.3** support
- **Strong cipher suites**
- **HSTS headers** (HTTP Strict Transport Security)
- **Security headers** (X-Frame-Options, X-Content-Type-Options, etc.)
- **HTTP to HTTPS redirect**

## 🐛 Troubleshooting

### Certificate Not Working

```bash
# Check certificate files
ls -la nginx/ssl/

# Check nginx logs
docker-compose -f docker-compose.prod.yml logs nginx

# Test SSL configuration
openssl s_client -connect your-domain.com:443
```

### Let's Encrypt Rate Limits

If you hit rate limits:

- Wait 1 hour before retrying
- Use staging environment for testing: `--staging` flag

### Domain Not Resolving

```bash
# Check DNS
nslookup your-domain.com
dig your-domain.com

# Check if domain points to your VPS IP
ping your-domain.com
```

### Port Issues

```bash
# Check if ports are open
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443

# Check firewall
sudo ufw status
```

## 📝 Environment Variables

Required environment variables for SSL:

```env
# SSL Configuration
DOMAIN_NAME=your-domain.com
SSL_EMAIL=your-email@example.com

# Database Configuration
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=your_secure_password
MONGO_DATABASE=sas_db

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key
JWT_LIFETIME=7d

# Application URLs (update for production)
FRONTEND_APP_URL=https://your-domain.com
API_URL=https://your-domain.com/api
```

## 🔧 Advanced Configuration

### Custom SSL Certificate

If you have your own SSL certificate:

1. Place your certificate files in `nginx/ssl/`:

   - `cert.pem` (certificate)
   - `key.pem` (private key)

2. Update nginx configuration if needed

### Multiple Domains

To support multiple domains, update the nginx configuration:

```nginx
server {
    listen 443 ssl http2;
    server_name domain1.com domain2.com;
    # ... rest of configuration
}
```

### SSL Grade Optimization

For better SSL grades:

1. Use strong cipher suites (already configured)
2. Enable HSTS (already configured)
3. Use HTTP/2 (already configured)
4. Consider using a CDN for additional security

## 📊 Monitoring SSL

### Check Certificate Status

```bash
# Check certificate expiration
openssl x509 -in nginx/ssl/cert.pem -text -noout | grep "Not After"

# Test SSL grade
curl -I https://your-domain.com
```

### Monitor Renewal

```bash
# Check renewal logs
docker-compose -f docker-compose.prod.yml logs certbot

# Test renewal (dry run)
docker-compose -f docker-compose.prod.yml run --rm certbot renew --dry-run
```

## 🆘 Support

If you encounter issues:

1. Check the logs: `docker-compose -f docker-compose.prod.yml logs`
2. Verify domain DNS settings
3. Ensure ports 80 and 443 are open
4. Check firewall configuration
5. Verify SSL certificate files exist

## 🎉 Success!

Once SSL is set up, your SAS application will be:

- ✅ Accessible via HTTPS
- ✅ Secure with valid SSL certificate
- ✅ Auto-renewing certificates
- ✅ Redirecting HTTP to HTTPS
- ✅ Protected with security headers

Your application is now production-ready with enterprise-grade SSL security! 🚀
