#!/usr/bin/env bash

# Unmask tmp.mount to ensure systemd will mount /tmp at boot time
sudo systemctl unmask tmp.mount

echo "Systemd is configured to mount /tmp at boot time."

# Example of using tmpfs with specific mount options in /etc/fstab
echo "You can configure /etc/fstab for tmpfs with specific mount options like this:"
echo "tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0"

# Example of using a volume or disk with specific mount options in /etc/fstab
echo "You can configure /etc/fstab for a volume or disk with specific mount options like this:"
echo "<device> /tmp <fstype> defaults,nodev,nosuid,noexec 0 0"

