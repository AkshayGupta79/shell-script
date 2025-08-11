#!/bin/bash

# Variables
DOMAIN="codespazio.space"
CONF_FILE="/etc/httpd/conf.d/codespazio.conf"
DOC_ROOT="/var/www"
DOC_DIR="codespazio"
INDEX_FILE="$DOC_ROOT/$DOC_DIR/index.html"

# Update and upgrade the system packages
echo "Updating and upgrading system packages..."
yum update -y
yum upgrade -y

# Install required packages
echo "Installing wget and unzip packages..."
yum install -y wget unzip

# Install Apache web server package
echo "Installing Apache Web Server ('httpd') package..."
yum install -y httpd

# Start and enable httpd service
echo "Starting and enabling httpd service..."
systemctl enable --now httpd

# Create the document root directory
echo "Creating document root directory and required files also..."
mkdir -p "$DOC_ROOT/$DOC_DIR"
touch $CONF_FILE
touc $INDEX_FILE

# Create and edit the custom configuration file
echo "Creating and editing configuration file: $CONF_FILE"
cat > $CONF_FILE <<EOL
<VirtualHost *:80>
    ServerName $DOMAIN
    DocumentRoot "$DOC_ROOT/$DOC_DIR"
</VirtualHost>
EOL

# Create the index.html file
echo "Creating index.html file..."
cat > $INDEX_FILE <<EOL
<h1> Welcome to the CodeSpazio Solutions Pvt. Ltd </h1>
EOL

# Set permissions for the document root
echo "Setting permissions for the document root..."
chown -R apache:apache "$DOC_ROOT/$DOC_DIR"
chmod -R 755 "$DOC_ROOT/$DOC_DIR"

# Restart the Apache httpd service
echo "Restarting Apache httpd service..."
systemctl restart httpd

echo "Apache web server configured successfully!"

