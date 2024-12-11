#!/bin/bash

# This script audits the configuration of GPG keys on a system to ensure package integrity.
# It checks if GPG keys are configured properly in the yum/dnf repositories and lists installed GPG keys.

# Function to check if a command exits successfully
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Audit failed."
        exit 1
    fi
}

# List all GPG key URLs from yum and dnf repository configurations
echo "Checking for GPG key URLs in repository configurations..."
grep -r gpgkey /etc/yum.repos.d/* /etc/dnf/dnf.conf
check_command_success

# List installed GPG keys using RPM
echo "Listing installed GPG keys..."
for RPM_PACKAGE in $(rpm -q gpg-pubkey); do
    echo "RPM: ${RPM_PACKAGE}"
    RPM_SUMMARY=$(rpm -q --queryformat "%{SUMMARY}" "${RPM_PACKAGE}")
    RPM_PACKAGER=$(rpm -q --queryformat "%{PACKAGER}" "${RPM_PACKAGE}")
    RPM_DATE=$(date +%Y-%m-%d -d "1970-1-1+$((0x$(rpm -q --queryformat "%{RELEASE}" "${RPM_PACKAGE}") ))sec")
    RPM_KEY_ID=$(rpm -q --queryformat "%{VERSION}" "${RPM_PACKAGE}")
    echo -e "Packager: ${RPM_PACKAGER}\nSummary: ${RPM_SUMMARY}\nCreation date: ${RPM_DATE}\nKey ID: ${RPM_KEY_ID}\n"
done
check_command_success

# Query locally available GPG keys under /etc/pki/rpm-gpg
echo "Querying locally available GPG keys..."
for PACKAGE in $(find /etc/pki/rpm-gpg/ -type f -exec rpm -qf {} \; | sort -u); do
    rpm -q --queryformat "%{NAME}-%{VERSION} %{PACKAGER} %{SUMMARY}\\n" "${PACKAGE}"
done
check_command_success

echo "Please manually verify the listed GPG keys with the public key page of the relevant repositories."

# If all checks pass, exit with status 0
echo "Audit passed."
exit 0