#```powershell
# PowerShell 7 Script to Audit the Configuration of Wireless Settings using Windows Connect Now
# Profile Applicability: Level 2 (L2) - High Security/Sensitive Data Environment (limited functionality)

# Function to Check Registry Values
function Test-WcnRegistrarSetting {
    [CmdletBinding()]
    param (
        [string]$RegistryPath,
        [string]$RegistryValueName
    )

    try {
        # Get the registry value
        $value = Get-ItemProperty -Path $RegistryPath -Name $RegistryValueName -ErrorAction Stop

        # If the registry value is 0, it is configured correctly.
        if ($value.$RegistryValueName -eq 0) {
            return $true
        } else {
            return $false
        }
    } catch {
        # If there is an error accessing the registry key or value, return false
        return $false
    }
}

# Paths to registry keys relevant to the configuration
$registryPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars"
)

# Corresponding registry value names
$registryValueNames = @(
    "EnableRegistrars",
    "DisableUPnPRegistrar",
    "DisableInBand802DOT11Registrar",
    "DisableFlashConfigRegistrar",
    "DisableWPDRegistrar"
)

# Variable to keep track of the audit status
$auditPassed = $true

# Audit each registry setting
for ($i = 0; $i -lt $registryPaths.Count; $i++) {
    $result = Test-WcnRegistrarSetting -RegistryPath $registryPaths[$i] -RegistryValueName $registryValueNames[$i]

    if (-not $result) {
        Write-Host "Audit failed for registry path: $($registryPaths[$i]) with value name: $($registryValueNames[$i])"
        $auditPassed = $false
    }
}

# Prompt user for manual check according to audit requirement
if ($auditPassed) {
    Write-Host "All registry settings are correctly configured. However, manual validation of the Group Policy setting in the UI is recommended." -ForegroundColor Yellow
} else {
    Write-Host "One or more registry settings are not correctly configured." -ForegroundColor Red
    Write-Host "Navigate to the Group Policy Path: 'Computer Configuration -> Policies -> Administrative Templates -> Network -> Windows Connect Now' and ensure 'Configuration of wireless settings using Windows Connect Now' is set to 'Disabled'."
}

# Exit with appropriate status code
if ($auditPassed) {
    exit 0
} else {
    exit 1
}
# ```
