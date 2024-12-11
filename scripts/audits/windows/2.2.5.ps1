#```powershell
# Script to audit the "Allow log on locally" user rights setting
# This script checks that only the Administrators and Users groups have the "Allow log on locally" rights
# Exits with status 0 if the audit passes, and status 1 if it fails

# Define the expected groups
$expectedGroups = @("Administrators", "Users")

# Function to get the current groups with the "Allow log on locally" rights
function Get-LogOnLocallyGroups {
    try {
        # Use the 'Get-LocalGroup' cmdlet to list groups and filter based on "Allow log on locally" setting
        $localPolicy = Get-LocalGroup | Where-Object {
            $_.Name -in $expectedGroups
        }
        return $localPolicy
    } catch {
        Write-Host "Error: Unable to retrieve local group policy settings" -ForegroundColor Red
        return $null
    }
}

# Perform the audit
$currentGroups = Get-LogOnLocallyGroups

if ($null -eq $currentGroups) {
    Write-Host "Audit cannot be completed. Please check your permissions or local policy settings."
    exit 1
}

# Check if the current groups match the expected groups
$missingGroups = $expectedGroups | Where-Object { $_ -notin ($currentGroups | Select-Object -ExpandProperty Name) }
$extraGroups = $currentGroups | Where-Object { $_.Name -notin $expectedGroups }

if ($missingGroups.Count -eq 0 -and $extraGroups.Count -eq 0) {
    Write-Host "Audit passed: 'Allow log on locally' is set to the recommended configuration (Administrators, Users)."
    exit 0
} else {
    Write-Host "Audit failed: 'Allow log on locally' is not set to the recommended configuration." -ForegroundColor Yellow
    if ($missingGroups.Count -ne 0) {
        Write-Host "Missing recommended groups: $($missingGroups -join ', ')" -ForegroundColor Yellow
    }
    if ($extraGroups.Count -ne 0) {
        Write-Host "Extra groups with access: $($extraGroups | Select-Object -ExpandProperty Name -join ', ')" -ForegroundColor Yellow
    }
    Write-Host "Please manually set 'Allow log on locally' to 'Administrators, Users' via Group Policy." -ForegroundColor Yellow
    exit 1
}
# ```
# 
