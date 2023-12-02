#!/bin/bash

# Flush existing iptables rules
iptables -F

# Default policies: drop all incoming and outgoing traffic
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow loopback interface (important for internal system communication)
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Inbound rules
# Example: Allow TCP on port 80 from a specific IP range
iptables -A INPUT -p tcp --dport 80 -s 192.168.1.0/24 -j ACCEPT

# Outbound rules
# Example: Allow TCP on port 443 to a specific IP
iptables -A OUTPUT -p tcp --dport 443 -d 203.0.113.5 -j ACCEPT

# Save the rules
iptables-save > /etc/iptables/rules.v4
