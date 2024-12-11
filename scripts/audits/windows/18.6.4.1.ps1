#```powershell
# Audit Script: Ensure 'Configure DNS over HTTPS (DoH) name resolution' is set to 'Enabled: Allow DoH' or higher (Automated)

# Define the registry path and value name for DoH policy configuration
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
$valueName = "DoHPolicy"

try {
    # Check if the registry key exists
    if (Test-Path $registryPath) {
        # Retrieve the current DoHPolicy value from the registry
        $dohPolicyValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

        # Check if the value is either 2 (Enabled: Allow DoH) or 3 (Enabled: Require DoH)
        if ($dohPolicyValue.$valueName -eq 2 -or $dohPolicyValue.$valueName -eq 3) {
            Write-Output "Audit Passed: DNS over HTTPS (DoH) is correctly configured."
            exit 0
        } else {
            Write-Output "Audit Failed: DNS over HTTPS (DoH) is not correctly configured. Expected value is 2 or 3."
            exit 1
        }
    } else {
        Write-Output "Audit Failed: The registry path for DNS over HTTPS (DoH) configuration was not found."
        exit 1
    }
} catch {
    # Handle exceptions and output an error message before exiting
    Write-Output "Audit Failed: An error occurred while checking the DNS over HTTPS (DoH) configuration."
    exit 1
}

# If manual verification is necessary, prompt the user at the end of the script
Write-Output "Manual Verification Required: Please navigate to the Group Policy at 'Computer Configuration\\Policies\\Administrative Templates\\Network\\DNS Client\\Configure DNS over HTTPS (DoH) name resolution' and ensure it is set to 'Enabled: Allow DoH' or higher."
# ```
# 
# This PowerShell 7 script audits the configuration of DNS over HTTPS (DoH) by checking the corresponding registry settings. It exits with a status of 0 if the audit passes (correct configuration) or 1 if it fails. Additionally, it prompts the user to manually verify the Group Policy settings for complete assurance.
