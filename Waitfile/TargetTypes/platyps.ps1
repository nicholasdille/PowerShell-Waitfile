New-TargetType `
    -Name 'platyps' `
    -Arguments 'Path', 'ModuleRoot' `
    -Test { $false } `
    -New {
            param([hashtable]$Arguments)
            Get-ChildItem -Path $Arguments.Path -Directory | Select-Object -ExpandProperty Name | ForEach-Object {
                New-ExternalHelp -Path "$($Arguments.Path)\$_" -OutputPath "$($Arguments.ModuleRoot)\$_" -Force | Out-Null
            }
        } `
    -Remove {}