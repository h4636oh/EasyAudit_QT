#!/bin/bash

# Define the expected group name for restricting the su command
EXPECTED_GROUP="sugroup"

# Define the PAM configuration file for su
PAM_SU_FILE="/etc/pam.d/su"

# Audit 1: Check if the PAM configuration restricts su to the expected group
echo "Checking PAM configuration in $PAM_SU_FILE..."
if grep -qE "^auth\s+required\s+pam_wheel\.so\s+.*group=$EXPECTED_GROUP" "$PAM_SU_FILE"; then
  echo "PAM configuration is correctly set to restrict su to the group: $EXPECTED_GROUP."
else
  echo "PAM configuration is NOT correctly set to restrict su to the group: $EXPECTED_GROUP."
  exit 1
fi

# Audit 2: Verify that the specified group exists
echo "Checking if group $EXPECTED_GROUP exists..."
if getent group "$EXPECTED_GROUP" >/dev/null; then
  echo "Group $EXPECTED_GROUP exists."
else
  echo "Group $EXPECTED_GROUP does NOT exist."
  exit 1
fi

# Audit 3: Check if the group is empty
echo "Checking if group $EXPECTED_GROUP is empty..."
GROUP_MEMBERS=$(getent group "$EXPECTED_GROUP" | cut -d: -f4)
if [ -z "$GROUP_MEMBERS" ]; then
  echo "Group $EXPECTED_GROUP is empty as required."
else
  echo "Group $EXPECTED_GROUP is NOT empty. Current members: $GROUP_MEMBERS."
  exit 1
fi

echo "Audit complete: The su command is correctly restricted to $EXPECTED_GROUP and the group is empty."
exit 0
