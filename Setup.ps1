Set-PSRepository PSGallery -InstallationPolicy Trusted
Update-Module Pester
# Install-Module Pester -Scope CurrentUser -MinimumVersion 5.0.2 -Force
# Install-Module PSKoans -Scope CurrentUser

# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
# az login
# az account list
# az account set --subscription b7445981-7fd4-4c5b-831c-41a5bc4900d0
# az bicep install
# az bicep upgrade

# https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows?view=azps-10.0.0&tabs=powershell&pivots=windows-psgallery
if (-not (Get-Module -Name Az -ListAvailable)) {
    Write-Warning "PowerShell module 'Az' not found.  Installing...`n"
    Install-Module -Name Az -Repository PSGallery -Force
}
try {
    bicep --version
}
catch {
    Write-Warning "Bicep CLI not found.  Installing...`n"
    # https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually
    # Create the install folder
    $installPath = "$env:USERPROFILE\.bicep"
    $installDir = New-Item -ItemType Directory -Path $installPath -Force
    $installDir.Attributes += 'Hidden'
    # Fetch the latest Bicep CLI binary
    (New-Object Net.WebClient).DownloadFile("https://github.com/Azure/bicep/releases/latest/download/bicep-win-x64.exe", "$installPath\bicep.exe")
    # Add bicep to your PATH
    $currentPath = (Get-Item -path "HKCU:\Environment" ).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
    if (-not $currentPath.Contains("%USERPROFILE%\.bicep")) { setx PATH ($currentPath + ";%USERPROFILE%\.bicep") }
    if (-not $env:path.Contains($installPath)) { $env:path += ";$installPath" }
    # Verify you can now access the 'bicep' command.
    bicep --help
    # Done!
}


# Update-Module -Name Az -Force
# Connect-AzAccount -Subscription "b7445981-7fd4-4c5b-831c-41a5bc4900d0"
# Get-AzContext -ListAvailable
# Set-AzContext

if (-not ('KoanAttribute' -as [type])) {
    
    Add-Type -TypeDefinition @'
using System;

public class KoanAttribute : Attribute
{
    public uint Position = UInt32.MaxValue;
    public string Module = "_powershell";
}
'@
}

Invoke-Pester
