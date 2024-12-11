#!/usr/bin/env bash

# Check on-disk rules
echo "Checking on-disk rules:"
on_disk_rules=$(awk '/^ *-w/ \
&&(/\/var\/log\/lastlog/ \
 ||/\/var\/run\/faillock/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules)

expected_on_disk_rules=(
"-w /var/log/lastlog -p wa -k logins"
"-w /var/run/faillock -p wa -k logins"
)

for rule in "${expected_on_disk_rules[@]}"; do
    if echo "$on_disk_rules" | grep -q "$rule"; then
        echo "OK: '$rule' found in on-disk configuration."
    else
        echo "Warning: '$rule' not found in on-disk configuration."
        exit 1
    fi
done

# Check running configuration rules
echo "Checking running configuration rules:"
running_rules=$(auditctl -l | awk '/^ *-w/ \
&&(/\/var\/log\/lastlog/ \
 ||/\/var\/run\/faillock/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/')

expected_running_rules=(
"-w /var/log/lastlog -p wa -k logins"
"-w /var/run/faillock -p wa -k logins"
)

for rule in "${expected_running_rules[@]}"; do
    if echo "$running_rules" | grep -q "$rule"; then
        echo "OK: '$rule' found in running configuration."
    else
        echo "Warning: '$rule' not found in running configuration."
        exit 1
    fi
done

