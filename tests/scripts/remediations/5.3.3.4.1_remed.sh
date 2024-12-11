#!/usr/bin/env bash

echo "Starting PAM remediation for pam_unix.so 'nullok' argument..."

# Search for pam_unix.so with nullok in /usr/share/pam-configs
echo "Searching for 'nullok' argument in pam_unix.so lines..."
grep -PH -- '^\h*([^#\n\r]+\h+)?pam_unix\.so\h+([^#\n\r]+\h+)?nullok\b' /usr/share/pam-configs/*

# Process files to remove 'nullok' argument
echo "Removing 'nullok' argument from pam_unix.so lines..."
for FILE in $(grep -PHl -- '^\h*([^#\n\r]+\h+)?pam_unix\.so\h+([^#\n\r]+\h+)?nullok\b' /usr/share/pam-configs/*); do
  echo "Editing file: $FILE"
  sed -i 's/\bnullok\b//g' "$FILE" # Remove 'nullok' argument
done

# Run pam-auth-update if the files are modified
echo "Updating PAM configuration..."
for FILE in $(grep -PHl -- '^\h*([^#\n\r]+\h+)?pam_unix\.so\h+([^#\n\r]+\h+)?nullok\b' /usr/share/pam-configs/*); do
  PROFILE_NAME=$(basename "$FILE" | sed 's/\.conf//')
  echo "Enabling modified profile: $PROFILE_NAME"
  pam-auth-update --enable "$PROFILE_NAME"
done

# Check and edit files in /etc/pam.d/ if custom files are being used
echo "Checking /etc/pam.d/ directory for custom files..."

for FILE in /etc/pam.d/*; do
  echo "Checking $FILE..."
  if grep -q 'pam_unix.so' "$FILE" && grep -q 'nullok' "$FILE"; then
    echo "Removing 'nullok' argument from $FILE"
    sed -i 's/\bnullok\b//g' "$FILE" # Remove 'nullok' argument
  fi
done

echo "PAM remediation complete."