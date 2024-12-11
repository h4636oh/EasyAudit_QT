#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking vsftpd.service..."
    systemctl stop vsftpd.service
    systemctl mask vsftpd.service
    echo "vsftpd.service stopped and masked."
}

# Check if vsftpd is installed
if dpkg-query -s vsftpd &>/dev/null; then
    echo "vsftpd is installed"
    echo "Stopping vsftpd.service..."
    systemctl stop vsftpd.service

    # Attempt to purge the vsftpd package
    echo "Attempting to purge vsftpd..."
    if apt purge -y vsftpd; then
        echo "vsftpd package purged successfully."
    else
        echo "Failed to purge vsftpd package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "vsftpd is not installed."
fi

# Additional check for other FTP server packages (e.g., proftpd, pure-ftpd)
other_ftp_servers=("proftpd" "pure-ftpd")
for ftp_server in "${other_ftp_servers[@]}"; do
    if dpkg-query -s "$ftp_server" &>/dev/null; then
        echo "$ftp_server is installed. Please verify if it is required and authorized by local site policy."
    else
        echo "$ftp_server is not installed."
    fi
done

