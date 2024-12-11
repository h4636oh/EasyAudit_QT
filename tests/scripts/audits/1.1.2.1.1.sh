#!/usr/bin/env bash

# Verify that /tmp is mounted with the correct options
mount_check=$(findmnt -kn /tmp)

expected_output="/tmp tmpfs tmpfs rw,nosuid,nodev,noexec"

if [[ "$mount_check" == "$expected_output" ]]; then
    echo "OK: /tmp is mounted with the correct options."
else
    echo "Warning: /tmp is not mounted with the expected options:"
    echo "$mount_check"
    exit 1
fi

# Ensure systemd will mount the /tmp partition at boot time
systemd_check=$(systemctl is-enabled tmp.mount)

if [[ "$systemd_check" == "generated" ]]; then
    echo "OK: systemd will mount the /tmp partition at boot time."
else
    echo "Warning: systemd will not mount the /tmp partition as expected."
    echo "$systemd_check"
    exit 1
fi

