#```powershell
# Ensure the script is only for auditing and not remediating
# This script checks the registry setting for User Account Control: Switch to the secure desktop when prompting for elevation

# Define the registry path and value name
$registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$valueName = 'PromptOnSecureDesktop'

# Try to get the registry value
try {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
    if ($value.$valueName -eq 1) {
        Write-Output "Audit Passed: The setting 'User Account Control: Switch to the secure desktop when prompting for elevation' is enabled."
        exit 0
    } else {
        Write-Warning "Audit Failed: The setting 'User Account Control: Switch to the secure desktop when prompting for elevation' is not enabled."
        Write-Output "Please manually set 'User Account Control: Switch to the secure desktop when prompting for elevation' to Enabled via Group Policy."
        exit 1
    }
} catch {
    Write-Warning "Audit Failed: Unable to retrieve the registry value. Please check if the path is correct and accessible."
    Write-Output "The registry path may not exist or is not accessible. Please verify access permissions."
    exit 1
}
# ```
