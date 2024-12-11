#!/bin/bash

# Define the pam module name and profile path
l_module_name="pwhistory"
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"

# Check if custom profile is used
if grep -Pq -- '^custom\/' <<< "$l_pam_profile"; then
  l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
  l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Check if pam_pwhistory.so is configured in the password and system-auth files
if grep -Pq -- "\bpam_$l_module_name\.so\b" "$l_pam_profile_path"/{password,system}-auth; then
  echo "pam_pwhistory.so is properly configured."
  exit 0
else
  echo "pam_pwhistory.so is NOT properly configured."
  exit 1
fi
