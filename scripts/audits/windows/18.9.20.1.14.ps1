#```powershell
# This script audits the Windows Error Reporting settings as per security baseline requirements.
# It checks registry values to ensure that error reporting is turned off as specified.

# Define registry paths and required values
$registryPaths = @{
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting' = 'Disabled'
    'HKLM:\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting' = 'DoReport'
}

$expectedValues = @{
    'Disabled' = 1
    'DoReport' = 0
}

$compliant = $true

foreach ($path in $registryPaths.Keys) {
    $property = $registryPaths[$path]
    try {
        # Retrieve the registry value
        $currentValue = Get-ItemPropertyValue -Path $path -Name $property -ErrorAction Stop
    } catch {
        Write-Host "Registry path or property not found: $path\$property" -ForegroundColor Red
        $compliant = $false
        continue
    }

    # Check if the current value matches the expected value
    if ($currentValue -ne $expectedValues[$property]) {
        Write-Host "Non-compliant value detected at $path\$property: $currentValue (Expected: $($expectedValues[$property]))" -ForegroundColor Red
        $compliant = $false
    } else {
        Write-Host "Compliant value found at $path\$property: $currentValue" -ForegroundColor Green
    }
}

if (-not $compliant) {
    Write-Host "Audit failed: Some settings do not comply with the recommended configuration." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Audit passed: All settings are compliant with the recommended configuration." -ForegroundColor Green
    exit 0
}

# Manual check reminder for users if path navigation is required according to remediation instructions
Write-Host "Please manually verify the Group Policy setting at the UI path: Computer Configuration\Policies\Administrative Templates\System\Internet Communication Management\Internet Communication settings\Turn off Windows Error Reporting is set to 'Enabled'."
# ```
