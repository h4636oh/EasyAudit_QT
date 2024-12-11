#```powershell
# PowerShell 7 script to audit 'Audit Logoff' settings using auditpol.exe

# Function to check the audit settings for 'Logoff' subcategory
function Audit-LogoffSetting {
    $auditSettings = & auditpol /get /subcategory:"Logoff" 2>&1
    
    # Check if the auditpol command was successful
    if ($?) {
        # Parse and check the output for 'Success' setting
        if ($auditSettings -match 'Success') {
            Write-Host "'Audit Logoff' is configured to include 'Success'. Audit passed."
            exit 0
        } else {
            Write-Host "'Audit Logoff' is not configured correctly. Please verify settings manually."
            Write-Host "Navigate to Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Logon/Logoff\Audit Logoff"
            exit 1
        }
    } else {
        Write-Host "Failed to retrieve 'Audit Logoff' settings. Error:"
        Write-Host $auditSettings
        exit 1
    }
}

# Call the function to perform the audit
Audit-LogoffSetting
# ```
