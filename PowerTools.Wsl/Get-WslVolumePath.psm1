function Get-WslVolumePath {
    param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$DistributionName
    )

    if (-not $DistributionName) {
        $distributions = @(Get-Distributions)
        if ($distributions.Count -eq 0) {
            Write-Error "No WSL distributions installed."
            return
        }

        Write-Host "No distribution name provided. Please select one from the list:"
        for ($i = 0; $i -lt $distributions.Count; $i++) {
            Write-Host "$($i + 1). $($distributions[$i])"
        }

        $selection = Read-Host "Enter the number of the distribution"
        if ($selection -match '^\d+$' -and $selection -gt 0 -and $selection -le $distributions.Count) {
            $DistributionName = $distributions[$selection - 1]
        } else {
            Write-Host "Invalid selection."
            return
        }
    }

    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss"
    $distro = Get-ChildItem -Path $registryPath | Where-Object { $_.GetValue("DistributionName") -eq $DistributionName }

    if ($distro) {
        $Path = $distro.GetValue("BasePath")
        $Path = $Path -replace "^\\\\\?\\", ""
        return $Path
    } else {
        Write-Host "Could not find '${DistributionName}' volume file."
        return $null
    }
}

Export-ModuleMember -Function Get-WslVolumePath
