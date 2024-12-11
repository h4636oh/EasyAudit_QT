#```powershell
# Script Title: Audit MSS: (DisableSavePassword) Setting

# Exit codes:
#   0: Audit Passed
#   1: Audit Failed

# Define the registry path and value name
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\RasMan\Parameters'
$valueName = 'DisableSavePassword'

# Try to get the registry value
try {
    $regValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Registry path or value not found. Please check if the path exists: $registryPath"
    exit 1
}

# Check if the DisableSavePassword value is set to 1 (Enabled)
if ($regValue.$valueName -eq 1) {
    Write-Host "Audit Passed: 'DisableSavePassword' is set to 'Enabled'."
    exit 0
} else {
    Write-Host "Audit Failed: 'DisableSavePassword' is NOT set to 'Enabled'."
    Write-Host "Please navigate to the group policy settings and set 'DisableSavePassword' to 'Enabled'."
    exit 1
}
# ```
