#requires -Module @{ ModuleName = 'Waitfile'; RequiredVersion = '0.5.0' }

#region Import Waitfile and sanitize environment
Import-Module -Name Waitfile -Force
Clear-Target -Confirm:$false
#endregion

#region Utilize BuildHelpers for variables
$BuildVariables = Get-BuildVariables
$ProjectRoot = $BuildVariables.ProjectPath
$BuildNumber = $BuildVariables.BuildNumber
#endregion

#region Determine module information from current directory (refactor to CICD module?)
$PSModule = Get-ChildItem -Path $ProjectRoot -File -Recurse -Filter '*.psd1' | Where-Object { $_.Directory.Name -eq $_.BaseName }
if ($PSModule -is [array]) {
    Write-Error ('Found more than one module manifest: {0}' -f ($PSModule -join ', '))
}
if (-Not $PSModule) {
    Write-Error 'Did not find any module manifest'
}
$ModuleName = $PSModule.Directory.BaseName
$ModuleRoot = $PSModule.Directory.FullName
Import-LocalizedData -BindingVariable Manifest -BaseDirectory $PSModule.Directory.FullName -FileName $PSModule.Name
$ModuleVersion = $Manifest.ModuleVersion
#endregion

Write-Host -ForegroundColor Green '+--------------------------------------------------------------------+'
Write-Host -ForegroundColor Green "| Module $ModuleName v$ModuleVersion"
Write-Host -ForegroundColor Green '+--------------------------------------------------------------------+'
Write-Host "ProjectRoot  : $ProjectRoot"
Write-Host "ModuleName   : $ModuleName"
Write-Host "ModuleRoot   : $ModuleRoot"
Write-Host "ModuleVersion: $ModuleVersion"
Write-Host "BuildNumber  : $BuildNumber"
Write-Host ''

#region Check for updated to required modules (refactor to CICD module?)
$ModuleNames = $Manifest.RequiredModules.ModuleName
if ($ModuleNames) {
    $Modules = Find-Module -Name $ModuleNames
    $Manifest.RequiredModules | ForEach-Object {
        $RequiredModule = $_
        $Module = $Modules | Where-Object { $_.Name -ieq $RequiredModule.ModuleName }

        if (-not $Module.Version.ToString().IndexOf($RequiredModule.RequiredVersion) -and $Module.Version -gt $RequiredModule.RequiredVersion) {
            Write-Warning "Updated version <$($Module.Version)> found for required module <$($RequiredModule.ModuleName)/$($RequiredModule.RequiredVersion)>"
        }
    }
}
#endregion

#region Creating default targets for PowerShell modules
Write-Host 'Adding target for script analysis'
New-Target -Name 'Quality' -Type 'ScriptAnalyzer' -TypeArguments @{Path = $ModuleRoot}

Write-Host 'Adding target for unit tests'
New-Target -Name 'Tests' -Type 'Pester' -TypeArguments @{Path = "$ProjectRoot\Tests"; ModuleRoot = $ModuleRoot}

Write-Host 'Adding target for test coverage'
# TODO: Configurable thresholds
New-Target -Name 'Coverage' -Type 'TestCoverage' -DependsOn 'Tests'

Write-Host 'Adding target for documentation'
New-Target -Name 'Docs' -Type 'platyps' -TypeArguments @{Path = "$ProjectRoot\Docs"; ModuleRoot = $ModuleRoot}

# TODO: Add targets for...
#       - GitHub release (find RELEASENOTES.md, match header with exact version, otherwise fail)
#       - GitHub release asset
#       - publish to PSGallery
#       - publish to Coveralls

Write-Host 'Adding top-level target for all tasks'
New-Target -Name 'All' -DependsOn Quality, Tests, Coverage, Docs -Default
#endregion

Write-Host ''
Write-Host -ForegroundColor Yellow '+--------------------------------------------------------------------+'
Write-Host -ForegroundColor Yellow "| Building..."
Write-Host -ForegroundColor Yellow '+--------------------------------------------------------------------+'

# TODO: Fix information channel
Invoke-Target -InformationAction 'Continue'

return



