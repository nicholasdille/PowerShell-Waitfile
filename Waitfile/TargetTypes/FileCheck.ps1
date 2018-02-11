New-TargetType `
    -Name 'FileCheck' `
    -Arguments 'Name' `
    -Test {
            param([hashtable]$Arguments)
            if (-not (Test-Path -Path $Arguments.Name)) { throw "File <$($Arguments.Name)> does not exist" }
        } `
    -New {} `
    -Remove {}