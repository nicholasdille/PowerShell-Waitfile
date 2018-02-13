New-TargetType `
    -Name 'PowerShellModule' `
    -Arguments 'Name', 'Version' `
    -Test {
            param([hashtable]$Arguments)
            Write-Information "Testing for module $($Arguments.Name)"
            [bool](Get-Module -ListAvailable -Name $($Arguments.Name))
        } `
    -New {
            param([hashtable]$Arguments)
            Write-Information "Installing module $($Arguments.Name) v$($Arguments.Version)"
            Install-Module -Name $($Arguments.Name) -RequiredVersion $($Arguments.Version) -Scope CurrentUser
        } `
    -Remove {
            param([hashtable]$Arguments)
            Write-Information "Uninstalling module $($Arguments.Name) v$($Arguments.Version)"
            Uninstall-Module -Name $($Arguments.Name) -RequiredVersion $($Arguments.Version)
        }