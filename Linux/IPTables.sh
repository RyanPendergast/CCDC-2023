#!/bin/bash

# Define the list of expected inbound ports here
# Example: ports 22 (SSH), 80 (HTTP), and 443 (HTTPS)
ALLOWED_PORTS=(22 80 443)

# Function to set up iptables rules
setup_iptables() {
    # Flush existing rules and set default policy to DROP
    iptables -F
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    # Allow established connections (important for ongoing traffic)
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

    # Allow loopback interface (important for internal system communication)
    iptables -A INPUT -i lo -j ACCEPT

    # Allow inbound traffic on defined ports
    for port in "${ALLOWED_PORTS[@]}"; do
        iptables -A INPUT -p tcp --dport $port -j ACCEPT
    done

    # Log dropped packets (optional, for debugging purposes)
    iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables dropped: " --log-level 7
}

# Check for root privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Execute the iptables setup function
setup_iptables

# Save the iptables configuration (different commands for different distros)
if command -v iptables-save >/dev/null; then
    iptables-save > /etc/iptables/rules.v4
elif command -v netfilter-persistent >/dev/null; then
    netfilter-persistent save
else
    echo "Warning: iptables rules are set, but not saved. They will be lost on reboot."
fi

echo "Firewall setup complete."
