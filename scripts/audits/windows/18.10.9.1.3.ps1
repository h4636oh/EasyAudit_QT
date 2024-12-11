#```powershell
# The script audits the BitLocker policy setting to ensure 'Allow data recovery agent' is set to Enabled.
# It checks the registry value HKLM\SOFTWARE\Policies\Microsoft\FVE:FDVManageDRA for compliance.
# An exit code of 0 indicates the audit passed; an exit code of 1 indicates it failed.

# Registry path and value to check
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$registryValueName = 'FDVManageDRA'
$expectedValue = 1

# Check if the registry path exists
if (Test-Path $registryPath) {
    # Retrieve the value from the registry
    $actualValue = (Get-ItemProperty -Path $registryPath).$registryValueName

    # Compare the actual and expected values
    if ($actualValue -eq $expectedValue) {
        Write-Output "Audit Passed: 'Allow data recovery agent' is enabled."
        exit 0
    } else {
        Write-Output "Audit Failed: 'Allow data recovery agent' is not enabled. Expected value: $expectedValue, Actual value: $actualValue."
        exit 1
    }
} else {
    Write-Output "Audit Failed: Registry path $registryPath does not exist."
    exit 1
}

# Prompt user for manual actions if necessary
Write-Output "If the registry settings do not match the expected values, please configure the Group Policy manually as follows:"
Write-Output "Navigate to Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Fixed Data Drives"
Write-Output "Verify 'Choose how BitLocker-protected fixed drives can be recovered: Allow data recovery agent' is set to 'Enabled: True (checked)'."
# ```
