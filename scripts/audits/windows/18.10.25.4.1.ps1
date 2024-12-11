#```powershell
# Script to audit the Event Log retention setting in Windows
# Requirement: 'System: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'

# Registry key and value details
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System'
$regName = 'Retention'
$desiredValue = '0' # Disabled

try {
    # Get the current registry value
    $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop

    # Check if the current value matches the desired value
    if ($currentValue.$regName -eq $desiredValue) {
        Write-Host "Audit Passed: Setting is correctly configured."
        exit 0
    } else {
        Write-Host "Audit Failed: Setting is not as configured. Modify manually via Group Policy."
        Write-Host "Path: Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\System"
        Write-Host "Control Event Log behavior when the log file reaches its maximum size should be set to 'Disabled'."
        exit 1
    }
} catch {
    # Handle cases where the registry key or value does not exist
    Write-Host "Audit Failed: Registry path or value not found. Modify manually via Group Policy."
    Write-Host "Path: Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\System"
    Write-Host "Control Event Log behavior when the log file reaches its maximum size should be set to 'Disabled'."
    exit 1
}
# ```
# 
# This script checks if the registry setting for controlling Event Log retention is set to 'Disabled' by looking for the appropriate registry entry. If the setting matches the recommended state, it exits with status 0, indicating a pass. Otherwise, it prompts the user to manually verify and configure the Group Policy setting as needed and exits with status 1, indicating a failure.
