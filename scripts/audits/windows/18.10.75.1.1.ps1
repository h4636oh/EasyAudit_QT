#```powershell
# PowerShell 7 script to audit the "Automatic Data Collection" policy for Enhanced Phishing Protection

# Define the registry path and value for the audit
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WTDS\Components'
$registryName = 'CaptureThreatWindow'
$desiredValue = 1

# Check if the registry key exists
if (Test-Path $registryPath) {
    # Get the current registry value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue

    if ($null -ne $currentValue) {
        # Validate the value
        if ($currentValue.$registryName -eq $desiredValue) {
            Write-Output "Audit Passed: 'Automatic Data Collection' is set to 'Enabled'."
            exit 0
        }
        else {
            Write-Output "Audit Failed: 'Automatic Data Collection' is not set to 'Enabled'. Please review the GPO settings."
            exit 1
        }
    }
    else {
        Write-Output "Audit Failed: The registry value '$registryName' does not exist. Please configure it as mentioned in the remediation section."
        exit 1
    }
}
else {
    Write-Output "Audit Failed: The registry path '$registryPath' does not exist. Please follow the manual steps in the remediation section to create the Group Policy."
    exit 1
}

# If the registry path or value is missing, prompt the user to follow the manual remediation steps
Write-Output "Please ensure that the policy 'Automatic Data Collection' is set via Group Policy on the path: "
Write-Output "Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Windows Defender SmartScreen\\Enhanced Phishing Protection\\Automatic Data Collection"
Write-Output "Refer to the Microsoft Windows 11 Release 23H2 Administrative Templates for further details."
exit 1
# ```
