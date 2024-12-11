#```powershell
# PowerShell 7 Script to Audit ICMP Redirect Settings
# Objective: Ensure that ICMP redirects to override OSPF generated routes are disabled.
# Exit Status: 0 for pass, 1 for fail
# Profile Applicability: Level 1 (L1) - Corporate/Enterprise Environment

# Registry path to audit
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$regName = "EnableICMPRedirect"
$desiredValue = 0

# Function to check the ICMP redirect setting
function Test-ICMPRedirect {
    try {
        # Get the current registry value
        $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop

        # Compare the current value with the desired value
        if ($currentValue.$regName -eq $desiredValue) {
            Write-Host "Audit passed: ICMP redirects are disabled as recommended."
            exit 0
        } else {
            Write-Host "Audit failed: ICMP redirects are not disabled. Please review Group Policy settings."
            exit 1
        }
    } catch {
        # Handle case where the registry value does not exist
        Write-Host "Audit failed: Unable to find the ICMP redirect setting. It may not be configured."
        exit 1
    }
}

# Main script execution
Test-ICMPRedirect
# ```
