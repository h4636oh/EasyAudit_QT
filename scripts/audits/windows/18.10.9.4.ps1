#```powershell
# PowerShell 7 script to audit the setting:
# 'Disable new DMA devices when this computer is locked' in Group Policy should be set to 'Enabled'.
# The corresponding registry key is HKLM\SOFTWARE\Policies\Microsoft\FVE:DisableExternalDMAUnderLock and should have a value of 1.

# Function to check the registry key value
function Test-DMASetting {
    param (
        [string]$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE',
        [string]$ValueName = 'DisableExternalDMAUnderLock'
    )

    try {
        # Get the registry value
        $registryValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction Stop
        
        # Check if the registry value is set to 1
        if ($registryValue.$ValueName -eq 1) {
            Write-Output "Audit Pass: The setting 'Disable new DMA devices when this computer is locked' is enabled as required."
            return $true
        }
        else {
            Write-Warning "Audit Fail: The setting is not enabled. Current value is $($registryValue.$ValueName)."
            return $false
        }
    }
    catch {
        Write-Warning "Audit Fail: Unable to find the registry key or value. $_"
        return $false
    }
}

# Execute the audit
$dmaSettingEnabled = Test-DMASetting

# Exit with appropriate exit code
if ($dmaSettingEnabled) {
    exit 0
} else {
    Write-Host "Please ensure to set the policy manually via Group Policy Management console at the path:"
    Write-Host "Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Disable new DMA devices when this computer is locked"
    exit 1
}
# ```
