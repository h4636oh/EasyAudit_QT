#!/usr/bin/env bash

# Script to remediate password complexity settings

echo "Starting remediation of password complexity settings..."

# 1. Search and remove the minclass, dcredit, ucredit, lcredit, and ocredit arguments from pam_pwquality.so in pam-configs
echo "Removing minclass, dcredit, ucredit, lcredit, and ocredit arguments from pam_pwquality.so in /usr/share/pam-configs/..."

grep -Pl -- '\bpam_pwquality\.so\h+([^#\n\r]+\h+)?(minclass|[dulo]credit)\b' /usr/share/pam-configs/* | while read -r file; do
    echo "Editing file: $file"
    # Remove the arguments from the pam_pwquality.so line
    sed -i '/pam_pwquality\.so/ s/\s*\(minclass=[^ ]*\|[dulo]credit=[^ ]*\)//g' "$file"
done

# 2. Create or modify the complexity file to set the desired complexity values
echo "Creating or modifying the complexity configuration..."

# Set complexity policy (example policy: minclass=3, dcredit=-1, ucredit=-1, lcredit=-1, ocredit=-1)
complexity_config="/etc/security/pwquality.conf.d/50-pwcomplexity.conf"

# Ensure the directory exists
[ ! -d /etc/security/pwquality.conf.d/ ] && mkdir -p /etc/security/pwquality.conf.d/

# Create or modify the complexity configuration file with the desired values
cat <<EOF > "$complexity_config"
# Password complexity settings
minclass = 3
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
EOF

echo "Remediation completed successfully."