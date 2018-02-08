New-TargetType `
    -Name 'DockerBuild' `
    -Arguments 'Registry','Name','Tag' `
    -Test { `
            param([hashtable]$Arguments) `
            docker image ls --filter=reference=$($Arguments.Registry):$($Arguments.Tag) `
            $false `
        } `
    -New { `
            param([hashtable]$Arguments) `
            docker image build --tag $($Arguments.Registry):$($Arguments.Tag) . `
        } `
    -Remove { `
            param([hashtable]$Arguments) `
            docker image rm $($Arguments.Registry):$($Arguments.Tag) `
        }