#!/bin/bash

# This script audits if dovecot and cyrus-imapd packages are installed
# and verifies the state of associated services if required by dependencies.

# Check if dovecot or cyrus-imapd packages are installed
installed_packages=$(rpm -q dovecot cyrus-imapd)

if echo "$installed_packages" | grep -q "not installed"; then
    echo "Audit Passed: dovecot and cyrus-imapd packages are not installed."
    exit 0
fi

# If they're installed, check if they're required for dependencies
echo "Warning: dovecot or cyrus-imapd package is installed."
echo "$installed_packages"
echo "Please verify if these packages are required for any dependencies."

# Check if services are enabled
enabled_services=$(systemctl is-enabled dovecot.socket dovecot.service cyrus-imapd.service 2>/dev/null | grep 'enabled')

if [ -n "$enabled_services" ]; then
    echo "Audit Failed: The following services are enabled:"
    echo "$enabled_services"
    exit 1
fi

# Check if services are active
active_services=$(systemctl is-active dovecot.socket dovecot.service cyrus-imapd.service 2>/dev/null | grep '^active')

if [ -n "$active_services" ]; then
    echo "Audit Failed: The following services are active:"
    echo "$active_services"
    exit 1
fi

echo "Audit Passed: Services are not enabled or active."
exit 0


# This script checks for the installation of `dovecot` and `cyrus-imapd` and audits if their services are enabled or active. It outputs messages based on the results and exits with the appropriate status. It assumes that if the packages are not installed, the audit passes, and if they are, further checks on service states are required.