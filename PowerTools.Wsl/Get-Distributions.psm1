function Get-Distributions {
    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss"
    return @(
        Get-ChildItem -Path $registryPath | ForEach-Object {
            $_.GetValue("DistributionName")
        }
    )
}

Export-ModuleMember -Function Get-Distributions
