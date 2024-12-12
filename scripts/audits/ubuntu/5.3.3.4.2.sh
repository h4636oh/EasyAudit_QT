#!/usr/bin/env bash

echo "Starting PAM audit for pam_unix.so 'remember' argument..."

# Check for the pam_unix.so lines that include the 'remember' argument
echo "Checking PAM files for pam_unix.so lines with the 'remember' argument..."
grep -PH -- '^\h*^\h*[^#\n\r]+\h+pam_unix\.so\b' /etc/pam.d/common-{password,auth,account,session,session-noninteractive} | grep -Pv '\bremember=\d+\b'

echo "Audit completed."