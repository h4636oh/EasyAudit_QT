#```powershell
# This script audits if the Windows Spotlight features are turned off
# Registry location: HKU\[USER SID]\Software\Policies\Microsoft\Windows\CloudContent
# REG_DWORD value: DisableWindowsSpotlightFeatures should be 1

# Function to check if the setting is configured as recommended
function Test-WindowsSpotlightFeature {
    # Prompting user to check Group Policy setting manually
    Write-Host "Please verify in the Group Policy Editor:"
    Write-Host "Navigate to User Configuration -> Policies -> Administrative Templates -> Windows Components -> Cloud Content"
    Write-Host "Ensure 'Turn off all Windows spotlight features' is set to 'Enabled'."
    
    # Retrieving the list of User SIDs
    $userSIDs = Get-ChildItem -Path "HKU:\"
    $auditPassed = $true

    foreach ($sid in $userSIDs) {
        # Construct the registry path for each user SID
        $regPath = "Registry::HKEY_USERS\$($sid.SID)\Software\Policies\Microsoft\Windows\CloudContent"
        
        # Check if the registry key exists
        if (Test-Path -Path $regPath) {
            # Get the DisableWindowsSpotlightFeatures value
            $spotlightValue = Get-ItemProperty -Path $regPath -Name "DisableWindowsSpotlightFeatures" -ErrorAction SilentlyContinue
            
            # Check if the value is set to 1
            if ($null -eq $spotlightValue -or $spotlightValue.DisableWindowsSpotlightFeatures -ne 1) {
                Write-Host "Audit Failed for User SID $($sid.SID): DisableWindowsSpotlightFeatures is not set to 1."
                $auditPassed = $false
            } else {
                Write-Host "Audit Passed for User SID $($sid.SID): DisableWindowsSpotlightFeatures is set to 1."
            }
        } else {
            Write-Host "Audit Failed for User SID $($sid.SID): Registry path does not exist."
            $auditPassed = $false
        }
    }

    return $auditPassed
}

# Execute the function and determine the exit code
if (Test-WindowsSpotlightFeature) {
    Write-Host "Audit Completed Successfully. All checks passed."
    exit 0
} else {
    Write-Host "Audit Completed. Some checks failed."
    exit 1
}
# ```
