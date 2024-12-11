#```powershell
# PowerShell 7 Script to audit BitLocker configuration for TPM startup
# This script checks whether the BitLocker group policy for TPM is set to 'Enabled: Do not allow TPM'

# Define the registry path and value to check
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$registryValueName = "UseTPM"

try {
    # Retrieve the current registry value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

    # Audit the configuration: it should be set to 0 (Enabled: Do not allow TPM)
    if ($currentValue.$registryValueName -eq 0) {
        Write-Host "Audit passed: 'Require additional authentication at startup' is correctly set to 'Enabled: Do not allow TPM'."
        exit 0
    } else {
        Write-Host "Audit failed: 'Require additional authentication at startup' is NOT set to 'Enabled: Do not allow TPM'."
        Write-Host "Please ensure the following group policy path is set to 'Enabled: Do not allow TPM':"
        Write-Host "Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Operating System Drives\\Require additional authentication at startup: Configure TPM startup:"
        exit 1
    }
} catch {
    Write-Host "Audit failed: Unable to read the registry value. Please check if the registry path and value are correct."
    exit 1
}

# ```
