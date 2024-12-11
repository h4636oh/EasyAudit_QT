#```powershell
# PowerShell 7 Script to Audit BitLocker Data Recovery Agent Setting

# Define the registry key and value name for checking the BitLocker setting
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$valueName = "OSManageDRA"
$expectedValue = 0

# Get the current value of the registry setting
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop | Select-Object -ExpandProperty $valueName
} catch {
    # Failed to retrieve the setting; prompt user for manual verification
    Write-Host "Unable to read the registry value for BitLocker Data Recovery Agent setting."
    Write-Host "Please verify manually whether the policy is set to 'Allow data recovery agent: Disabled (unchecked)'."
    exit 1
}

# Check if the current registry value matches the expected configuration
if ($currentValue -eq $expectedValue) {
    Write-Host "Audit Passed: The BitLocker Data Recovery Agent setting is configured correctly."
    exit 0
} else {
    Write-Host "Audit Failed: The BitLocker Data Recovery Agent setting is NOT configured as recommended."
    Write-Host "Please set 'Choose how BitLocker-protected OS drives can be recovered: Allow data recovery agent' to 'Disabled (unchecked)'."
    exit 1
}
# ```
# 
# This script audits the BitLocker Data Recovery Agent policy by checking the specified registry path and value against its expected state. If it cannot retrieve the setting, it prompts the user to manually verify the policy configuration. If the value does not match the expected configuration, it provides guidance to correct it manually. The script will exit with code 0 if the audit passes and code 1 if it fails.
