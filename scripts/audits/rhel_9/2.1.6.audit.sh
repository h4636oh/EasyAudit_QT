#!/bin/bash

# Script to audit the Samba package and smb.service status
# Exit codes: 0 if audit passes, 1 if it fails

# Function to check if a package is installed
check_package_installed() {
  local pkg="$1"
  if rpm -q "${pkg}" &>/dev/null; then
    echo "Package ${pkg} is installed."
    return 0
  else
    echo "Package ${pkg} is not installed."
    return 1
  fi
}

# Function to check if a service is enabled
check_service_enabled() {
  local svc="$1"
  if systemctl is-enabled "${svc}" &>/dev/null; then
    echo "Service ${svc} is enabled."
    return 0
  else
    echo "Service ${svc} is not enabled."
    return 1
  fi
}

# Function to check if a service is active
check_service_active() {
  local svc="$1"
  if systemctl is-active "${svc}" &>/dev/null; then
    echo "Service ${svc} is active."
    return 0
  else
    echo "Service ${svc} is not active."
    return 1
  fi
}

# Audit logic begins here

# 1. Check if samba package is installed
check_package_installed "samba"
samba_installed=$?

# 2. If samba is installed, check if the smb.service is enabled or active
if [ $samba_installed -eq 0 ]; then
  check_service_enabled "smb.service"
  smb_service_enabled=$?
  
  check_service_active "smb.service"
  smb_service_active=$?
  
  # Inspect the results from both service checks
  if [ $smb_service_enabled -eq 0 ] || [ $smb_service_active -eq 0 ]; then
    echo "Audit failed: smb.service is enabled or active and samba is installed."
    exit 1
  else
    echo "Audit passed: smb.service is not enabled and not active; samba package is installed for dependencies."
    echo "Ensure compliance with site policy regarding dependent packages."
    exit 0
  fi

# 3. If samba is not installed, the audit passes
else
  echo "Audit passed: samba package is not installed."
  exit 0
fi

# This script audits whether the Samba package is installed and checks the status of the smb.service if necessary. It exits with code `1` if the audit fails, and `0` if it passes. Comments and functions clearly define each step of the audit process.