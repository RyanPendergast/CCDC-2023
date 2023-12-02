#!/bin/bash

# Variables
TFTP_DIRECTORY="/srv/tftp" # Directory for TFTP server
INTERNAL_NETWORK="192.168.1.0/24" # Internal Network CIDR (Change as per your network)

# Install TFTP server (using tftpd-hpa for Debian/Ubuntu)
apt-get update
apt-get install -y tftpd-hpa

# Create and secure the TFTP directory
mkdir -p $TFTP_DIRECTORY
chown -R tftp:tftp $TFTP_DIRECTORY
chmod -R 775 $TFTP_DIRECTORY

# Configure TFTP server
cat > /etc/default/tftpd-hpa << EOF
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="$TFTP_DIRECTORY"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure --create"
EOF

# Restart TFTP service
service tftpd-hpa restart

# Configure firewall (using iptables)
iptables -A INPUT -p udp --dport 69 -s $INTERNAL_NETWORK -j ACCEPT # Allow TFTP from internal network
iptables -A INPUT -p udp --dport 69 -j DROP # Drop other TFTP requests

# Save iptables (Debian/Ubuntu)
iptables-save > /etc/iptables/rules.v4

echo "TFTP server setup complete."
