#```powershell
# This script audits the configuration setting for Remote Desktop Services (TermService) 
# to ensure it is set to 'Disabled' in a high security/sensitive data environment.

$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\TermService"
$registryValueName = "Start"
$desiredValue = 4

# Function to check the current Remote Desktop Services (TermService) setting
function Test-TermServiceSetting {
    try {
        # Get the current value of the Start registry key
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

        # Check if the current value matches the desired value
        if ($currentValue.$registryValueName -eq $desiredValue) {
            Write-Output "Audit Passed: Remote Desktop Services (TermService) is set to 'Disabled'."
            return $true
        } else {
            Write-Output "Audit Failed: Remote Desktop Services (TermService) is NOT set to 'Disabled'."
            Write-Output "Please manually set this via Group Policy: Computer Configuration\\Policies\\Windows Settings\\Security Settings\\System Services\\Remote Desktop Services"
            return $false
        }
    } catch {
        Write-Output "Audit Failed: Unable to read or determine the setting, please check access permissions."
        return $false
    }
}

# Perform the audit and set the exit code accordingly
if (Test-TermServiceSetting) {
    
    exit 0
} else {
    exit 1
}
# ```
