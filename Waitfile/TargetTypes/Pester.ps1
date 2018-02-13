New-TargetType `
    -Name 'Pester' `
    -Arguments 'Path', 'ModuleRoot' `
    -Test {
        Write-Information 'Testing whether to run unit tests'
        Test-TargetMessage -Name 'PesterResult'
    } `
    -New {
        param([hashtable]$Arguments)

        Write-Information 'Running unit tests'

        #$Timestamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
        #$TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"

        $SourceFiles = Get-ChildItem -Path "$($Arguments.ModuleRoot)\Functions" -File -Filter '*.ps1' -Recurse | Select-Object -ExpandProperty FullName
        $TestResults = Invoke-Pester -Path $Arguments.Path <#-OutputFormat NUnitXml -OutputFile "$PSScriptRoot\$Testfile"#> -CodeCoverage $SourceFiles -PassThru
        if ($TestResults.FailedCount -gt 0) {
            throw "Failed $($TestResults.FailedCount) test(s). Build failed!"
        }

        New-TargetMessage -Name 'PesterResult' -Message $TestResults
    } `
    -Remove {
        Write-Information 'Removing unit test results'
        Remove-TargetMessage -Name 'PesterResult'
    }