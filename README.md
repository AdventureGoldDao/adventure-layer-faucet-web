# Adventure Layer Faucet

Adventure Layer Faucet is a React-based web application for obtaining test AGLD tokens on the Adventure Layer Devnet test network. Users can receive 0.5 Devnet AGLD every 24 hours.

## ✨ Features

- 💳 Web3 wallet connection support
- 📱 Responsive design for both PC and mobile
- 🔒 Cloudflare Turnstile human verification integration
- 🌐 ENS domain resolution support
- ⚡ Real-time balance query
- 🎯 Daily limit of 0.5 Devnet AGLD

## 📁 Directory Structure

```
adventure-layer-faucet/
├── public/                 # Static resources
├── src/                    # Source code
│   ├── fonts/             # Font files
│   ├── img/               # Image resources
│   ├── libs/              # Utility libraries
│   ├── mobile/            # Mobile components
│   ├── App.js             # Main application component
│   ├── Home.js            # PC homepage component
│   ├── config.js          # Configuration file
│   └── index.js           # Application entry
└── package.json           # Project dependencies
```

## 🚀 Quick Start

### Prerequisites

- Node.js >= 14.0.0
- npm >= 6.14.0

### Installation

```bash
# Clone the project
git clone https://github.com/your-username/adventure-layer-faucet.git

# Enter project directory
cd adventure-layer-faucet

# Install dependencies
npm install
```

### Development

```bash
# Start development server
npm start
```

Visit http://localhost:3000 to view the application

### Build

```bash
# Build for production
npm run build
```

## 📦 Tech Stack

- React 18.3.1
- Web3.js 4.12.1
- Ethers.js 5.7.0
- Ant Design 5.17.0
- UseDApp Core 1.2.16

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

### Other Deployment Options

- Cloudflare Pages
- Vercel
- GitHub Pages

## 💻 Browser Support

| [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/chrome/chrome_48x48.png" alt="Chrome" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)<br>Chrome | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/firefox/firefox_48x48.png" alt="Firefox" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)<br>Firefox | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/safari/safari_48x48.png" alt="Safari" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)<br>Safari | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/edge/edge_48x48.png" alt="Edge" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)<br>Edge |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| >= 88                                                                                                                                                                                                            | >= 78                                                                                                                                                                                                              | >= 14                                                                                                                                                                                                            | >= 88                                                                                                                                                                                                          |

## ⚠️ Important Notes

1. Ensure all API endpoints are correctly configured before deployment
2. Verify Cloudflare Turnstile configuration
3. Maintain stable testnet RPC node availability
4. Configure CORS policy for security

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
```bash
git checkout -b feature/AmazingFeature
```
3. Commit your changes
```bash
git commit -m 'Add some AmazingFeature'
```
4. Push to the branch
```bash
git push origin feature/AmazingFeature
```
5. Open a Pull Request


## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details


## 📧 Contact

Project Maintainer - [@your-username](https://github.com/your-username)

Project Link: [https://github.com/your-username/adventure-layer-faucet](https://github.com/your-username/adventure-layer-faucet)

