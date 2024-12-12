#!/usr/bin/env bash

# Define the minimum required warning age
MIN_WARN_AGE=7

echo "Auditing PASS_WARN_AGE in /etc/login.defs..."
grep -Pi '^\h*PASS_WARN_AGE\h+\d+\b' /etc/login.defs

echo
echo "Checking users in /etc/shadow with PASS_WARN_AGE less than $MIN_WARN_AGE..."
awk -F: '($2~/^\$.+\$/) {if($6 < '"$MIN_WARN_AGE"') print "User: " $1 " PASS_WARN_AGE: " $6}' /etc/shadow

echo
echo "Audit completed."