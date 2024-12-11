#```powershell
# PowerShell 7 Script to Audit BitLocker Recovery Informatio Setup

# Define the registry path and value name
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$valueName = 'FDVRequireActiveDirectoryBackup'

# Attempt to retrieve the registry value
try {
    $regValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Registry path or value not found. Please ensure the policy is configured correctly."
    exit 1
}

# Check if the policy is set as advised: Enabled: False (value should be 0)
if ($regValue.$valueName -eq 0) {
    Write-Host "Audit Passed: The setting for 'Choose how BitLocker-protected fixed drives can be recovered' is set to 'Enabled: False'."
    exit 0
} else {
    Write-Host "Audit Failed: The setting for 'Choose how BitLocker-protected fixed drives can be recovered' is not set to 'Enabled: False'. Please manually ensure the policy is correctly configured."
    exit 1
}
# ```
# 
# This script checks if the Group Policy setting "Choose how BitLocker-protected fixed drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives" is configured correctly. It audits the registry to verify if the value at `HKLM\SOFTWARE\Policies\Microsoft\FVE:FDVRequireActiveDirectoryBackup` is set to `0`, indicating the setting is 'Enabled: False'. If the setting is incorrect or the registry path/value does not exist, it will prompt the user to check the configuration manually and exit with failure.
