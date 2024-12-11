#```powershell
# PowerShell 7 script to audit "Enable/Disable PerfTrack" policy setting

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}"
$valueName = "ScenarioExecutionEnabled"

# Function to audit the PerfTrack setting
function Audit-PerfTrack {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

    if ($null -eq $value) {
        Write-Output "Registry key or value does not exist. Please verify the policy is configured."
        return $false
    }

    # Check if the value is set to 0 (Disabled)
    if ($value.ScenarioExecutionEnabled -eq 0) {
        Write-Output "'Enable/Disable PerfTrack' is set to 'Disabled' as recommended."
        return $true
    } else {
        Write-Output "'Enable/Disable PerfTrack' is NOT set to 'Disabled'. Please configure it via Group Policy."
        return $false
    }
}

# Execute the audit
if (Audit-PerfTrack) {
    exit 0
} else {
    # Prompt the user to manually check the Group Policy setting if the audit fails
    Write-Warning "To manually verify configuration, navigate to: Computer Configuration\Policies\Administrative Templates\System\Troubleshooting and Diagnostics\Windows Performance PerfTrack\"
    exit 1
}
# ```
