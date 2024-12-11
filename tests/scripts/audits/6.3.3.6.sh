#!/usr/bin/env bash

# Check on-disk rules
echo "Checking on-disk rules:"
for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
    for PRIVILEGED in $(find "${PARTITION}" -xdev -perm /6000 -type f); do
        if grep -qr "${PRIVILEGED}" /etc/audit/rules.d; then
            printf "OK: '${PRIVILEGED}' found in auditing rules.\n"
        else
            printf "Warning: '${PRIVILEGED}' not found in on-disk configuration.\n"
            exit 1
        fi
    done
done

# Check running configuration rules
echo "Checking running configuration rules:"
RUNNING=$(auditctl -l)
if [ -n "${RUNNING}" ]; then
    for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
        for PRIVILEGED in $(find "${PARTITION}" -xdev -perm /6000 -type f); do
            if printf -- "${RUNNING}" | grep -q "${PRIVILEGED}"; then
                printf "OK: '${PRIVILEGED}' found in auditing rules.\n"
            else
                printf "Warning: '${PRIVILEGED}' not found in running configuration.\n"
                exit 1
            fi
        done
    done
else
    printf "ERROR: Variable 'RUNNING' is unset.\n"
fi

# Note about special mount points
echo "Special mount points: If there are any special mount points that are not visible by default from findmnt as per the above audit, those file systems would have to be manually audited."

