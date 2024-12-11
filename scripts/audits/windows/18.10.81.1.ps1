#```powershell
# This script audits the setting for 'Enable MPR notifications for the system' by checking
# the registry value at HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System:EnableMPR.
# The recommended and secure state for this setting is 'Disabled' (with a value of 0).

# Define the registry path and value name.
$registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$valueName = 'EnableMPR'

# Retrieve the current registry value for EnableMPR.
try {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Output "The registry path or value does not exist. Please ensure the path is configured properly."
    exit 1
}

# Check if the value is set to 0 (Disabled).
if ($value.$valueName -eq 0) {
    Write-Output "The 'Enable MPR notifications for the system' is correctly set to 'Disabled'."
    exit 0
} else {
    Write-Output "The 'Enable MPR notifications for the system' is NOT set to 'Disabled'. Please check the Group Policy."
    Write-Output "Manual Check: Navigate to 'Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Windows Logon Options\\Enable MPR notifications for the system' and ensure it is set to 'Disabled'."
    exit 1
}
# ```
