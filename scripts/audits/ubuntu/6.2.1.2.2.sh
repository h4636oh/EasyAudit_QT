#!/bin/bash

# Define the parameters to check
params=(
    "URL="
    "ServerKeyFile="
    "ServerCertificateFile="
    "TrustedCertificateFile="
)

# Function to check the parameters
check_params() {
    local file=$1
    for param in "${params[@]}"; do
        grep -P "^ *$param" "$file" || echo "Parameter $param not found in $file"
        exit 1
    done
}

# Check the parameters in /etc/systemd/journal-upload.conf
conf_file="/etc/systemd/journal-upload.conf"
if [ -f "$conf_file" ]; then
    echo "Checking $conf_file for required parameters..."
    check_params "$conf_file"
else
    echo "Configuration file $conf_file not found!"
fi

echo "Verification of systemd-journal-upload authentication parameters completed."

