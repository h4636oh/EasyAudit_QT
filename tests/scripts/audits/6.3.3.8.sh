#!/usr/bin/env bash

# Check on-disk rules
echo "Checking on-disk rules:"
on_disk_rules=$(awk '/^ *-w/ \
&&(/\/etc\/group/ \
 ||/\/etc\/passwd/ \
 ||/\/etc\/gshadow/ \
 ||/\/etc\/shadow/ \
 ||/\/etc\/security\/opasswd/ \
 ||/\/etc\/nsswitch.conf/ \
 ||/\/etc\/pam.conf/ \
 ||/\/etc\/pam.d/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules)

expected_on_disk_rules=(
"-w /etc/group -p wa -k identity"
"-w /etc/passwd -p wa -k identity"
"-w /etc/gshadow -p wa -k identity"
"-w /etc/shadow -p wa -k identity"
"-w /etc/security/opasswd -p wa -k identity"
"-w /etc/nsswitch.conf -p wa -k identity"
"-w /etc/pam.conf -p wa -k identity"
"-w /etc/pam.d -p wa -k identity"
)

for rule in "${expected_on_disk_rules[@]}"; do
    if echo "$on_disk_rules" | grep -q "$rule"; then
        echo "OK: '$rule' found in on-disk configuration."
    else
        echo "Warning: '$rule' not found in on-disk configuration."
    fi
done

# Check running configuration rules
echo "Checking running configuration rules:"
running_rules=$(auditctl -l | awk '/^ *-w/ \
&&(/\/etc\/group/ \
 ||/\/etc\/passwd/ \
 ||/\/etc\/gshadow/ \
 ||/\/etc\/shadow/ \
 ||/\/etc\/security\/opasswd/ \
 ||/\/etc\/nsswitch.conf/ \
 ||/\/etc\/pam.conf/ \
 ||/\/etc\/pam.d/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/')

expected_running_rules=(
"-w /etc/group -p wa -k identity"
"-w /etc/passwd -p wa -k identity"
"-w /etc/gshadow -p wa -k identity"
"-w /etc/shadow -p wa -k identity"
"-w /etc/security/opasswd -p wa -k identity"
"-w /etc/nsswitch.conf -p wa -k identity"
"-w /etc/pam.conf -p wa -k identity"
"-w /etc/pam.d -p wa -k identity"
)

for rule in "${expected_running_rules[@]}"; do
    if echo "$running_rules" | grep -q "$rule"; then
        echo "OK: '$rule' found in running configuration."
    else
        echo "Warning: '$rule' not found in running configuration."
        exit 1
    fi
done

