New-TargetType `
    -Name 'PowerShellModule' `
    -Arguments 'Name', 'Version' `
    -Test {
            param([hashtable]$Arguments)
            [bool](Get-Module -ListAvailable -Name $($Arguments.Name))
        } `
    -New {
            param([hashtable]$Arguments)
            Install-Module -Name $($Arguments.Name) -RequiredVersion $($Arguments.Version) -Scope CurrentUser
        } `
    -Remove {
            param([hashtable]$Arguments)
            Uninstall-Module -Name $($Arguments.Name) -RequiredVersion $($Arguments.Version)
        }