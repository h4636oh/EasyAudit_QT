#!/bin/bash

# Verify the space_left_action parameter
space_left_action_result=$(grep -Pi -- '^\h*space_left_action\h*=\h*(email|exec|single|halt)\b' /etc/audit/auditd.conf)

if [ -n "$space_left_action_result" ]; then
    echo "space_left_action is set correctly: $space_left_action_result"
else
    echo "space_left_action is not set to email, exec, single, or halt."
    exit 1
fi

# Verify the admin_space_left_action parameter
admin_space_left_action_result=$(grep -Pi -- '^\h*admin_space_left_action\h*=\h*(single|halt)\b' /etc/audit/auditd.conf)

if [ -n "$admin_space_left_action_result" ]; then
    echo "admin_space_left_action is set correctly: $admin_space_left_action_result"
else
    echo "admin_space_left_action is not set to single or halt."
    exit 1
fi

