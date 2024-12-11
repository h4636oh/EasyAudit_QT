#```powershell
# This script audits the configuration for BitLocker-protected removable drives
# to ensure it is set to "Enabled: Do not allow 256-bit recovery key".
# The script will exit with code 1 if the audit fails and code 0 if it passes.

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$valueName = "RDVRecoveryKey"

# Attempt to retrieve the current registry value
try {
    $regValue = Get-ItemProperty -Path $registryPath -ErrorAction Stop
    $currentValue = $regValue.$valueName
    # Expected value is 0 for "Do not allow 256-bit recovery key"
    $expectedValue = 0

    if ($currentValue -eq $expectedValue) {
        Write-Host "Audit passed: The BitLocker recovery key setting is configured correctly."
        exit 0
    }
    else {
        Write-Host "Audit failed: The BitLocker recovery key setting is not configured as expected."
        Write-Host "Manual Remediation Required: Navigate to 'Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Removable Data Drives\\Choose how BitLocker-protected removable drives can be recovered: Recovery Key' and set 'Enabled: Do not allow 256-bit recovery key'."
        exit 1
    }
}
catch {
    Write-Host "Audit failed: Could not access the registry or the value does not exist."
    Write-Host "Ensure that BitLocker policies are configured correctly in Group Policies."
    Write-Host "Manual Remediation Required: Navigate to 'Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Removable Data Drives\\Choose how BitLocker-protected removable drives can be recovered: Recovery Key' and set 'Enabled: Do not allow 256-bit recovery key'."
    exit 1
}
# ```
