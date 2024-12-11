#```powershell
# PowerShell 7 Script to audit the SMB plaintext password policy setting

# Constants
$RegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters'
$RegistryValueName = 'EnablePlainTextPassword'
$RequiredValue = 0  # The value 0 corresponds to 'Disabled'

try {
    # Check if the registry path exists
    if (-Not (Test-Path $RegistryPath)) {
        Write-Host "Audit failed: Registry path '$RegistryPath' not found."
        exit 1
    }

    # Retrieve the current value of the registry setting
    $currentValue = Get-ItemProperty -Path $RegistryPath -Name $RegistryValueName -ErrorAction Stop | Select-Object -ExpandProperty $RegistryValueName

    # Compare the current value with the required value
    if ($currentValue -eq $RequiredValue) {
        Write-Host "Audit passed: 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'."
        exit 0
    } else {
        Write-Host "Audit failed: 'Microsoft network client: Send unencrypted password to third-party SMB servers' is not set to 'Disabled'."
        Write-Host "Please set the policy manually via Group Policy to 'Disabled'."
        exit 1
    }
} catch {
    # Handle errors during registry operations
    Write-Host "Audit failed: An error occurred while checking the registry value. $_"
    exit 1
}
# ```
