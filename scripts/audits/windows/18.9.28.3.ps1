#```powershell
# PowerShell 7 Script to Audit the Group Policy Setting for Lock Screen App Notifications

# Define the registry key and value that need to be checked
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
$registryValueName = 'DisableLockScreenAppNotifications'
$expectedValue = 1

# Check if the registry path exists
if (Test-Path $registryPath) {
    # Get the actual value from the registry
    $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue

    if ($null -ne $actualValue) {
        # Compare the actual value with the expected value
        if ($actualValue.$registryValueName -eq $expectedValue) {
            Write-Output "Audit passed: 'DisableLockScreenAppNotifications' is set correctly."
            exit 0
        } else {
            Write-Output "Audit failed: 'DisableLockScreenAppNotifications' is not set to the expected value '$expectedValue'."
            exit 1
        }
    } else {
        Write-Output "Audit failed: The registry value '$registryValueName' does not exist."
        exit 1
    }
} else {
    Write-Output "Audit failed: The registry path '$registryPath' does not exist."
    exit 1
}

# If the required manual confirmation is needed
Write-Output "'Turn off app notifications on the lock screen' should be set to 'Enabled' via Group Policy. Please confirm this manually."
exit 1
# ```
