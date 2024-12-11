#!/usr/bin/env bash

echo "Starting PAM Audit for INACTIVE password setting..."

# Check if the INACTIVE setting in useradd defaults is set to 45
echo "Checking default INACTIVE setting..."

INACTIVE_DEFAULT=$(useradd -D | grep INACTIVE | awk '{print $2}')

if [[ "$INACTIVE_DEFAULT" -eq 45 ]]; then
  echo "Pass: INACTIVE is set to 45 days in useradd defaults."
else
  echo "Fail: INACTIVE is not set to 45 days in useradd defaults. It is set to $INACTIVE_DEFAULT."
  exit 1
fi

# Check that all users with passwords have their INACTIVE period set to no more than 45 days after expiration
echo "Checking all users with a password for INACTIVE period compliance..."

# Check /etc/shadow for users with an INACTIVE period greater than 45 days
if awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)print "User: " $1 " INACTIVE: " $7}' /etc/shadow | grep -q .; then
  echo "Fail: Some users have an INACTIVE period greater than 45 days or invalid INACTIVE value."
  exit 1
else
  echo "Pass: All users have INACTIVE set to 45 days or less."
fi

# Final audit result
echo "Audit complete. INACTIVE setting conforms to site policy (Pass)."
exit 0
