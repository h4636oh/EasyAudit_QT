#!/usr/bin/env bash

# Check on-disk rules
echo "Checking on-disk rules:"
on_disk_rules=$(awk '/^ *-w/ \
&&(/\/etc\/apparmor/ \
 ||/\/etc\/apparmor.d/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules)

expected_on_disk_rules=(
"-w /etc/apparmor/ -p wa -k MAC-policy"
"-w /etc/apparmor.d/ -p wa -k MAC-policy"
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
&&(/\/etc\/apparmor/ \
 ||/\/etc\/apparmor.d/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$)/')

for rule in "${expected_on_disk_rules[@]}"; do
    if echo "$running_rules" | grep -q "$rule"; then
        echo "OK: '$rule' found in running configuration."
    else
        echo "Warning: '$rule' not found in running configuration."
        exit 1
    fi
done

