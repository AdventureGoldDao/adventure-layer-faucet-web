# Adventure Layer Faucet

## 🚀 Quick Start

### Prerequisites

- Node.js >= 14.0.0
- npm >= 6.14.0


## 🔧 Configuration

### Environment Variables

Configure the following parameters in `config.js`:

```javascript
{
  faucetUrl: "Faucet API URL",
  explorerUrl: "Block Explorer URL",
  bridgeUrl: "Bridge URL",
  docsUrl: "Documentation URL",
  rpcUrl: "RPC Node URL",
  turnstileSiteKey: "Cloudflare Turnstile site key"
}
```

## 🌐 Deployment

### Automated Deployment (Recommended)

We provide a deployment script that automates the entire deployment process. To use it:

1. Make the deployment script executable:
```bash
chmod +x deploy-pro.sh
```

2. Set up the required environment variables:
```bash
export DEPLOY_SERVER="your-server-domain-or-ip"
export DEPLOY_USER="your-ssh-user"
export DEPLOY_PATH="/path/to/your/webroot/build"
```

3. Run the deployment script:
```bash
./deploy-pro.sh
```

The script will:
- Install dependencies
- Build the application
- Create a backup of the existing deployment
- Deploy the new version
- Restart Nginx
- Provide rollback instructions if needed

### Manual Deployment

If you prefer to deploy manually, follow these steps:

#### 1. Build the application

```bash
# Build for production
npm run build
```

#### 2. Transfer files to your server

```bash
# Using SCP (Secure Copy)
scp -r ./build user@your-server-ip:/path/to/your/webroot/

# Or using SFTP or other file transfer methods
```

#### 3. Nginx Configuration

Create an Nginx configuration file (e.g., `/etc/nginx/conf.d/adventure-faucet.conf`) with the following content:

```nginx
server {
    listen 80;
    server_name localhost;  # Replace with your domain if applicable
    access_log /var/log/nginx/faucet-access.log;

    location / {
        root /path/to/your/webroot/build;            # webroot path
        index index.html index.htm;
        try_files $uri /index.html;
    }

    location = /index.html {
        add_header Cache-Control no-store,no-cache;
        root /path/to/your/webroot/build;            # webroot path
    }

    location /api {
        rewrite ^/api(.*) $1 break;
        proxy_pass http://172.x.x.x:8502;             # Backend API server address and port
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### 4. Check configuration and restart Nginx

```bash
# Test Nginx configuration
sudo nginx -t

# If the test passes, restart Nginx
sudo systemctl restart nginx
# or
sudo service nginx restart
```

#### 5. Verify deployment

Access your application at:
- http://your-server-ip:80 (if using the IP directly)
- http://your-domain:80 (if you've set up a domain)

### Important Notes for Deployment

1. Ensure the directory `/path/to/your/webroot/` exists on your server and has proper permissions
2. The backend API service must be running at the configured address (172.x.x.x:8502)
3. If using a firewall, ensure port 80 is open
4. For production use, consider:
   - Adding SSL/TLS (HTTPS) support
   - Setting up proper domain name with DNS records
   - Regular backups of your deployment
   - Monitoring system resources
   - Setting up proper logging

### Security Considerations

1. Always use HTTPS in production
2. Set up proper firewall rules
3. Keep all dependencies up to date
4. Use environment variables for sensitive configuration
5. Implement rate limiting
6. Set up proper CORS policies

### Rollback Procedure

In case you need to rollback to a previous version:

1. Locate the backup directory on your server (format: `${DEPLOY_PATH}_backup_YYYYMMDD_HHMMSS`)
2. Replace the current deployment with the backup:
```bash
# SSH into your server
ssh $DEPLOY_USER@$DEPLOY_SERVER

# Replace current deployment with backup
sudo rm -rf $DEPLOY_PATH/*
sudo cp -r ${DEPLOY_PATH}_backup_YYYYMMDD_HHMMSS/* $DEPLOY_PATH/

# Restart Nginx
sudo systemctl restart nginx
```


