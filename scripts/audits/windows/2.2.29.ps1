#```powershell
# Define the title of the audit check

# Define recommended states based on the description notes
$recommendedAccounts = @(
    "No One",
    "NT VIRTUAL MACHINE\\Virtual Machines", # When Hyper-V is installed
    "WDAGUtilityAccount" # When Windows Defender Application Guard is used
)

# Function to check if a specific user right has the recommended configuration
function Test-LogOnAsService {
    try {
        # Retrieve the current settings for the "Log on as a service" right
        $currentAssignment = secedit /export /cfg $env:TEMP\secpol.cfg
        $secpolContent = Get-Content -Path "$env:TEMP\secpol.cfg"

        # Locate the "Log on as a service" policy assignment
        $policyLine = $secpolContent | Select-String -Pattern "SeServiceLogonRight"
        
        # Check if the line exists and extract the configuration
        if ($policyLine) {
            # Extracting the assigned account(s)
            $assignedAccounts = ($policyLine -split '=')[1].Trim() -split ','

            # Check compliance
            foreach ($account in $assignedAccounts) {
                if ($account -notin $recommendedAccounts) {
                    return $false
                }
            }
            return $true
        } else {
            # If the policyLine is not found, consider it non-compliant
            return $false
        }
    } catch {
        Write-Host "An error occurred while auditing the 'Log on as a service' rights."
        return $false
    }
}

# Perform the audit and determine compliance
if (Test-LogOnAsService) {
    Write-Host 
    exit 0
} else {
    Write-Host "Audit Failed. Please manually verify the 'Log on as a service' rights in Local Security Policy."
    Write-Host "Navigate to: Computer Configuration -> Windows Settings -> Security Settings -> Local Policies -> User Rights Assignment -> Log on as a service"
    exit 1
}

# Clean up the temporary file created by secedit
Remove-Item -Path "$env:TEMP\secpol.cfg" -ErrorAction SilentlyContinue
#```
