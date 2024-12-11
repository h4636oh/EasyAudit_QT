#!/usr/bin/env bash

# Path to SSHD configuration file
sshd_config="/etc/ssh/sshd_config"
backup_file="${sshd_config}.bak"

# Define the list of weak MACs to exclude
weak_macs="-hmac-md5,hmac-md5-96,hmac-ripemd160,hmac-sha1-96,umac-64@openssh.com,hmac-md5-etm@openssh.com,hmac-md5-96-etm@openssh.com,hmac-ripemd160-etm@openssh.com,hmac-sha1-96-etm@openssh.com,umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha1-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com"

# Backup the original configuration
if [[ ! -f "$backup_file" ]]; then
    echo "Creating backup of the original sshd_config at $backup_file"
    cp "$sshd_config" "$backup_file"
fi

# Add or update the MACs line in the sshd_config
if grep -q "^MACs" "$sshd_config"; then
    echo "Updating existing MACs line to exclude weak MACs..."
    sed -i.bak '/^MACs/ s/.*/MACs '"$weak_macs"'/' "$sshd_config"
else
    echo "Adding MACs line to exclude weak MACs..."
    echo -e "\n# Exclude weak MAC algorithms\nMACs $weak_macs" >> "$sshd_config"
fi

echo "Remediation applied. Restarting SSH service..."

# Restart SSH service to apply changes
if command -v systemctl &>/dev/null; then
    sudo systemctl restart sshd
elif command -v service &>/dev/null; then
    sudo service ssh restart
else
    echo "Warning: Could not restart SSH service automatically. Please restart manually."
fi

echo "Remediation complete."