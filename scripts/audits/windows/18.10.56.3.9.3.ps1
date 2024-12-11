#```powershell
# Script to audit that 'Require use of specific security layer for remote (RDP) connections' is set to 'Enabled: SSL'
# Profile Applicability: Level 1 (L1) - Corporate/Enterprise Environment (general use)
# Description: Ensures RDP communication uses TLS 1.0 for enhanced security over RDP's native encryption.

# Define the registry path and value to check
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$registryValueName = 'SecurityLayer'
$expectedValue = 2

# Function to check the SecurityLayer registry value
function Test-RDPSecurityLayer {
    try {
        # Check if the registry key exists
        if (Test-Path -Path $registryPath) {
            # Retrieve the current registry value
            $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
            # Return true if the registry value matches the expected value
            return ($currentValue.$registryValueName -eq $expectedValue)
        } else {
            Write-Host "Registry path does not exist: $registryPath"
            return $false
        }
    } catch {
        Write-Host "Error accessing the registry: $_"
        return $false
    }
}

# Run the audit function
if (Test-RDPSecurityLayer) {
    Write-Host "Audit Passed: 'Require use of specific security layer for remote (RDP) connections' is correctly set to 'Enabled: SSL'."
    exit 0
} else {
    Write-Host "Audit Failed: 'Require use of specific security layer for remote (RDP) connections' is NOT set to 'Enabled: SSL'."
    Write-Host "Please manually check the Group Policy path: Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Remote Desktop Services\\Remote Desktop Session Host\\Security"
    exit 1
}
# ```
# 
# This script evaluates whether the RDP security layer is properly configured to use TLS (as interpreted by a setting of `2` in the registry) and prompts the user to verify manually through Group Policy if it is not. It only audits, as per the requirements, without making any changes.
