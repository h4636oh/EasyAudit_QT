#!/usr/bin/env bash

# Verify the pam_wheel.so configuration
pam_config=$(grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(\h+.*)?$' /etc/pam.d/su)

if [[ "$pam_config" == *"auth required pam_wheel.so use_uid group="* ]]; then
  echo "pam_wheel.so configuration is correct:"
  echo "$pam_config"
  
  # Extract the group name from the configuration
  group_name=$(echo "$pam_config" | grep -oP 'group=\K\S+')

  # Verify that the specified group contains no users
  group_info=$(grep "$group_name" /etc/group)

  if [[ "$group_info" == *"$group_name:x:"* ]]; then
    echo "Group $group_name found in /etc/group:"
    echo "$group_info"
    
    # Check if the group contains any users
    if [[ "$group_info" == *"$group_name:x:[^:]*$"* ]]; then
      echo "No users found in the group $group_name."
    else
      echo "Users found in the group $group_name."
      exit 1
    fi
  else
    echo "Group $group_name not found in /etc/group."
  fi
else
  echo "pam_wheel.so configuration is not correct."
  exit 1
fi

