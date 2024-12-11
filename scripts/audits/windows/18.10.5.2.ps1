#```powershell
# PowerShell 7 Script to Audit the Group Policy State
# Objective: Check whether the 'Block launching Universal Windows apps with
# Windows Runtime API access from hosted content' policy is set to 'Enabled'.
# Registry Path: HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
# Registry Key: BlockHostedAppAccessWinRT
# Expected Value: 1 (Enabled)

# Define the registry path and key
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$registryKey = "BlockHostedAppAccessWinRT"
$expectedValue = 1

# Retrieve the current value from the registry
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction Stop
} catch {
    Write-Host "Registry key not found. Please ensure the policy is enforced manually." 
    # Exit with code 1 indicating audit failure due to missing registry key
    exit 1
}

# Compare the current registry value with the expected value
if ($currentValue.$registryKey -eq $expectedValue) {
    Write-Host "Audit Passed: The policy is set to 'Enabled'."
    # Exit with code 0 indicating audit success
    exit 0
} else {
    Write-Host "Audit Failed: The policy is NOT set to 'Enabled'. Please ensure it is configured manually."
    # Exit with code 1 indicating audit failure
    exit 1
}
# ```
