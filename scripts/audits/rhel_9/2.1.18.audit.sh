#!/bin/bash

# This script audits the status of web server packages and services on the system.
# It ensures that 'httpd' and 'nginx' are not installed and checks the status of
# 'httpd.socket', 'httpd.service', and 'nginx.service' to ensure they are neither enabled nor active.

# Function to check if a package is installed
check_package_installed() {
    local package=$1
    if rpm -q $package &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check if a service is enabled
check_service_enabled() {
    local service=$1
    if systemctl is-enabled $service 2>/dev/null | grep -q 'enabled'; then
        return 0
    else
        return 1
    fi
}

# Function to check if a service is active
check_service_active() {
    local service=$1
    if systemctl is-active $service 2>/dev/null | grep -q '^active'; then
        return 0
    else
        return 1
    fi
}

# Check for 'httpd' and 'nginx' packages
for package in httpd nginx; do
    if check_package_installed $package; then
        echo "Package $package is installed. Please verify its necessity according to local site policy."
        exit 1
    else
        echo "Package $package is not installed."
    fi
done

# Check if services are enabled
for service in httpd.socket httpd.service nginx.service; do
    if check_service_enabled $service; then
        echo "Service $service is enabled. Please verify its necessity according to local site policy."
        exit 1
    else
        echo "Service $service is not enabled."
    fi
done

# Check if services are active
for service in httpd.socket httpd.service nginx.service; do
    if check_service_active $service; then
        echo "Service $service is active. Please verify its necessity according to local site policy."
        echo "Audit: **FAIL**"
        exit 1
    else
        echo "Service $service is not active."
    fi
done

echo "All checks passed. Web server packages and services are not in use."
echo "Audit: **PASS**"
exit 0