New-TargetType `
    -Name 'FileCreator' `
    -Arguments 'Name' `
    -Test {
            param([hashtable]$Arguments)
            Test-Path -Path $Arguments.Name
        } `
    -New {
            param([hashtable]$Arguments)
            New-Item -Path $Arguments.Name -ItemType File | Out-Null
        } `
    -Remove {
            param([hashtable]$Arguments)
            Remove-Item -Path $Arguments.Name
        }