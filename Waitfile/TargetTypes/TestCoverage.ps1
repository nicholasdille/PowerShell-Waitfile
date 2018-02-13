#requires -Module @{ModuleName = 'CICD'; RequiredVersion = '0.1.23.24'}

New-TargetType `
    -Name 'TestCoverage' `
    -Test {
        Write-Information 'Testing whether to calculate test coverage'
        Test-TargetMessage -Name 'TestCoverageResult'
    } `
    -New {
        param([hashtable]$Arguments)

        Write-Information 'Calculating test coverage'

        if (-not (Test-TargetMessage -Name 'PesterResult')) {
            throw 'Missing pester results'
        }
        $TestResult = Get-TargetMessage -Name 'PesterResult' | Select-Object -ExpandProperty Message

        $CoverageResult = Get-CodeCoverageMetric -CodeCoverage $TestResult.CodeCoverage
        if ($CoverageResult.Statement.Coverage -le 75) {
            throw "Statement coverage below 75% ($($CoverageResult.Statement.Coverage)%). Build failed!"
        }
        if ($CoverageResult.Function.Coverage -lt 100) {
            throw "Function coverage is not 100% ($($CoverageResult.Function.Coverage)%). Build failed!"
        }

        New-TargetMessage -Name 'TestCoverageResult' -Message $CoverageResult
    } `
    -Remove {
        Write-Information 'Remove test coverage'
        Remove-TargetMessage -Name 'TestCoverageResult'
    }