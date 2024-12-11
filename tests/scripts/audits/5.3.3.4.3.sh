#!/usr/bin/env bash

echo "Starting PAM audit for strong password hashing algorithm..."

# Check if 'sha512' or 'yescrypt' is set in the pam_unix.so line in /etc/pam.d/common-password
echo "Verifying if sha512 or yescrypt is set on pam_unix.so in /etc/pam.d/common-password..."

grep -PH -- '^\h*password\h+([^#\n\r]+)\h+pam_unix\.so\h+([^#\n\r]+\h+)?(sha512|yescrypt)\b' /etc/pam.d/common-password

# Capture the result of the grep command
if [[ $? -eq 0 ]]; then
  echo "Password hashing algorithm (sha512 or yescrypt) is correctly set."
else
  echo "ERROR: No strong password hashing algorithm (sha512 or yescrypt) found in pam_unix.so line."
  echo "Please ensure that the pam_unix.so line in /etc/pam.d/common-password includes either sha512 or yescrypt."
fi

echo "Audit completed."