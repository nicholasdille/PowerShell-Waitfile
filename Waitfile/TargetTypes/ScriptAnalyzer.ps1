New-TargetType `
    -Name 'ScriptAnalyzer' `
    -Arguments 'Path' `
    -Test { $false } `
    -New {
            param([hashtable]$Arguments)

            $results = Invoke-ScriptAnalyzer -Path $Arguments.Path -Severity Error,Warning -Recurse
            if ($results) {
                $results | Select-Object -Property ScriptName,Line,RuleName,Severity,Message
                throw 'Failed script analysis. Build failed.'
            }

            $results = Invoke-ScriptAnalyzer -Path $Arguments.Path -SuppressedOnly -Recurse
            if ($results) {
                $results | Select-Object -Property ScriptName,Line,RuleName,Severity,Message,Justification
                Write-Warning 'Some issues are suppressed from script analysis.'
            }
        } `
    -Remove {}