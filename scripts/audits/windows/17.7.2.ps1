#```powershell
# PowerShell 7 Script to Audit 'Authentication Policy Change' Setting

# Function to check audit setting for 'Authentication Policy Change'
function Test-AuthenticationPolicyChangeAuditSetting {
    # Execute auditpol command to retrieve the current setting
    $auditSetting = & auditpol.exe /get /subcategory:"Authentication Policy Change" 2>&1

    # Check if the command completed successfully
    if ($auditSetting -is [System.Management.Automation.ErrorRecord]) {
        Write-Error "Failed to retrieve audit setting: $auditSetting"
        exit 1
    }

    # Parse the output to determine if 'Success' is enabled
    if ($auditSetting -match "Success") {
        Write-Host "Audit setting for 'Authentication Policy Change' includes 'Success' - PASS"
        exit 0
    } else {
        Write-Host "Audit setting for 'Authentication Policy Change' does NOT include 'Success' - FAIL"
        # Prompting the user for manual verification/configuration as remediation involves manual steps
        Write-Host "Please check the setting manually or consult the remediation section to ensure the policy includes 'Success'."
        exit 1
    }
}

# Call the function to perform the audit
Test-AuthenticationPolicyChangeAuditSetting
# ```
