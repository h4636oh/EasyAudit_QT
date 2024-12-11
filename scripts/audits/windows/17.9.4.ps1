#```powershell
# PowerShell 7 script to audit if 'Audit Security System Extension' is set to include 'Success'

# Function to audit the security system extension setting
function Audit-SecuritySystemExtension {
    # Run the auditpol command to retrieve settings for Security System Extension
    $auditOutput = auditpol /get /subcategory:"Security System Extension"

    # Check if 'Success' is part of the audit settings
    if ($auditOutput -match "Success") {
        Write-Host "Audit Security System Extension is set to include 'Success'."
        return $true
    } else {
        Write-Host "Audit Security System Extension is NOT set to include 'Success'."
        return $false
    }
}

# Main script execution
$result = Audit-SecuritySystemExtension

# If the audit fails, prompt the user to manually check the configuration
if (-not $result) {
    Write-Host "Please navigate to the following path to manually verify the settings:"
    Write-Host "Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Advanced Audit Policy Configuration\\Audit Policies\\System\\Audit Security System Extension"
    Exit 1
} else {
    Exit 0
}
# ```
