$modulesPath = Join-Path $PSScriptRoot "PowerTools.*"

Get-ChildItem $modulesPath -Directory | ForEach-Object {
    Get-ChildItem $_.FullName -Recurse -Filter "*.psm1" | ForEach-Object {
        Import-Module $_.FullName
    }
}