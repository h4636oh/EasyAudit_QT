#```powershell
# PowerShell 7 Script to Audit BitLocker Configuration for Hardware-Based Encryption on Removable Data Drives

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$valueName = "RDVHardwareEncryption"
$expectedValue = 0

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    # Get the actual registry value
    $actualValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

    # Validate if the actual value matches the expected value
    if ($null -ne $actualValue -and $actualValue.$valueName -eq $expectedValue) {
        Write-Output "Audit Passed: 'Configure use of hardware-based encryption for removable data drives' is set to 'Disabled'."
        exit 0
    } else {
        Write-Output "Audit Failed: 'Configure use of hardware-based encryption for removable data drives' is not set to 'Disabled'."
        Write-Output "Navigate to the Group Policy Editor and ensure the setting at the following path is set to 'Disabled':"
        Write-Output "Computer Configuration\Policies\Administrative Templates\Windows Components\BitLocker Drive Encryption\Removable Data Drives\Configure use of hardware-based encryption for removable data drives"
        exit 1
    }
} else {
    Write-Output "Audit Failed: Registry path $registryPath not found."
    Write-Output "Navigate to the Group Policy Editor and ensure the setting at the following path is set to 'Disabled':"
    Write-Output "Computer Configuration\Policies\Administrative Templates\Windows Components\BitLocker Drive Encryption\Removable Data Drives\Configure use of hardware-based encryption for removable data drives"
    exit 1
}
# ```
# 
