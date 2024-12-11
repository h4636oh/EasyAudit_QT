#!/bin/bash

# Function to check kernel parameters
check_kernel_param() {
  local param_name="$1"
  local expected_value="$2"
  
  # Get current value of the kernel parameter
  local current_value
  current_value=$(sysctl -n "$param_name" 2>/dev/null)

  if [ "$current_value" != "$expected_value" ]; then
    echo " - \"$param_name\" is incorrectly set to \"$current_value\" in the running configuration and should have a value of \"$expected_value\"."
    return 1
  else
    echo " - \"$param_name\" is correctly set to \"$current_value\" in the running configuration."
    return 0
  fi
}

# Parameters to check
declare -A kernel_params
kernel_params=(
  ["net.ipv4.conf.all.secure_redirects"]="0"
  ["net.ipv4.conf.default.secure_redirects"]="0"
)

# Initialize audit result
audit_fail=0

echo "Starting audit..."

# Audit each kernel parameter
for param_name in "${!kernel_params[@]}"; do
  expected_value=${kernel_params[$param_name]}
  
  if ! check_kernel_param "$param_name" "$expected_value" ; then
    audit_fail=1
  fi
done

# Output the results of the audit
if [ "$audit_fail" -eq 1 ]; then
  echo -e "\n- Audit Result:\n ** FAIL **"
  exit 1
else
  echo -e "\n- Audit Result:\n ** PASS **"
  exit 0
fi

# Note: This script checks if the specified kernel parameters are set correctly for security as per guidelines. It does not perform any remediation. If the parameters are set incorrectly, the script will output the issues found and exit with status 1.