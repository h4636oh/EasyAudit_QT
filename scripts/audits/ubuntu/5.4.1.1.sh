#!/usr/bin/env bash

echo "Checking PASS_MAX_DAYS in /etc/login.defs..."
grep -Pi '^\h*PASS_MAX_DAYS\h+\d+\b' /etc/login.defs

if [ $? -ne 0 ]; then
    echo "PASS_MAX_DAYS is not set in /etc/login.defs or not found!"
else
    echo "PASS_MAX_DAYS setting in /etc/login.defs:"
    grep -Pi '^\h*PASS_MAX_DAYS\h+\d+\b' /etc/login.defs
fi

echo
echo "Reviewing users' PASS_MAX_DAYS in /etc/shadow..."
awk -F: '($2 ~ /^\$.+\$/) {if($5 > 365 || $5 < 1) print "Non-compliant user: " $1 " | PASS_MAX_DAYS: " $5}' /etc/shadow

if [ $? -ne 0 ]; then
    echo "No non-compliant users found in /etc/shadow."
    exit 1
else
    echo "Review completed."
fi