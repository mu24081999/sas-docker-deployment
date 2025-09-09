@echo off
REM SAS VPS Deployment Script for Windows
REM This script helps deploy the complete SAS application to a VPS server

echo [INFO] SAS VPS Deployment Package Creator
echo.

REM Check if required files exist
echo [INFO] Checking required files...

set missing_files=

if not exist "backend\Dockerfile" set missing_files=%missing_files% backend\Dockerfile
if not exist "backend\Dockerfile.dev" set missing_files=%missing_files% backend\Dockerfile.dev
if not exist "backend\.dockerignore" set missing_files=%missing_files% backend\.dockerignore
if not exist "frontend\Dockerfile" set missing_files=%missing_files% frontend\Dockerfile
if not exist "frontend\Dockerfile.dev" set missing_files=%missing_files% frontend\Dockerfile.dev
if not exist "frontend\.dockerignore" set missing_files=%missing_files% frontend\.dockerignore
if not exist "frontend\nginx.conf" set missing_files=%missing_files% frontend\nginx.conf
if not exist "docker-compose.yml" set missing_files=%missing_files% docker-compose.yml
if not exist "docker-compose.prod.yml" set missing_files=%missing_files% docker-compose.prod.yml
if not exist "env.example" set missing_files=%missing_files% env.example

if not "%missing_files%"=="" (
    echo [ERROR] Missing required files:
    echo %missing_files%
    echo [ERROR] Please run this script from the project root directory with all files present.
    pause
    exit /b 1
)

echo [INFO] All required files found!

REM Create deployment package
echo [INFO] Creating deployment package...

REM Remove existing deployment directory
if exist "sas-deployment" rmdir /s /q "sas-deployment"

REM Create deployment directory
mkdir "sas-deployment"

REM Copy all necessary files
xcopy "backend" "sas-deployment\backend\" /E /H /Y
xcopy "frontend" "sas-deployment\frontend\" /E /H /Y
xcopy "nginx" "sas-deployment\nginx\" /E /H /Y
copy "docker-compose.yml" "sas-deployment\"
copy "docker-compose.prod.yml" "sas-deployment\"
copy "env.example" "sas-deployment\"
copy "deploy.sh" "sas-deployment\"
copy "deploy.bat" "sas-deployment\"
copy "README.md" "sas-deployment\"
copy ".gitignore" "sas-deployment\"

REM Create deployment instructions
echo # VPS Deployment Instructions > "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo. >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo ## Quick Deploy >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo. >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo 1. **Upload files to VPS:** >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    ```bash >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    # Upload the entire sas-deployment folder to your VPS >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    scp -r sas-deployment/ user@your-vps-ip:/root/ >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    ``` >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo. >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo 2. **SSH into your VPS:** >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    ```bash >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    ssh user@your-vps-ip >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    cd /root/sas-deployment >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    ``` >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo. >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo 3. **Set up environment:** >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    ```bash >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    cp env.example .env >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    nano .env  # Edit with your production values >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    ``` >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo. >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo 4. **Deploy:** >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    ```bash >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    # For development >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    docker compose up --build -d >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    # For production >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    docker compose -f docker-compose.prod.yml up --build -d >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"
echo    ``` >> "sas-deployment\DEPLOYMENT_INSTRUCTIONS.md"

echo [INFO] Deployment package created in 'sas-deployment' directory
echo.
echo [INFO] Deployment package ready!
echo.
echo To deploy to your VPS:
echo.
echo 1. Upload the sas-deployment folder to your VPS:
echo    scp -r sas-deployment/ user@your-vps-ip:/root/
echo.
echo 2. SSH into your VPS:
echo    ssh user@your-vps-ip
echo    cd /root/sas-deployment
echo.
echo 3. Set up environment:
echo    cp env.example .env
echo    nano .env  # Edit with your production values
echo.
echo 4. Deploy:
echo    docker compose up --build -d
echo.
echo Access your application at:
echo   Frontend: http://your-vps-ip:5173
echo   Backend: http://your-vps-ip:5000
echo.
pause
