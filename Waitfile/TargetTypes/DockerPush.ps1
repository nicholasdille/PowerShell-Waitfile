New-TargetType `
    -Name 'DockerPush' `
    -Arguments 'Registry','Name','Tag' `
    -Test {
            param([hashtable]$Arguments)
            docker image ls --filter=reference=$($Arguments.Registry):$($Arguments.Tag)
            $false
        } `
    -New {
            param([hashtable]$Arguments)
            docker image push $($Arguments.Registry):$($Arguments.Tag)
        } `
    -Remove {}