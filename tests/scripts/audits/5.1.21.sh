#!/usr/bin/env bash

# Check if PermitUserEnvironment is set to no
if sshd -T | grep -i -q permituserenvironment | grep -i -q "permituserenvironment no"; then
  echo "PASS: PermitUserEnvironment is set to no."
  exit 0
else
  echo "FAIL: PermitUserEnvironment is not set to no."
  exit 1
fi
