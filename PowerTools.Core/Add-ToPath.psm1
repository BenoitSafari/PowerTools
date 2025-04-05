function Add-ToPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$PathToAdd
    )
    
    $Path = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)

    if ($PathToAdd -Like "*.exe") {
        if (Test-Path $PathToAdd) {
            $PathToAdd = [System.IO.Path]::GetDirectoryName($PathToAdd)
        } else {
            Write-Error "Could not find the file $PathToAdd"
            return
        }
    }

    if ($Path.Contains($PathToAdd)) {
        return
    }
    [Environment]::SetEnvironmentVariable("Path", "$Path;$PathToAdd", [EnvironmentVariableTarget]::User)
}

Export-ModuleMember -Function Add-ToPath
