#!/bin/bash

SERVER_IP="192.168.1.1" # Replace with your server's IP address

# Scan for TCP ports
echo "Scanning TCP ports on $SERVER_IP"
nmap -sT $SERVER_IP

# Scan for UDP ports (can be slower)
echo "Scanning UDP ports on $SERVER_IP (This may take a while)"
nmap -sU $SERVER_IP
