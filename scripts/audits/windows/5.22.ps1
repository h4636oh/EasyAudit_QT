#```powershell
# This script audits the configuration of the Remote Desktop Services UserMode Port Redirector.
# It checks the registry value corresponding to the redirection settings for RDP connections.
# Ensure to run this script with necessary permissions to read the registry.

# Define the registry path and value names
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\UmRdpService"
$registryValueName = "Start"
$desiredValue = 4  # Disabled state

# Check if the registry key exists
if (Test-Path $registryPath) {
    # Retrieve the registry value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue

    # Check if the current registry value matches the desired state
    if ($currentValue.$registryValueName -eq $desiredValue) {
        Write-Output "Audit Passed: The Remote Desktop Services UserMode Port Redirector is set to 'Disabled'."
        exit 0
    }
    else {
        Write-Warning "Audit Failed: The Remote Desktop Services UserMode Port Redirector is NOT set to 'Disabled'."
        Write-Warning "Please manually verify the setting in the Group Policy UI path: Computer Configuration\Policies\Windows Settings\Security Settings\System Services\Remote Desktop Services UserMode Port Redirector"
        exit 1
    }
}
else {
    Write-Warning "Audit Failed: The registry path '$registryPath' does not exist."
    exit 1
}
# ```
