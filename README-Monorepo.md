# SAS Application - Monorepo Setup

This project has been restructured as a monorepo with shared dependencies and optimized Docker configuration.

## Project Structure

```
sas-docker-deployment/
├── package.json                 # Root package.json with workspace configuration
├── frontend/                    # React frontend application
│   ├── package.json            # Frontend-specific dependencies
│   ├── Dockerfile              # Production frontend build
│   ├── Dockerfile.dev          # Development frontend build
│   └── src/                    # Frontend source code
├── backend/                     # Node.js backend API
│   ├── package.json            # Backend-specific dependencies
│   ├── Dockerfile              # Production backend build
│   ├── Dockerfile.dev          # Development backend build
│   └── src/                    # Backend source code
├── docker-compose.yml          # Development environment
├── docker-compose.prod.yml     # Production environment
└── .dockerignore              # Docker ignore file
```

## Features

- **Shared Dependencies**: Both frontend and backend share the same `node_modules` directory
- **Workspace Configuration**: Uses npm workspaces for efficient dependency management
- **Optimized Docker Builds**: Multi-stage builds with shared context
- **Development & Production**: Separate configurations for both environments
- **Concurrent Scripts**: Run both frontend and backend simultaneously

## Getting Started

### Prerequisites

- Node.js >= 20.0.0
- npm >= 10.0.0
- Docker and Docker Compose

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd sas-docker-deployment
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   # Copy environment files
   cp env.example .env
   cp backend/env.example backend/.env
   cp frontend/env.example frontend/.env
   ```

### Development

#### Option 1: Using Docker (Recommended)

```bash
# Start all services in development mode
npm run docker:dev

# Or using docker-compose directly
docker-compose up --build
```

#### Option 2: Local Development

```bash
# Install all dependencies
npm run install:all

# Start both frontend and backend concurrently
npm run dev

# Or start them separately
npm run dev:frontend  # Frontend on http://localhost:5173
npm run dev:backend   # Backend on http://localhost:5000
```

### Production

```bash
# Build and start production containers
npm run docker:prod

# Or using docker-compose directly
docker-compose -f docker-compose.prod.yml up --build
```

## Available Scripts

### Root Level Scripts

- `npm run dev` - Start both frontend and backend in development mode
- `npm run build` - Build both frontend and backend for production
- `npm run start` - Start both frontend and backend in production mode
- `npm run docker:dev` - Start development environment with Docker
- `npm run docker:prod` - Start production environment with Docker
- `npm run clean` - Clean all node_modules and build artifacts

### Frontend Scripts

- `npm run dev:frontend` - Start frontend development server
- `npm run build:frontend` - Build frontend for production
- `npm run start:frontend` - Start frontend production server

### Backend Scripts

- `npm run dev:backend` - Start backend development server
- `npm run build:backend` - Build backend for production
- `npm run start:backend` - Start backend production server

## Docker Configuration

### Development Environment

- **Frontend**: React with Vite dev server (port 5173)
- **Backend**: Node.js with nodemon (port 5000)
- **Database**: MongoDB (port 27017)

### Production Environment

- **Frontend**: Nginx serving built React app
- **Backend**: Node.js production server
- **Database**: MongoDB with authentication
- **Reverse Proxy**: Nginx for routing

## Environment Variables

### Root Level (.env)

```env
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=password123
MONGO_DATABASE=sas_db
JWT_SECRET=your_jwt_secret_key_here
JWT_LIFETIME=7d
FRONTEND_APP_URL=http://localhost:5173
```

### Backend (.env)

```env
NODE_ENV=development
PORT=5000
MONGO_URI=mongodb://admin:password123@localhost:27017/sas_db?authSource=admin
JWT_SECRET=your_jwt_secret_key_here
JWT_LIFETIME=7d
FRONTEND_APP_URL=http://localhost:5173
```

### Frontend (.env)

```env
VITE_API_URL=http://localhost:5000/api/v1
```

## Benefits of Monorepo Structure

1. **Shared Dependencies**: Reduces disk space and installation time
2. **Consistent Versions**: Ensures all packages use the same dependency versions
3. **Simplified Management**: Single package.json for workspace-wide dependencies
4. **Optimized Docker Builds**: Shared context reduces build time and image size
5. **Unified Scripts**: Easy to run both frontend and backend together
6. **Better Development Experience**: Hot reloading and shared tooling

## Troubleshooting

### Common Issues

1. **Port Conflicts**: Make sure ports 5000, 5173, and 27017 are available
2. **Permission Issues**: On Linux/Mac, you might need to fix file permissions
3. **Docker Build Failures**: Try cleaning Docker cache: `docker system prune -a`
4. **Node Modules Issues**: Run `npm run clean` and then `npm install`

### Clean Installation

```bash
# Clean everything and reinstall
npm run clean
npm install
```

## Contributing

1. Make changes to the respective frontend or backend code
2. Test your changes in development mode
3. Build and test in production mode
4. Submit a pull request

## License

MIT License - see LICENSE file for details
