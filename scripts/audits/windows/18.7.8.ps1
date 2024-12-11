#```powershell
# PowerShell 7 Script to audit 'Limits print driver installation to Administrators' setting

# Define the key and value path for registry
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
$valueName = "RestrictDriverInstallationToAdministrators"

# Audit the registry setting
try {
    $regValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
    if ($regValue.$valueName -eq 1) {
        Write-Host "'Limits print driver installation to Administrators' is set to 'Enabled'."
        exit 0  # Audit passed
    } else {
        Write-Host "'Limits print driver installation to Administrators' is NOT set to 'Enabled'."
        exit 1  # Audit failed
    }
} catch {
    Write-Host "The registry key or value does not exist. Please verify the setting manually."
    exit 1  # Audit failed due to missing registry key or value
}

# Prompt user for manual verification if required
Write-Host "If necessary, manually verify the Group Policy setting is enabled at:"
Write-Host "Computer Configuration\Policies\Administrative Templates\Printers\Limits print driver installation to Administrators"
# ```
