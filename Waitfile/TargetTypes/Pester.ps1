New-TargetType `
    -Name 'Pester' `
    -Arguments 'Path', 'ModuleRoot' `
    -Test { $false } `
    -New {
            param([hashtable]$Arguments)
            $Timestamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
            $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
            Invoke-Pester -Path $Arguments.Path -OutputFormat NUnitXml -OutputFile "$PSScriptRoot\$Testfile" -CodeCoverage "$($Arguments.ModuleRoot)\*.ps1" -PassThru
        } `
    -Remove {}