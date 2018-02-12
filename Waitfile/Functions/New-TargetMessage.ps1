function New-TargetMessage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        "PSUseShouldProcessForStateChangingFunctions",
        "",
        Justification = "Creates in-memory object only."
    )]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        $Message
    )

    process {
        if ($Types.ContainsKey($Name)) {
            throw "Message called $Name already exists"
        }
        Write-Verbose "Creating message <$Name>"

        $Messages[$Name] = $Message
    }
}