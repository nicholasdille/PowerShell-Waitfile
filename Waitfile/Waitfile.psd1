@{
    RootModule = 'Waitfile.psm1'
    ModuleVersion = '0.5.0'
    GUID = '5c7656cb-d2fc-494f-91c8-61d0dfa7ca5a'
    Author = 'Nicholas Dille'
    #CompanyName = ''
    Copyright = '(c) 2017 Nicholas Dille. All rights reserved.'
    Description = 'PowerShell-ish alternative for Makefile'
    # PowerShellVersion = ''
    # RequiredModules = @()
    FunctionsToExport = @(
        'Get-Target'
        'Get-TargetType'
        'Invoke-Target'
        'New-Target'
        'New-TargetType'
    )
    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = @()
    #FormatsToProcess = @()
    PrivateData = @{
        PSData = @{
            # Tags = @()
            # LicenseUri = ''
            # ProjectUri = ''
            # ReleaseNotes = ''
        }
    }
}

