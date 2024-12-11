#```powershell
# Define the registry path and value name according to the audit instructions
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$valueName = "EnableUiaRedirection"
$expectedValue = 0

# Check if the registry key exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist: $registryPath"
    Write-Host "Please check the group policy detailed in the remediation section to ensure it is applied correctly."
    exit 1
}

# Retrieve the current value of the registry key
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $currentValue) {
    Write-Host "Registry key does not exist: $registryPath\$valueName"
    Write-Host "This means the policy might not be applied. Please confirm manually."
    exit 1
}

# Compare the current value with the expected value
if ($currentValue.$valueName -eq $expectedValue) {
    Write-Host "Audit Passed: 'Allow UI Automation redirection' is set to 'Disabled'."
    exit 0
} else {
    Write-Host "Audit Failed: 'Allow UI Automation redirection' is not set to 'Disabled'."
    Write-Host "Current Value: $($currentValue.$valueName)"
    Write-Host "Expected Value: $expectedValue"
    Write-Host "Please review the group policy settings as indicated in the remediation section."
    exit 1
}
# ```
