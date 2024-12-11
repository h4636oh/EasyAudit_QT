#```powershell
# Author: Coding Assistant
# Purpose: Audit whether 'Audit Removable Storage' is set to 'Success and Failure' on a Windows system.

# Check the OS version as the note specifies the requirement for a Windows 8.0, Server 2012 or newer OS.
$osVersion = [System.Environment]::OSVersion.Version
if (($osVersion.Major -lt 6) -or ($osVersion.Major -eq 6 -and $osVersion.Minor -lt 2)) {
    Write-Host "This script requires Windows 8.0, Server 2012 or newer."
    Exit 1
}

# Function to audit 'Audit Removable Storage' setting
function Test-AuditRemovableStorage {
    $auditResult = & auditpol /get /subcategory:"Removable Storage" | Out-String
    # Look for 'Removable Storage' setting in audit policy and check if it is set to 'Success and Failure'
    if ($auditResult -match "Success\s+Failure") {
        Write-Host "'Audit Removable Storage' is correctly set to 'Success and Failure'."
        Exit 0
    } else {
        Write-Host "'Audit Removable Storage' is NOT set to 'Success and Failure'. Please configure it manually in Group Policy."
        Exit 1
    }
}

# Execute the audit function
Test-AuditRemovableStorage
# ```
# 
# This script audits the 'Audit Removable Storage' policy setting to ensure it is configured to 'Success and Failure'. It verifies the operating system is at least Windows 8.0 or Server 2012, as required by the conditions specified. If the audit setting is not configured properly, the script exits with a code of 1, indicating audit failure, otherwise it exits with a code of 0, indicating success.
