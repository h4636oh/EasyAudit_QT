#```powershell
# Script to audit 'Network access: Let Everyone permissions apply to anonymous users' setting.

# Registry path and value name
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$valueName = "EveryoneIncludesAnonymous"

# Create a function to check the registry value
function Test-AnonymousUsersPermission {
    try {
        # Retrieve the current registry value
        $regValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop

        # Check if the value is set to 0 (Disabled)
        if ($regValue.$valueName -eq 0) {
            Write-Host "Audit Passed: 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'."
            # Exit with code 0 to indicate success
            exit 0
        }
        else {
            Write-Host "Audit Failed: 'Network access: Let Everyone permissions apply to anonymous users' is not set to 'Disabled'."
            Write-Host "Please check the setting manually via: Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options\\Network access: Let Everyone permissions apply to anonymous users"
            # Exit with code 1 to indicate failure
            exit 1
        }
    }
    catch {
        # Handle errors if registry key or value does not exist
        Write-Host "Audit Failed: Unable to retrieve registry value. Error: $_"
        Write-Host "Please check the setting manually via: Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options\\Network access: Let Everyone permissions apply to anonymous users"
        # Exit with code 1 to indicate failure
        exit 1
    }
}

# Invoke the audit check function
Test-AnonymousUsersPermission
# ```
