@{
    RootModule = 'Waitfile.psm1'
    ModuleVersion = '0.5.0'
    GUID = '5c7656cb-d2fc-494f-91c8-61d0dfa7ca5a'
    Author = 'Nicholas Dille'
    #CompanyName = ''
    Copyright = '(c) 2017 Nicholas Dille. All rights reserved.'
    Description = 'PowerShell-ish alternative for Makefile'
    # PowerShellVersion = ''
    RequiredModules = @(
        @{
            ModuleName = 'pester'
            RequiredVersion = '4.1.1'
        }
        @{
            ModuleName = 'platyps'
            RequiredVersion = '0.9.0'
        }
        @{
            ModuleName = 'PSGitHub'
            RequiredVersion = '0.13.9'
        }
        @{
            ModuleName = 'PSScriptAnalyzer'
            RequiredVersion = '1.16.1'
        }
        @{
            ModuleName = 'CICD'
            RequiredVersion = '0.1.23.24'
        }
        @{
            ModuleName = 'BuildHelpers'
            RequiredVersion = '1.0.0'
        }
    )
    FunctionsToExport = @(
        'Clear-Target'
        'Clear-TargetMessage'
        'Get-Target'
        'Get-TargetMessage'
        'Get-TargetType'
        'Invoke-Target'
        'New-Target'
        'New-TargetMessage'
        'New-TargetType'
        'Remove-Target'
        'Remove-TargetMessage'
        'Test-TargetMessage'
        'Test-TargetType'
    )
    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = @()
    FormatsToProcess = @(
        'WaitfileTargetType.Format.ps1xml'
        'WaitfileTarget.Format.ps1xml'
    )
    PrivateData = @{
        PSData = @{
            # Tags = @()
            # LicenseUri = ''
            # ProjectUri = ''
            # ReleaseNotes = ''
        }
    }
}

