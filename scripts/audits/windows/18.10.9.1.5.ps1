#```powershell
# This script audits the BitLocker policy setting for 'Choose how BitLocker-protected fixed drives can be recovered: Recovery Key'.
# It ensures the setting is configured to 'Enabled: Allow 256-bit recovery key' or 'Enabled: Require 256-bit recovery key'.

$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$registryValueName = 'FDVRecoveryKey'
$expectedValues = @(1, 2)  # 1: Allow 256-bit recovery key, 2: Require 256-bit recovery key

# Fetch the current registry value
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Host "Audit Failed: Unable to retrieve registry setting. Ensure the registry key exists."
    exit 1
}

# Check if the current value matches one of the expected values
if ($expectedValues -contains $currentValue.$registryValueName) {
    Write-Host "Audit Passed: BitLocker recovery key setting is correctly configured."
    exit 0
} else {
    Write-Host "Audit Failed: BitLocker recovery key setting is not configured as expected."
    Write-Host "Please navigate to 'Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Fixed Data Drives' to manually set:"
    Write-Host "'Choose how BitLocker-protected fixed drives can be recovered: Recovery Key' to 'Enabled: Allow 256-bit recovery key' or 'Enabled: Require 256-bit recovery key'."
    exit 1
}
# ```
