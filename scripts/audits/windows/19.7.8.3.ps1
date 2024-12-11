# PowerShell script to audit the setting for 'Do not use diagnostic data for tailored experiences'

# Function to check registry setting
function Test-TailoredExperiences {
    param (
        [string]$UserSID
    )

    # Registry path for the policy setting
    $registryPath = "HKU:\$UserSID\Software\Policies\Microsoft\Windows\CloudContent"
    $registryValueName = "DisableTailoredExperiencesWithDiagnosticData"

    # Check if the registry path exists
    if (Test-Path $registryPath) {
        # Get the registry value
        $regValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue

        # Return true if the value is set to 1, indicating the policy is enabled
        if ($regValue.$registryValueName -eq 1) {
            return $true
        }
    }

    # If the registry path does not exist or the value is not set to 1, the policy is not enabled
    return $false
}

# Check if we can access the HKU registry hive
function Load-HKURegistryHive {
    if (-not (Test-Path "HKU:\")) {
        try {
            # Load the HKU registry hive (requires admin privileges)
            reg load HKU\TempHive C:\Users\$env:USERNAME\NTUSER.DAT
            Write-Host "Loaded registry hive for the current user."
        } catch {
            Write-Error "Failed to load registry hive. Ensure the script is run with administrative privileges."
            exit 1
        }
    }
}

# Run the function to load HKU hive if needed
Load-HKURegistryHive

# Get list of all user SIDs
$userSIDs = Get-ChildItem 'HKU:' | Where-Object { $_.PSChildName -match 'S-\d-\d+-(\d+-){1,14}\d+$' } | Select-Object -ExpandProperty PSChildName

# Initialize audit result
$auditPasses = $true

# Audit each user SID
foreach ($userSID in $userSIDs) {
    if (-not (Test-TailoredExperiences -UserSID $userSID)) {
        Write-Host "Audit failed for user SID: $userSID. 'Do not use diagnostic data for tailored experiences' is not set to 'Enabled'."
        $auditPasses = $false
    }
}

# Unload the HKU registry hive if it was loaded
if (Test-Path "HKU\TempHive") {
    reg unload HKU\TempHive
    Write-Host "Unloaded registry hive for the current user."
}

if ($auditPasses) {
    Write-Host "Audit passed. All users have the setting 'Do not use diagnostic data for tailored experiences' as 'Enabled'."
    exit 0
} else {
    Write-Host "Please set 'Do not use diagnostic data for tailored experiences' to 'Enabled' via Group Policy for all applicable users."
    exit 1
}
