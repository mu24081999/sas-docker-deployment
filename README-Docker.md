# SAS - Sales Automation Software

This project combines the SAS backend (Node.js/Express) and frontend (React/Vite) applications using Docker for both development and production environments.

## Project Structure

```
SAS/
├── sas-backend/           # Node.js/Express API
│   ├── Dockerfile         # Production backend image
│   ├── Dockerfile.dev     # Development backend image
│   └── .dockerignore
├── sas-frontend/          # React/Vite frontend
│   ├── Dockerfile         # Production frontend image
│   ├── Dockerfile.dev     # Development frontend image
│   ├── nginx.conf         # Nginx configuration
│   └── .dockerignore
├── nginx/                 # Nginx reverse proxy config
│   └── nginx.conf
├── docker-compose.yml     # Development environment
├── docker-compose.prod.yml # Production environment
├── deploy.sh              # Linux/Mac deployment script
├── deploy.bat             # Windows deployment script
├── env.example            # Environment variables template
└── README-Docker.md       # This file
```

## Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose
- Git

## Quick Start

### Development Environment

1. **Clone the repository:**

   ```bash
   git clone <your-repo-url>
   cd SAS
   ```

2. **Set up environment variables:**

   ```bash
   cp env.example .env
   # Edit .env with your configuration
   ```

3. **Start development environment:**

   ```bash
   # Linux/Mac
   ./deploy.sh dev

   # Windows
   deploy.bat
   # Then select option 1
   ```

4. **Access the applications:**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:5000
   - MongoDB: localhost:27017

### Production Environment

1. **Configure production environment:**

   ```bash
   cp env.example .env
   # Edit .env with production values
   ```

2. **Start production environment:**

   ```bash
   # Linux/Mac
   ./deploy.sh prod

   # Windows
   deploy.bat
   # Then select option 2
   ```

3. **Access the application:**
   - Application: http://localhost
   - API: http://localhost/api

## Environment Variables

### Backend (.env)

```env
# Database Configuration
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=your_secure_password_here
MONGO_DATABASE=sas_db

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_here
JWT_LIFETIME=7d

# Application URLs
FRONTEND_APP_URL=http://localhost:5173
API_URL=http://localhost:5000/api/v1

# Node Environment
NODE_ENV=production
PORT=5000
```

### Frontend (sas-frontend/.env)

```env
VITE_API_URL=http://localhost:5000/api/v1
VITE_APP_NAME=SAS - Sales Automation Software
VITE_NODE_ENV=development
```

## Docker Commands

### Development

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and start
docker-compose up --build -d
```

### Production

```bash
# Start production services
docker-compose -f docker-compose.prod.yml up -d

# View logs
docker-compose -f docker-compose.prod.yml logs -f

# Stop services
docker-compose -f docker-compose.prod.yml down
```

## VPS Deployment

### 1. Server Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Logout and login again to apply docker group changes
```

### 2. Deploy Application

```bash
# Clone repository
git clone <your-repo-url>
cd SAS

# Configure environment
cp env.example .env
nano .env  # Edit with production values

# Start production environment
./deploy.sh prod
```

### 3. Configure Domain and SSL (Optional)

1. **Point your domain to the VPS IP**
2. **Update nginx configuration:**

   ```bash
   nano nginx/nginx.conf
   # Uncomment and configure HTTPS section
   # Add your SSL certificates to nginx/ssl/
   ```

3. **Restart nginx:**
   ```bash
   docker-compose -f docker-compose.prod.yml restart nginx
   ```

## Monitoring and Maintenance

### View Logs

```bash
# All services
docker-compose -f docker-compose.prod.yml logs -f

# Specific service
docker-compose -f docker-compose.prod.yml logs -f backend
docker-compose -f docker-compose.prod.yml logs -f frontend
docker-compose -f docker-compose.prod.yml logs -f nginx
```

### Health Checks

```bash
# Check if services are running
docker-compose -f docker-compose.prod.yml ps

# Check application health
curl http://localhost/health
curl http://localhost/api/health
```

### Backup Database

```bash
# Create backup
docker exec sas-mongodb-prod mongodump --out /backup

# Copy backup to host
docker cp sas-mongodb-prod:/backup ./mongodb-backup
```

### Update Application

```bash
# Pull latest changes
git pull

# Rebuild and restart
docker-compose -f docker-compose.prod.yml up --build -d
```

## Troubleshooting

### Common Issues

1. **Port already in use:**

   ```bash
   # Check what's using the port
   sudo netstat -tulpn | grep :80
   sudo netstat -tulpn | grep :5000

   # Kill the process or change ports in docker-compose files
   ```

2. **Permission denied:**

   ```bash
   # Fix file permissions
   sudo chown -R $USER:$USER .
   chmod +x deploy.sh
   ```

3. **MongoDB connection issues:**

   - Check if MongoDB container is running
   - Verify connection string in .env
   - Check MongoDB logs

4. **Frontend not loading:**
   - Check if frontend container is running
   - Verify nginx configuration
   - Check frontend logs

### Useful Commands

```bash
# Clean up Docker resources
docker system prune -a

# Remove all containers and volumes
docker-compose -f docker-compose.prod.yml down -v

# View container resource usage
docker stats

# Access container shell
docker exec -it sas-backend-prod sh
docker exec -it sas-frontend-prod sh
```

## Security Considerations

1. **Change default passwords** in .env file
2. **Use strong JWT secrets**
3. **Enable HTTPS** in production
4. **Configure firewall** to only allow necessary ports
5. **Regular security updates** for Docker images
6. **Monitor logs** for suspicious activity

## Support

For issues and questions:

1. Check the logs first
2. Verify environment configuration
3. Check Docker and Docker Compose versions
4. Review this documentation

## License

This project is licensed under the MIT License.
