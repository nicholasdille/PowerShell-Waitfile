New-TargetType `
    -Name 'DockerBuild' `
    -Arguments 'Registry','Name','Tag' `
    -Test { `
            param([hashtable]$Arguments) `
            Write-Output "docker image ls --filter=reference=$($Arguments.Registry):$($Arguments.Tag)" `
            $false `
        } `
    -New { `
            param([hashtable]$Arguments) `
            Write-Output "docker image build --tag $($Arguments.Registry):$($Arguments.Tag) ." `
        } `
    -Remove { `
            param([hashtable]$Arguments) `
            Write-Output "docker image rm $($Arguments.Registry):$($Arguments.Tag)" `
        }