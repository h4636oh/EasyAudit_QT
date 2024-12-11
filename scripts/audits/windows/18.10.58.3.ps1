#```powershell
# PowerShell 7 Script to Audit 'Allow Cortana' Policy Setting

# Function to check the 'Allow Cortana' registry value
function Test-AllowCortana {
    $regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
    $regName = 'AllowCortana'
    
    try {
        # Get the registry value
        $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
        
        # Check if the value is set to 0
        if ($regValue.$regName -eq 0) {
            Write-Output "Audit Passed: 'Allow Cortana' is set to 'Disabled'."
            return $true
        }
        else {
            Write-Output "Audit Failed: 'Allow Cortana' is not set to 'Disabled'."
            return $false
        }
    }
    catch {
        Write-Output "Audit Failed: Unable to find the 'Allow Cortana' setting in the registry."
        return $false
    }
}

# Perform the audit
if (Test-AllowCortana) {
    Exit 0
}
else {
    Write-Output "Manual Action Required: Navigate to 'Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Search' and ensure 'Allow Cortana' is set to 'Disabled'."
    Exit 1
}
# ```
# 
# This script checks the registry setting that controls whether Cortana is allowed on the device. If the setting is correctly configured (`AllowCortana` set to `0`), the script outputs a pass message and exits with code `0`. If not configured as recommended, it outputs a fail message, advises manual remediation, and exits with code `1`.
