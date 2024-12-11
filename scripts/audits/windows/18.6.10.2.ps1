#```powershell
# Script Title: Audit Microsoft Peer-to-Peer Networking Services Setting

# Description:
# This script audits the registry setting for "Turn off Microsoft Peer-to-Peer Networking Services".
# It checks if the registry value is set to 'Enabled' as per the recommended state for high security environments.

# Registry path and value to audit
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Peernet"
$regValueName = "Disabled"
$expectedValue = 1

# Function to audit the registry setting
function Audit-PeerNetworkingService {
    try {
        # Check if the registry path exists
        if (Test-Path -Path $regPath) {
            # Retrieve the actual value of the registry key
            $actualValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction Stop
            # Compare the actual value against the expected value
            if ($actualValue.$regValueName -eq $expectedValue) {
                Write-Host "Audit Passed: 'Turn off Microsoft Peer-to-Peer Networking Services' is set to 'Enabled'."
                exit 0
            } else {
                Write-Host "Audit Failed: 'Turn off Microsoft Peer-to-Peer Networking Services' is not set to 'Enabled'."
                exit 1
            }
        } else {
            Write-Host "Audit Failed: Registry path [$regPath] does not exist."
            exit 1
        }
    } catch {
        Write-Host "An error occurred while auditing: $_"
        exit 1
    }
}

# Run the audit function
Audit-PeerNetworkingService
# ```
