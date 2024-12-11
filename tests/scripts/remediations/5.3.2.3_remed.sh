#!/usr/bin/env bash

# Check if pam_pwquality is configured in any pam-auth-update profiles
echo "Checking for pam_pwquality in existing pam-auth-update profiles..."
grep -P -- '\bpam_pwquality\.so\b' /usr/share/pam-configs/*

# Check the result of the grep command
if [[ $? -eq 0 ]]; then
    echo "pam_pwquality is already configured in the pam-auth-update profiles."
    echo "Updating /etc/pam.d/common-password with the appropriate profile..."

    # Run pam-auth-update to enable the profile
    # You can manually identify the profile name from the output above
    echo "Enable pam_pwquality profile with pam-auth-update:"
    pam-auth-update --enable pwquality
else
    echo "pam_pwquality is not found in the pam-auth-update profiles. Creating a new profile..."

    # Create the profile for pwquality
    echo "Creating the pam_pwquality profile..."
    cat <<EOL > /usr/share/pam-configs/pwquality
Name: Pwquality password strength checking
Default: yes
Priority: 1024
Conflicts: cracklib
Password-Type: Primary
Password:
  requisite pam_pwquality.so retry=3
Password-Initial:
  requisite
EOL

    # Enable the newly created profile using pam-auth-update
    echo "Updating /etc/pam.d/common-password with the pwquality profile..."
    pam-auth-update --enable pwquality
fi