#!/usr/bin/env bash

# Function to add/update /dev/shm entry in /etc/fstab
configure_fstab() {
    local fstab_entry="tmpfs /dev/shm tmpfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0"

    if grep -q "^tmpfs /dev/shm" /etc/fstab; then
        echo "Updating existing /dev/shm entry in /etc/fstab..."
        sudo sed -i "s|^tmpfs /dev/shm.*|${fstab_entry}|" /etc/fstab
    else
        echo "Adding new /dev/shm entry to /etc/fstab..."
        echo "${fstab_entry}" | sudo tee -a /etc/fstab
    fi
}

# Check if /dev/shm is mounted with correct options and configure if necessary
mount_check=$(findmnt -kn /dev/shm | grep -v -E 'nosuid|nodev|noexec')

if [[ -z "$mount_check" ]]; then
    echo "OK: /dev/shm is mounted with the correct options."
else
    echo "Warning: /dev/shm is not mounted with the expected options. Configuring /etc/fstab..."
    configure_fstab
    echo "Remounting /dev/shm with the configured options..."
    sudo mount -o remount /dev/shm
    echo "/dev/shm has been remounted with the correct options."
fi

