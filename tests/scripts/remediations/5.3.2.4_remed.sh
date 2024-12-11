#!/usr/bin/env bash

# Check if pam_pwhistory exists in pam-auth-update profiles
echo "Checking for pam_pwhistory in pam-auth-update profiles..."
grep -P -- '\bpam_pwhistory\.so\b' /usr/share/pam-configs/*

# If pam_pwhistory is found in the profiles, enable the profile
if [[ $? -eq 0 ]]; then
    echo "pam_pwhistory profile found. Enabling profile..."
    # Extract profile name from grep output and enable it
    PROFILE_NAME=$(grep -P -- '\bpam_pwhistory\.so\b' /usr/share/pam-configs/* | cut -d ':' -f 1)
    sudo pam-auth-update --enable $(basename "$PROFILE_NAME")
    echo "Profile $PROFILE_NAME enabled."
else
    echo "pam_pwhistory profile not found. Creating new profile..."
    # Create the pam_pwhistory profile
    cat <<EOF | sudo tee /usr/share/pam-configs/pwhistory
Name: pwhistory password history checking
Default: yes
Priority: 1024
Password-Type: Primary
Password:
    requisite pam_pwhistory.so remember=24 enforce_for_root try_first_pass use_authtok
EOF
    echo "New pam_pwhistory profile created."

    # Update the pam.d/common-password with the new profile
    sudo pam-auth-update --enable pwhistory
    echo "pwhistory profile enabled."
fi