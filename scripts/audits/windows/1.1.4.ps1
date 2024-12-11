# Script to audit 'Minimum password length' policy setting

# Function to check the minimum password length policy from the registry
function Test-MinimumPasswordLength {
    # Registry path for password policies
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordPolicies"
    $regName = "MinimumPasswordLength"

    try {
        # Check if the registry key exists
        if (Test-Path -Path $regPath) {
            # Retrieve the value of the minimum password length policy
            $minPasswordLength = (Get-ItemProperty -Path $regPath -Name $regName).MinimumPasswordLength
            
            # Validate if the value is greater than or equal to 14
            if ($minPasswordLength -ge 14) {
                Write-Host "Pass: Minimum password length is set to 14 or more characters." -ForegroundColor Green
                return $true
            } else {
                Write-Host "Fail: Minimum password length is set to less than 14 characters." -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "Error: Could not retrieve minimum password length policy from the registry." -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "Error: Could not retrieve minimum password length policy." -ForegroundColor Red
        return $false
    }
}

# Run the minimum password length test
if (Test-MinimumPasswordLength) {
    exit 0
} else {
    Write-Host "Manual Step Required: Please navigate to the UI path specified in the remediation section." -ForegroundColor Yellow
    exit 1
}
