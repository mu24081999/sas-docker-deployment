# VPS Deployment Instructions 
 
## Quick Deploy 
 
1. **Upload files to VPS:** 
   ```bash 
   # Upload the entire sas-deployment folder to your VPS 
   scp -r sas-deployment/ user@your-vps-ip:/root/ 
   ``` 
 
2. **SSH into your VPS:** 
   ```bash 
   ssh user@your-vps-ip 
   cd /root/sas-deployment 
   ``` 
 
3. **Set up environment:** 
   ```bash 
   cp env.example .env 
   nano .env  # Edit with your production values 
   ``` 
 
4. **Deploy:** 
   ```bash 
   # For development 
   docker compose up --build -d 
ECHO is off.
   # For production 
   docker compose -f docker-compose.prod.yml up --build -d 
   ``` 
