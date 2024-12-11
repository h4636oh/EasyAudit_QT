#```powershell
# This script audits the 'Windows Error Reporting Service (WerSvc)' setting to ensure it is disabled.
# The audit checks the registry value to confirm the service is set as recommended.
# It returns exit 0 if compliant and exit 1 if non-compliant.

# Define the registry path and desired value
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\WerSvc"
$registryProperty = "Start"
$desiredValue = 4

# Attempt to read the current registry value
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryProperty -ErrorAction Stop
} catch {
    Write-Host "Error: Unable to access the registry path or property."
    exit 1
}

# Check if the current setting matches the desired setting
if ($currentValue.$registryProperty -eq $desiredValue) {
    Write-Host "Audit passed: 'Windows Error Reporting Service (WerSvc)' is correctly set to 'Disabled'."
    exit 0
} else {
    Write-Host "Audit failed: 'Windows Error Reporting Service (WerSvc)' is not set to 'Disabled'."
    Write-Host "Please manually verify and set the group policy as follows:"
    Write-Host "'Computer Configuration\\Policies\\Windows Settings\\Security Settings\\System Services\\Windows Error Reporting Service' to 'Disabled'."
    exit 1
}
# ```
