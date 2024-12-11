#```powershell
# PowerShell 7 Script to Audit NetBT NodeType Configuration
# Profile Applicability: Level 1 (L1) - Corporate/Enterprise Environment
# This script checks if the NetBT NodeType registry setting is set to P-node (recommended)
# It must be used to audit and not remediate any issues.

# Define the registry path and expected value
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters'
$registryValueName = 'NodeType'
$expectedValue = 2 # P-node (point-to-point)

# Attempt to retrieve the NodeType registry value
try {
    $nodeTypeValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Host "NodeType registry value not found at $registryPath"
    Write-Host "Please ensure the registry key exists and check manually as per the remediation instructions."
    exit 1 # Exit with code 1 to indicate failure in audit
}

# Check if the NodeType is set to the expected value
if ($nodeTypeValue.$registryValueName -eq $expectedValue) {
    Write-Host "Audit Passed: NetBT NodeType is correctly set to P-node."
    exit 0 # Exit with code 0 to indicate success in audit
} else {
    Write-Host "Audit Failed: NetBT NodeType is NOT set to P-node."
    Write-Host "Current Value: $($nodeTypeValue.$registryValueName)"
    Write-Host "Please configure the setting manually as per remediation instructions if necessary."
    exit 1 # Exit with code 1 to indicate failure in audit
}
# ```
