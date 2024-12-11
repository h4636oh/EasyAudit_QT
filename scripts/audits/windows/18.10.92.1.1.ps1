#```powershell
# PowerShell 7 Script to audit the specified Group Policy setting

# Define the registry path and value to check
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
$registryValueName = 'NoAutoRebootWithLoggedOnUsers'
$expectedValue = 0

# Try to retrieve the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

    # Check if the registry value matches the expected value
    if ($registryValue.$registryValueName -eq $expectedValue) {
        Write-Host "Audit Passed: The setting 'No auto-restart with logged on users for scheduled automatic updates installations' is set to 'Disabled'."
        exit 0
    } else {
        Write-Host "Audit Failed: The setting 'No auto-restart with logged on users for scheduled automatic updates installations' is not set to 'Disabled'."
        exit 1
    }
} catch {
    Write-Host "Audit Failed: Unable to read the registry key. Please verify the setting manually via UI path:
    Computer Configuration\Policies\Administrative Templates\Windows Components\Windows Update\Legacy Policies\No auto-restart with logged on users for scheduled automatic updates installations"
    exit 1
}
# ```
