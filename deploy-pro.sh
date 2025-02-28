#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting production deployment..."

# Check if required environment variables are set
if [ -z "$DEPLOY_SERVER" ] || [ -z "$DEPLOY_USER" ] || [ -z "$DEPLOY_PATH" ]; then
    echo "❌ Error: Please set the following environment variables:"
    echo "   DEPLOY_SERVER - The server IP or domain"
    echo "   DEPLOY_USER - SSH user for deployment"
    echo "   DEPLOY_PATH - Path to deploy on the server"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build the project
echo "🔨 Building project..."
npm run build

# Create a timestamp for backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Deploy to server
echo "📤 Deploying to production server..."
echo "🔄 Creating backup of existing deployment..."
ssh $DEPLOY_USER@$DEPLOY_SERVER "if [ -d $DEPLOY_PATH ]; then cp -r $DEPLOY_PATH ${DEPLOY_PATH}_backup_${TIMESTAMP}; fi"

echo "📂 Copying new build to server..."
scp -r build/* $DEPLOY_USER@$DEPLOY_SERVER:$DEPLOY_PATH

echo "🔄 Restarting Nginx..."
ssh $DEPLOY_USER@$DEPLOY_SERVER "sudo systemctl restart nginx"

echo "✅ Deployment completed successfully!"
echo "🌍 Your application should now be live at https://$DEPLOY_SERVER"
echo "⚠️ If you encounter any issues, you can rollback using the backup at: ${DEPLOY_PATH}_backup_${TIMESTAMP}" 