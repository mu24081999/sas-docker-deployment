# Multi-stage build for production
# Stage 1: Build the React app
FROM node:20-alpine as build

WORKDIR /app

# Build-time environment for Vite
ARG VITE_API_URL
ARG VITE_APP_NAME
ARG VITE_APP_VERSION
ARG VITE_NODE_ENV
ENV VITE_API_URL="$VITE_API_URL"
ENV VITE_APP_NAME="$VITE_APP_NAME"
ENV VITE_APP_VERSION="$VITE_APP_VERSION"
ENV VITE_NODE_ENV="$VITE_NODE_ENV"

# Copy package files
COPY package.json ./
COPY package-lock.json* ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy source code
COPY . ./

# Build the app
RUN npm run build

# Stage 2: Serve the app with nginx
FROM nginx:alpine

# Copy built app from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]