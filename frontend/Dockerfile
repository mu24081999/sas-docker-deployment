# Multi-stage build for production
# Stage 1: Build the React app
FROM node:20-alpine as build

WORKDIR /app

# Copy root package.json and workspace configuration
COPY package.json ./
COPY package-lock.json* ./

# Copy frontend package.json
COPY frontend/package.json ./frontend/

# Install dependencies for the entire workspace
RUN npm ci --legacy-peer-deps

# Copy frontend source code
COPY frontend/ ./frontend/

# Set working directory to frontend
WORKDIR /app/frontend

# Build the app (run from root to access workspace dependencies)
WORKDIR /app
RUN npm run build:frontend

# Stage 2: Serve the app with nginx
FROM nginx:alpine

# Copy built app from build stage
COPY --from=build /app/frontend/dist /usr/share/nginx/html

# Copy custom nginx config
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]