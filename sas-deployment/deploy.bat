@echo off
REM SAS - Sales Automation Software Deployment Script for Windows
REM This script helps deploy the unified SAS application to a VPS server

setlocal enabledelayedexpansion

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not installed. Please install Docker Desktop first.
    exit /b 1
)

docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker Compose is not installed. Please install Docker Compose first.
    exit /b 1
)

echo [INFO] Docker and Docker Compose are installed.

REM Check if .env file exists
if not exist .env (
    echo [WARNING] .env file not found. Creating from example...
    copy env.example .env
    echo [WARNING] Please edit .env file with your production values before continuing.
    pause
)

echo [INFO] .env file found.

REM Main menu
:menu
echo.
echo SAS - Sales Automation Software
echo ===============================
echo 1. Start Development Environment (Docker)
echo 2. Start Development Environment (Local)
echo 3. Start Production Environment
echo 4. Install All Dependencies
echo 5. Stop All Services
echo 6. Show Logs (Development)
echo 7. Show Logs (Production)
echo 8. Cleanup Docker Resources
echo 9. Exit
echo.
set /p choice="Enter your choice (1-9): "

if "%choice%"=="1" goto dev
if "%choice%"=="2" goto dev_local
if "%choice%"=="3" goto prod
if "%choice%"=="4" goto install
if "%choice%"=="5" goto stop
if "%choice%"=="6" goto logs_dev
if "%choice%"=="7" goto logs_prod
if "%choice%"=="8" goto cleanup
if "%choice%"=="9" goto end
goto menu

:dev
echo [INFO] Starting development environment with Docker...
docker-compose down --remove-orphans
docker-compose up --build -d
echo [INFO] Development environment started!
echo [INFO] Frontend: http://localhost:5173
echo [INFO] Backend API: http://localhost:5000
echo [INFO] MongoDB: localhost:27017
goto menu

:dev_local
echo [INFO] Starting local development environment...
echo [INFO] Make sure MongoDB is running locally on port 27017
echo [INFO] Starting backend and frontend concurrently...
npm run dev
goto menu

:install
echo [INFO] Installing all dependencies...
npm run install:all
echo [INFO] All dependencies installed!
goto menu

:prod
echo [INFO] Starting production environment...
docker-compose -f docker-compose.prod.yml down --remove-orphans
docker-compose -f docker-compose.prod.yml up --build -d
echo [INFO] Production environment started!
echo [INFO] Application: http://localhost
echo [INFO] API: http://localhost/api
goto menu

:stop
echo [INFO] Stopping all services...
docker-compose down --remove-orphans
docker-compose -f docker-compose.prod.yml down --remove-orphans
echo [INFO] All services stopped.
goto menu

:logs_dev
echo [INFO] Showing development logs...
docker-compose logs -f
goto menu

:logs_prod
echo [INFO] Showing production logs...
docker-compose -f docker-compose.prod.yml logs -f
goto menu

:cleanup
echo [INFO] Cleaning up Docker resources...
docker system prune -f
docker volume prune -f
echo [INFO] Cleanup completed.
goto menu

:end
echo [INFO] Goodbye!
exit /b 0
