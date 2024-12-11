#!/bin/bash

# Audit script to check if the repo_gpgcheck is enabled globally and per repository.
# This script checks the global configuration in /etc/dnf/dnf.conf.
# It also checks repository configurations in /etc/yum.repos.d/ to ensure repo_gpgcheck is not disabled unless necessary.

# Global configuration audit
echo "Auditing global configuration in /etc/dnf/dnf.conf..."
if grep -q '^repo_gpgcheck=1' /etc/dnf/dnf.conf; then
    echo "Global configuration: repo_gpgcheck is set to 1."
else
    echo "Global configuration: repo_gpgcheck is NOT set to 1."
    exit 1
fi

# Per repository configuration audit
echo "Auditing individual repository configuration in /etc/yum.repos.d/..."
echo "Please research which specific repositories support repo_gpgcheck and adjust the REPO_URL variable accordingly before proceeding."

REPO_URL="fedoraproject.org" # Default URL to exclude

# Loop to find repos with repo_gpgcheck explicitly disabled
repositories=$(grep -l "repo_gpgcheck=0" /etc/yum.repos.d/*)
for repo in $repositories; do
    if ! grep "$REPO_URL" "$repo" &>/dev/null; then
        echo "Repository $repo has repo_gpgcheck disabled and is not from $REPO_URL. Please verify if this is intentional."
    fi
done

echo "Audit complete. Please ensure the above configurations align with your security policies."

# Exit with success if no issues were found or addressed
exit 0
