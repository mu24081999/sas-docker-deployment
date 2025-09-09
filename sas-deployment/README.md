# SAS - Sales Automation Software

A comprehensive full-stack sales automation application built with React frontend and Node.js backend, containerized with Docker for easy deployment and development.

## 🚀 Project Structure

```
SAS/
├── backend/                 # Node.js/Express API Server
│   ├── controllers/         # Route controllers
│   ├── models/             # MongoDB models
│   ├── routes/             # API routes
│   ├── middleware/         # Custom middleware
│   ├── database/           # Database connection
│   ├── errors/             # Error handling
│   ├── validators/         # Input validation
│   ├── dump/               # Database dumps
│   ├── Dockerfile          # Production backend image
│   ├── Dockerfile.dev      # Development backend image
│   └── package.json        # Backend dependencies
├── frontend/               # React/Vite Frontend
│   ├── src/
│   │   ├── components/     # React components
│   │   ├── pages/          # Page components
│   │   ├── contexts/       # React contexts
│   │   ├── hooks/          # Custom hooks
│   │   ├── api/            # API client
│   │   └── utils/          # Utility functions
│   ├── public/             # Static assets
│   ├── Dockerfile          # Production frontend image
│   ├── Dockerfile.dev      # Development frontend image
│   ├── nginx.conf          # Nginx configuration
│   └── package.json        # Frontend dependencies
├── nginx/                  # Nginx reverse proxy config
├── docker-compose.yml      # Development environment
├── docker-compose.prod.yml # Production environment
├── package.json            # Root project scripts
├── deploy.sh               # Linux/Mac deployment script
├── deploy.bat              # Windows deployment script
└── README.md               # This file
```

## 🛠️ Tech Stack

### Backend

- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM
- **JWT** - Authentication
- **bcryptjs** - Password hashing
- **Joi** - Input validation
- **Helmet** - Security headers
- **CORS** - Cross-origin resource sharing

### Frontend

- **React 19** - UI library
- **Vite** - Build tool
- **Tailwind CSS** - Styling
- **React Router** - Routing
- **React Query** - Data fetching
- **React Hook Form** - Form handling
- **Axios** - HTTP client
- **Lucide React** - Icons

### DevOps

- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Nginx** - Reverse proxy
- **MongoDB** - Database container

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ and npm
- Docker and Docker Compose
- Git

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd SAS
```

### 2. Install Dependencies

```bash
# Install all dependencies (root, backend, frontend)
npm run install:all

# Or install individually
npm install
cd backend && npm install
cd ../frontend && npm install
```

### 3. Environment Setup

```bash
# Copy environment files
cp env.example .env
cp backend/env.example backend/.env
cp frontend/env.example frontend/.env

# Edit the .env files with your configuration
```

### 4. Development Options

#### Option A: Docker Development (Recommended)

```bash
# Start all services with Docker
./deploy.sh dev          # Linux/Mac
deploy.bat               # Windows (select option 1)

# Access:
# Frontend: http://localhost:5173
# Backend: http://localhost:5000
# MongoDB: localhost:27017
```

#### Option B: Local Development

```bash
# Make sure MongoDB is running locally
# Start both backend and frontend
./deploy.sh dev-local    # Linux/Mac
deploy.bat               # Windows (select option 2)

# Or start individually:
# Terminal 1: Backend
cd backend && npm run dev

# Terminal 2: Frontend
cd frontend && npm run dev
```

## 🐳 Docker Commands

### Development

```bash
# Start development environment
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
# Start production environment
docker-compose -f docker-compose.prod.yml up -d

# View logs
docker-compose -f docker-compose.prod.yml logs -f

# Stop services
docker-compose -f docker-compose.prod.yml down
```

## 📦 Available Scripts

### Root Level Scripts

```bash
npm run dev              # Start both backend and frontend locally
npm run dev:backend      # Start only backend locally
npm run dev:frontend     # Start only frontend locally
npm run build            # Build frontend for production
npm run start            # Start backend in production mode
npm run install:all      # Install all dependencies
npm run docker:dev       # Start development with Docker
npm run docker:prod      # Start production with Docker
npm run docker:stop      # Stop all Docker services
npm run docker:logs      # View Docker logs
npm run clean            # Clean up Docker resources
```

### Backend Scripts

```bash
cd backend
npm run dev              # Start with nodemon
npm start                # Start in production
```

### Frontend Scripts

```bash
cd frontend
npm run dev              # Start Vite dev server
npm run build            # Build for production
npm run preview          # Preview production build
npm run lint             # Run ESLint
```

## 🌐 VPS Deployment

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

# Logout and login again
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

### 3. Configure Domain (Optional)

1. Point your domain to the VPS IP
2. Update nginx configuration for your domain
3. Add SSL certificates if needed

## 🔧 Environment Variables

### Root (.env)

```env
# Database Configuration
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=your_secure_password
MONGO_DATABASE=sas_db

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key
JWT_LIFETIME=7d

# Application URLs
FRONTEND_APP_URL=http://localhost:5173
API_URL=http://localhost:5000/api/v1

# Node Environment
NODE_ENV=production
```

### Backend (backend/.env)

```env
MONGO_URI=mongodb://admin:password@localhost:27017/sas_db?authSource=admin
JWT_SECRET=your_super_secret_jwt_key
JWT_LIFETIME=7d
FRONTEND_APP_URL=http://localhost:5173
PORT=5000
NODE_ENV=development
```

### Frontend (frontend/.env)

```env
VITE_API_URL=http://localhost:5000/api/v1
VITE_APP_NAME=SAS - Sales Automation Software
VITE_NODE_ENV=development
```

## 📊 Monitoring and Maintenance

### Health Checks

```bash
# Check if services are running
docker-compose ps

# Check application health
curl http://localhost/health
curl http://localhost/api/health
```

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f nginx
```

### Backup Database

```bash
# Create backup
docker exec sas-mongodb mongodump --out /backup

# Copy backup to host
docker cp sas-mongodb:/backup ./mongodb-backup
```

### Update Application

```bash
# Pull latest changes
git pull

# Rebuild and restart
docker-compose up --build -d
```

## 🔒 Security Features

- **JWT Authentication** - Secure token-based auth
- **Password Hashing** - bcryptjs for password security
- **CORS Protection** - Configured cross-origin policies
- **Rate Limiting** - API request rate limiting
- **Security Headers** - Helmet.js security headers
- **Input Validation** - Joi schema validation
- **XSS Protection** - Cross-site scripting prevention
- **Non-root Containers** - Security best practices

## 🐛 Troubleshooting

### Common Issues

1. **Port already in use:**

   ```bash
   sudo netstat -tulpn | grep :80
   sudo netstat -tulpn | grep :5000
   # Kill the process or change ports
   ```

2. **Permission denied:**

   ```bash
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
docker-compose down -v

# View container resource usage
docker stats

# Access container shell
docker exec -it sas-backend sh
docker exec -it sas-frontend sh
```

## 📝 API Documentation

### Authentication Endpoints

- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/forgot-password` - Forgot password
- `POST /api/v1/auth/reset-password` - Reset password

### Sales Endpoints

- `GET /api/v1/sales` - Get all sales
- `POST /api/v1/sales` - Create new sale
- `PUT /api/v1/sales/:id` - Update sale
- `DELETE /api/v1/sales/:id` - Delete sale

### Leads Endpoints

- `GET /api/v1/leads` - Get all leads
- `POST /api/v1/leads` - Create new lead
- `PUT /api/v1/leads/:id` - Update lead
- `DELETE /api/v1/leads/:id` - Delete lead

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:

1. Check the troubleshooting section
2. Review the logs
3. Check environment configuration
4. Create an issue in the repository

## 🎯 Roadmap

- [ ] Add Redis for session management
- [ ] Implement real-time notifications
- [ ] Add comprehensive testing
- [ ] Implement CI/CD pipeline
- [ ] Add monitoring and analytics
- [ ] Mobile app development
- [ ] Advanced reporting features

---

**Happy Coding! 🚀**
