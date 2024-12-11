#```powershell
# PowerShell 7 Script to Audit User Account Control Policy
# Description: Ensures 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'
# Registry Path: HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
# Registry Key: EnableLUA
# Expected Value: 1
# Exit 0: Pass, Exit 1: Fail

# Function to check the UAC policy setting
function Test-UACPolicy {
    try {
        # Get the current registry value for EnableLUA
        $registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
        $registryKey = 'EnableLUA'
        
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction Stop
        if ($null -ne $currentValue) {
            return $currentValue.$registryKey -eq 1
        }
        else {
            Write-Error "Failed to retrieve the registry value for $registryKey."
            return $false
        }
    } catch {
        Write-Error "An error occurred: $_"
        return $false
    }
}

# Main script logic
if (Test-UACPolicy) {
    Write-Host "Audit Passed: 'User Account Control: Run all administrators in Admin Approval Mode' is enabled."
    exit 0
} else {
    Write-Warning "Audit Failed: Please verify the policy manually by navigating to the UI path: Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options."
    exit 1
}
# ```
