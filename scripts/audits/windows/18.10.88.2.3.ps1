#```powershell
# PowerShell 7 Script for Auditing WinRM 'Allow unencrypted traffic' Policy

# Definition of registry path and key
$RegPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service'
$RegKey = 'AllowUnencryptedTraffic'

# Function to audit the 'Allow unencrypted traffic' policy
function Audit-AllowUnencryptedTraffic {
    try {
        # Retrieve the registry key value
        $AllowUnencryptedTraffic = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction Stop
        
        # Check if the value is set to 0 (Disabled)
        if ($AllowUnencryptedTraffic.$RegKey -eq 0) {
            Write-Output "Audit Passed: 'Allow unencrypted traffic' is set to 'Disabled'."
            exit 0
        } else {
            Write-Output "Audit Failed: 'Allow unencrypted traffic' is not set to 'Disabled'."
            exit 1
        }
    } catch {
        Write-Warning "Unable to find the registry key or value. This might mean the policy is not configured via Group Policy."
        Write-Output "Please navigate to the Group Policy path and manually check this setting:"
        Write-Output "Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Windows Remote Management (WinRM) -> WinRM Service -> Allow unencrypted traffic"
        exit 1
    }
}

# Execute the audit function
Audit-AllowUnencryptedTraffic
# ```
# 
