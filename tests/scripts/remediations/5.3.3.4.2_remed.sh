#!/usr/bin/env bash

echo "Starting PAM remediation for pam_unix.so 'remember' argument..."

# Search for files containing pam_unix.so with the 'remember' argument
echo "Searching for pam_unix.so lines with 'remember' argument in /usr/share/pam-configs/..."
grep -PH -- '^\h*([^#\n\r]+\h+)?pam_unix\.so\h+([^#\n\r]+\h+)?remember\b' /usr/share/pam-configs/*

# Loop over the returned files and remove the 'remember' argument
for file in $(grep -PH -- '^\h*([^#\n\r]+\h+)?pam_unix\.so\h+([^#\n\r]+\h+)?remember\b' /usr/share/pam-configs/* | cut -d: -f1 | sort -u); do
  echo "Editing file: $file"
  # Remove the 'remember=<N>' argument from the pam_unix.so line(s)
  sed -ri 's/\bremember=\d+\b//g' "$file"
done

# Run pam-auth-update to enable the edited profile
# If custom files are being used, manually update them in /etc/pam.d/
echo "Updating PAM configuration files..."
for file in $(grep -PH -- '^\h*([^#\n\r]+\h+)?pam_unix\.so\h+([^#\n\r]+\h+)?remember\b' /usr/share/pam-configs/* | cut -d: -f1 | sort -u); do
  # Extract the profile name from the filename
  profile_name=$(basename "$file")
  pam-auth-update --enable "$profile_name"
done

echo "Remediation completed."