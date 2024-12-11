#```powershell
# Script to audit 'Audit User Account Management' settings

try {
    # Variables
    $subcategory = "User Account Management"
    $expectedSetting = "Both" # Both meaning "Success and Failure"

    # Get the current audit settings for the specified subcategory
    $auditSetting = auditpol /get /subcategory:$subcategory | Select-String -Pattern 'User Account Management\s*:\s*(.*)' | ForEach-Object { $_.Matches[0].Groups[1].Value.Trim() }

    # Check if the current setting matches the expected setting
    if ($auditSetting -eq $expectedSetting) {
        Write-Host "Audit setting for '$subcategory' is correctly set to 'Success and Failure'."
        exit 0
    }
    else {
        Write-Host "Audit setting for '$subcategory' is NOT set to 'Success and Failure'."
        Write-Host "Current setting: $auditSetting"
        Write-Host "Please manually configure this setting via 'Advanced Audit Policy Configuration' in Group Policy to ensure it is set to both 'Success' and 'Failure'."
        exit 1
    }
}
catch {
    Write-Host "An error occurred while performing the audit: $_"
    exit 1
}

# ```
