#```powershell
# PowerShell 7 script to audit the BitLocker policy setting for additional authentication at startup

# Define the registry path and value to check
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$registryValueName = 'UseTPMKey'
$expectedValue = 0

# Attempt to get the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Host "Audit Failed: Could not retrieve registry key $registryPath\$registryValueName"
    Write-Host "Please ensure that the registry path is correct and the value exists."
    exit 1
}

# Check if the registry value matches the expected value
if ($registryValue.$registryValueName -eq $expectedValue) {
    Write-Host "Audit Passed: The BitLocker setting is configured correctly."
    exit 0
} else {
    Write-Host "Audit Failed: The BitLocker setting is not configured as recommended."
    Write-Host "Please navigate to Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> BitLocker Drive Encryption -> Operating System Drives and set 'Require additional authentication at startup: Configure TPM startup key:' to 'Enabled: Do not allow startup key with TPM'."
    exit 1
}
# ```
