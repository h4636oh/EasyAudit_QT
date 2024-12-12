#!/bin/bash

# Check on-disk rules
echo "Checking on-disk rules:"
on_disk_rules1=$(awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -S/ && (/sethostname/ || /setdomainname/) && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules)
on_disk_rules2=$(awk '/^ *-w/ && (/\/etc\/issue/ || /\/etc\/issue.net/ || /\/etc\/hosts/ || /\/etc\/network/ || /\/etc\/netplan/) && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules)

echo "$on_disk_rules1"
echo "$on_disk_rules2"

# Check running configuration rules
echo "Checking running configuration rules:"
running_rules1=$(auditctl -l | awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -S/ && (/sethostname/ || /setdomainname/) && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/')
running_rules2=$(auditctl -l | awk '/^ *-w/ && (/\/etc\/issue/ || /\/etc\/issue.net/ || /\/etc\/hosts/ || /\/etc\/network/ || /\/etc\/netplan/) && / +-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/')

echo "$running_rules1"
echo "$running_rules2"

