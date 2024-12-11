#```powershell
# Script to audit the 'Act as part of the operating system' user right setting

# Ensure script runs in PowerShell 7
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "This script requires PowerShell 7 or later."
    exit 1
}

# Function to audit the setting
function Audit-ActAsPartOfOS {
    # Define the expected value
    $expectedValue = "No One"

    # Retrieve the current setting for 'Act as part of the operating system'
    try {
        $currentSetting = secedit /export /cfg $env:TEMP\secpol.cfg | Out-Null
        $currentSetting = Get-Content -Path "$env:TEMP\secpol.cfg" | Select-String -Pattern "SeTcbPrivilege"

        if ($null -eq $currentSetting) {
            $currentValue = "No One"
        } else {
            # Extracting list of accounts assigned with this privilege
            $accounts = ($currentSetting -replace 'SeTcbPrivilege\s*=\s*', '').Trim()
            if ($accounts -eq "*S-1-0-0") {
                $currentValue = "No One"
            } else {
                $currentValue = $accounts -replace ",", ", "
            }
        }
    } catch {
        Write-Host "Error when retrieving the current setting: $_.Exception.Message"
        exit 1
    } finally {
        # Clean up
        Remove-Item -Path "$env:TEMP\secpol.cfg" -ErrorAction SilentlyContinue
    }

    # Compare current setting with the expected value
    if ($currentValue -eq $expectedValue) {
        Write-Host "'Act as part of the operating system' is correctly set to: 'No One'"
        return $true
    } else {
        Write-Host "'Act as part of the operating system' needs manual check: Currently set to: $currentValue"
        return $false
    }
}

# Execute the audit function and capture result
if (Audit-ActAsPartOfOS) {
    exit 0
} else {
    exit 1
}
# ```
# 
# In this script:
# - We first ensure that the script is executed using PowerShell 7 or later.
# - Then, a function `Audit-ActAsPartOfOS` is defined to check the 'Act as part of the operating system' policy. It reads the security policy configuration and checks if the setting is equivalent to "No One".
# - If the configuration is as expected, it exits with a status code `0` indicating the audit passed. Otherwise, it exits with a status code `1`, indicating a need for manual verification.
