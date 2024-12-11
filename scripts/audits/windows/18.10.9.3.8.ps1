#```powershell
# This script audits the BitLocker recovery policy for removable drives as specified in the input.

# Registry key path and value to verify
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regName = "RDVActiveDirectoryInfoToStore"
$expectedValue = 1  # The expected value for compliance

# Attempt to get the registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
} catch {
    Write-Host "Registry path or value not found. Please ensure BitLocker policies are properly configured."
    exit 1
}

# Compare the current registry value with the expected value
if ($regValue.$regName -eq $expectedValue) {
    Write-Host "Audit Passed: BitLocker recovery information is correctly configured to backup recovery passwords and key packages."
    exit 0
} else {
    Write-Host "Audit Failed: BitLocker recovery information is NOT correctly configured. Please manually verify the policy setting."
    Write-Host "Navigate to: Computer Configuration -> Policies -> Administrative Templates"
    Write-Host "-> Windows Components -> BitLocker Drive Encryption -> Removable Data Drives"
    Write-Host "Ensure the setting 'Choose how BitLocker-protected removable drives can be recovered' is set to 'Enabled: Backup recovery passwords and key packages'."
    exit 1
}
# ```
