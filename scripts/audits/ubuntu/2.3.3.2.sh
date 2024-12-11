#!/bin/bash

# Check if chronyd is running as the _chrony user
result=$(ps -ef | awk '(/[c]hronyd/ && $1!="_chrony") { print $1 }')

if [[ -n $result ]]; then
    echo "chronyd is not running as _chrony user. Found: $result"
    exit 1
else
    echo "chronyd is running as _chrony user."
fi

