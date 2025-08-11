#!/bin/bash

# Variables
DOMAIN="domain.com"
DB_FILE="domain"
IP="ip_address"
NAMED_CONF="/etc/named.conf"
NAMED_CONF_BACKUP="/root/named.conf"
DB_PATH="/var/named"

# Function to install required packages
echo "Install Bind and Bind-utilities packages."
yum update -y
yum upgrade -y
yum install -y bind bind-utils

# Backup the main configuration file
echo "Backing up $NAMED_CONF to $NAMED_CONF_BACKUP."
cp  -p $NAMED_CONF $NAMED_CONF_BACKUP

# Start and Enable dns service
systemctl enable --now named.service

# Clear and Edit named.conf file
echo "Configuring $NAMED_CONF..."
cat > $NAMED_CONF <<EOL
options {
    directory "/var/named";
    recursion no;
};

zone "$DOMAIN" IN {
    type master;
    file "$DB_FILE";
};
EOL

echo "$NAMED_CONFfile configured seccessfully."

#create and configure the database file
echo "Creating and configuring the database file $DB_PATH/$DB_FILE" # /var/named/'domain_name'
cat > $DB_PATH/$DB_FILE << EOL
@   IN  SOA  ns1.$DOMAIN. ns2.$DOMAIN. (
                2023121201 ; Serial
                3600       ; Refresh
                1800       ; Retry
                604800     ; Expire
                86400 )    ; Minimum TTL

@       IN      NS      ns1.$DOMAIN.
@       IN      NS      ns2.$DOMAIN.
@       IN      A       $IP
ns1     IN      A       $IP
ns2     IN      A       $IP
www     IN      CNAME   $DOMAIN.
EOL

echo "Databse file $DB_PATH/$DB_FILE configured successfully."

# Set permissions for the database file
chown named:named $DB_PATH/$DB_FILE
chmod 640 $DB_PATH/$DB_FILE

# Restart the DNS Service
echo "Restarting the DNS service "named.service"."
systemctl restart named.service

# Check the service status
if systemctl is-active named.service; then
	echo "DNS service restarted successfully."
else
	echo "Failed to restart DNS service. Check the configuration."
	exit 1
fi

echo "DNS server configuration completed successfully."

