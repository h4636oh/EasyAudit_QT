#```powershell
# PowerShell 7 script to audit the configuration for Hardened UNC Paths

# Function to check the registry value for a specific path
function Check-UNCPathConfiguration {
    param (
        [string]$registryPath
    )
    
    # Try to get the registry value
    try {
        $regValue = Get-ItemProperty -Path $registryPath -ErrorAction Stop
        $expectedValue = "RequireMutualAuthentication=1,RequireIntegrity=1,RequirePrivacy=1"
        
        if ($regValue -match $expectedValue) {
            return $true
        } else {
            return $false
        }
    } catch {
        # Return false if the registry path or value does not exist
        return $false
    }
}

# Define registry paths for NETLOGON and SYSVOL
$netlogonPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths\\\*\\NETLOGON"
$sysvolPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths\\\*\\SYSVOL"

# Check both paths
$netlogonConfigured = Check-UNCPathConfiguration -registryPath $netlogonPath
$sysvolConfigured = Check-UNCPathConfiguration -registryPath $sysvolPath

# Determine audit result
if ($netlogonConfigured -and $sysvolConfigured) {
    Write-Output "Audit Passed: Both NETLOGON and SYSVOL paths are correctly configured."
    exit 0
} else {
    Write-Output "Audit Failed: Please ensure the following settings are manually configured via Group Policy:"
    Write-Output "1. Ensure 'Hardened UNC Paths' is enabled."
    Write-Output "2. Set 'Require Mutual Authentication', 'Require Integrity', and 'Require Privacy' for the paths:"
    Write-Output "\\*\\NETLOGON"
    Write-Output "\\*\\SYSVOL"
    exit 1
}
# ```
