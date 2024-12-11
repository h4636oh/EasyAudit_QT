#```powershell
# This script audits the policy setting for "Audit: Shut down system immediately if unable to log security audits"
# The recommended state for this setting is Disabled. The script checks the registry value to determine compliance.
# Exit 0 if compliant, Exit 1 if non-compliant.

# Registry path and value to check
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$registryValueName = "CrashOnAuditFail"
$desiredValue = 0

try {
    # Attempt to get the current value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

    # Check if the current value matches the desired value
    if ($currentValue.$registryValueName -eq $desiredValue) {
        Write-Output "Audit Passed: The setting 'Audit: Shut down system immediately if unable to log security audits' is set to Disabled."
        exit 0
    } else {
        Write-Output "Audit Failed: The setting 'Audit: Shut down system immediately if unable to log security audits' is not set to Disabled."
        exit 1
    }
} catch {
    # Handle errors such as the registry path or value not existing
    Write-Output "Audit Failed: Unable to retrieve the policy setting from the registry. Ensure the setting exists."
    exit 1
}

# Prompt the user to check the setting manually if needed
Write-Output "Please ensure that the setting is configured manually to 'Disabled' in Group Policy Editor."
Write-Output "Navigate to: Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Local Policies -> Security Options"
Write-Output "Ensure 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'."
# ```
