@echo off
REM SSL Setup Script for SAS Production (Windows)
REM This script helps set up SSL certificates with Let's Encrypt

echo [INFO] SAS SSL Setup Script
echo.

REM Check if .env file exists
if not exist .env (
    echo [ERROR] .env file not found. Please create it first.
    echo [INFO] Copy env.example to .env and configure your settings:
    echo [INFO] copy env.example .env
    echo [INFO] notepad .env
    pause
    exit /b 1
)

echo [INFO] .env file found.

REM Load environment variables
for /f "usebackq tokens=1,2 delims==" %%a in (.env) do (
    if not "%%a"=="" if not "%%a:~0,1%"=="#" (
        set "%%a=%%b"
    )
)

echo [INFO] Environment variables loaded.

REM Check if domain is configured
if "%DOMAIN_NAME%"=="" (
    echo [ERROR] Domain name not configured in .env file.
    echo [INFO] Please set DOMAIN_NAME in your .env file to your actual domain.
    pause
    exit /b 1
)

if "%DOMAIN_NAME%"=="your-domain.com" (
    echo [ERROR] Domain name not configured in .env file.
    echo [INFO] Please set DOMAIN_NAME in your .env file to your actual domain.
    pause
    exit /b 1
)

if "%SSL_EMAIL%"=="" (
    echo [ERROR] SSL email not configured in .env file.
    echo [INFO] Please set SSL_EMAIL in your .env file to your actual email.
    pause
    exit /b 1
)

if "%SSL_EMAIL%"=="your-email@example.com" (
    echo [ERROR] SSL email not configured in .env file.
    echo [INFO] Please set SSL_EMAIL in your .env file to your actual email.
    pause
    exit /b 1
)

echo [INFO] Domain: %DOMAIN_NAME%
echo [INFO] Email: %SSL_EMAIL%

REM Create SSL directory
echo [INFO] Creating SSL directory...
if not exist "nginx\ssl" mkdir nginx\ssl
echo [INFO] SSL directory created.

echo.
echo [INFO] Choose SSL setup method:
echo 1. Generate self-signed certificate (for testing)
echo 2. Get Let's Encrypt certificate (for production)
echo 3. Setup certificate renewal only
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" goto self_signed
if "%choice%"=="2" goto letsencrypt
if "%choice%"=="3" goto renewal
goto invalid

:self_signed
echo [INFO] Generating self-signed certificate for initial setup...
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx\ssl\key.pem -out nginx\ssl\cert.pem -subj "/C=US/ST=State/L=City/O=Organization/CN=%DOMAIN_NAME%"
echo [WARNING] Self-signed certificate generated. This is for testing only.
echo [INFO] To get a real SSL certificate, run this script again and choose option 2.
goto end

:letsencrypt
echo [INFO] Getting Let's Encrypt certificate...
echo [INFO] Stopping nginx if running...
docker-compose -f docker-compose.prod.yml stop nginx 2>nul

echo [INFO] Starting nginx for certificate challenge...
docker-compose -f docker-compose.prod.yml up -d nginx

echo [INFO] Waiting for nginx to start...
timeout /t 10 /nobreak >nul

echo [INFO] Requesting SSL certificate from Let's Encrypt...
docker-compose -f docker-compose.prod.yml run --rm certbot

echo [INFO] Copying certificate to nginx ssl directory...
docker cp sas-certbot:/etc/letsencrypt/live/%DOMAIN_NAME%/fullchain.pem nginx\ssl\cert.pem
docker cp sas-certbot:/etc/letsencrypt/live/%DOMAIN_NAME%/privkey.pem nginx\ssl\key.pem

echo [INFO] SSL certificate obtained and configured.

echo [INFO] Setting up certificate renewal...
echo @echo off > renew-ssl.bat
echo REM SSL Certificate Renewal Script >> renew-ssl.bat
echo. >> renew-ssl.bat
echo REM Load environment variables >> renew-ssl.bat
echo for /f "usebackq tokens=1,2 delims==" %%%%a in (.env) do ( >> renew-ssl.bat
echo     if not "%%%%a"=="" if not "%%%%a:~0,1%%"=="#" ( >> renew-ssl.bat
echo         set "%%%%a=%%%%b" >> renew-ssl.bat
echo     ) >> renew-ssl.bat
echo ) >> renew-ssl.bat
echo. >> renew-ssl.bat
echo REM Renew certificate >> renew-ssl.bat
echo docker-compose -f docker-compose.prod.yml run --rm certbot renew >> renew-ssl.bat
echo. >> renew-ssl.bat
echo REM Copy renewed certificate >> renew-ssl.bat
echo docker cp sas-certbot:/etc/letsencrypt/live/%%DOMAIN_NAME%%/fullchain.pem nginx\ssl\cert.pem >> renew-ssl.bat
echo docker cp sas-certbot:/etc/letsencrypt/live/%%DOMAIN_NAME%%/privkey.pem nginx\ssl\key.pem >> renew-ssl.bat
echo. >> renew-ssl.bat
echo REM Reload nginx >> renew-ssl.bat
echo docker-compose -f docker-compose.prod.yml exec nginx nginx -s reload >> renew-ssl.bat
echo. >> renew-ssl.bat
echo echo SSL certificate renewed successfully >> renew-ssl.bat

echo [INFO] Certificate renewal configured.

echo [INFO] Starting production environment with SSL...
docker-compose -f docker-compose.prod.yml up -d
echo [INFO] Production environment started with SSL!
echo [INFO] Your application is now available at: https://%DOMAIN_NAME%
goto end

:renewal
echo [INFO] Setting up certificate renewal...
echo @echo off > renew-ssl.bat
echo REM SSL Certificate Renewal Script >> renew-ssl.bat
echo. >> renew-ssl.bat
echo REM Load environment variables >> renew-ssl.bat
echo for /f "usebackq tokens=1,2 delims==" %%%%a in (.env) do ( >> renew-ssl.bat
echo     if not "%%%%a"=="" if not "%%%%a:~0,1%%"=="#" ( >> renew-ssl.bat
echo         set "%%%%a=%%%%b" >> renew-ssl.bat
echo     ) >> renew-ssl.bat
echo ) >> renew-ssl.bat
echo. >> renew-ssl.bat
echo REM Renew certificate >> renew-ssl.bat
echo docker-compose -f docker-compose.prod.yml run --rm certbot renew >> renew-ssl.bat
echo. >> renew-ssl.bat
echo REM Copy renewed certificate >> renew-ssl.bat
echo docker cp sas-certbot:/etc/letsencrypt/live/%%DOMAIN_NAME%%/fullchain.pem nginx\ssl\cert.pem >> renew-ssl.bat
echo docker cp sas-certbot:/etc/letsencrypt/live/%%DOMAIN_NAME%%/privkey.pem nginx\ssl\key.pem >> renew-ssl.bat
echo. >> renew-ssl.bat
echo REM Reload nginx >> renew-ssl.bat
echo docker-compose -f docker-compose.prod.yml exec nginx nginx -s reload >> renew-ssl.bat
echo. >> renew-ssl.bat
echo echo SSL certificate renewed successfully >> renew-ssl.bat

echo [INFO] Certificate renewal configured.
goto end

:invalid
echo [ERROR] Invalid choice. Exiting.
pause
exit /b 1

:end
echo.
echo [INFO] SSL setup completed!
pause
