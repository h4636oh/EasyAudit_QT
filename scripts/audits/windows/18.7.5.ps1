#```powershell
<#
.SYNOPSIS
Audit the RPC protocols setting for the print spooler to ensure it is configured to use "RPC over TCP".

.DESCRIPTION
This script checks the registry setting that controls which protocols incoming Remote Procedure Call (RPC) connections to the print spooler are allowed to use. 
The recommended configuration is to enable "RPC over TCP". The script audits this setting and exits with appropriate status codes.

.PARAMETER None

.EXAMPLE
.\Audit-RPCProtocols.ps1
#>

# Define the registry path and the required value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC"
$valueName = "RpcProtocols"
$requiredValue = 5

# Check if the registry key exists
if (Test-Path -Path $registryPath) {
    # Get the current value of the RpcProtocols
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    
    # Check if we retrieved the value successfully
    if ($null -eq $currentValue) {
        Write-Output "The registry key '$valueName' does not exist. Please verify the configuration manually."
        exit 1
    } else {
        # Compare current value with the required value
        if ($currentValue.$valueName -eq $requiredValue) {
            Write-Output "The RPC protocol setting is correctly set to 'RPC over TCP'."
            exit 0
        } else {
            Write-Output "The RPC protocol setting is not set correctly. It should be 'RPC over TCP'."
            exit 1
        }
    }
} else {
    Write-Output "The registry path '$registryPath' does not exist. Please verify the configuration manually."
    exit 1
}
# ```
