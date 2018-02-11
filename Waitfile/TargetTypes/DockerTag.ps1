New-TargetType `
    -Name 'DockerTag' `
    -Arguments 'Registry','Name','Tag1','Tag2' `
    -Test {
            param([hashtable]$Arguments)
            docker image ls --filter=reference=$($Arguments.Registry):$($Arguments.Tag1)
            $false
        } `
    -New {
            param([hashtable]$Arguments)
            docker image tag $($Arguments.Registry):$($Arguments.Tag1) $($Arguments.Registry):$($Arguments.Tag2)
        } `
    -Remove {
            param([hashtable]$Arguments)
            docker image rm $($Arguments.Registry):$($Arguments.Tag2)
        }