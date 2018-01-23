# Data structure for storing target types
$script:Types = @{}

# Data structure for storing targets
$script:Targets = @{}

# Import functions
Get-ChildItem -Path "$PSScriptRoot\Functions" -Filter '*.ps1' -Recurse | ForEach-Object {
    . "$($_.FullName)"
}