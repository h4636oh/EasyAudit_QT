#!/usr/bin/env bash

# Function to create a PAM profile
create_pam_profile() {
    local filename="$1"
    shift
    local lines=("$@")

    echo "Creating PAM profile: $filename"
    printf '%s\n' "${lines[@]}" > "/usr/share/pam-configs/$filename"
}

# Profile 1: Enable pam_faillock to deny access
profile1_name="faillock"
profile1_lines=(
    "Name: Enable pam_faillock to deny access"
    "Default: yes"
    "Priority: 0"
    "Auth-Type: Primary"
    "Auth:"
    " [default=die] pam_faillock.so authfail"
)

# Profile 2: Notify of failed login attempts and reset count upon success
profile2_name="faillock_notify"
profile2_lines=(
    "Name: Notify of failed login attempts and reset count upon success"
    "Default: yes"
    "Priority: 1024"
    "Auth-Type: Primary"
    "Auth:"
    " requisite pam_faillock.so preauth"
    "Account-Type: Primary"
    "Account:"
    " required pam_faillock.so"
)

# Create the profiles
create_pam_profile "$profile1_name" "${profile1_lines[@]}"
create_pam_profile "$profile2_name" "${profile2_lines[@]}"

# Update PAM with the new profiles
echo "Updating PAM configuration with new profiles..."
pam-auth-update --enable "$profile1_name"
pam-auth-update --enable "$profile2_name"

echo "PAM configuration updated successfully."