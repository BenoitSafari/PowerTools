function Compress-WslVolume {
    <#
        .SYNOPSIS
            Compresses a WSL volume to reclaim space (requires Administrator privileges).
        
        .DESCRIPTION
            This function compresses a WSL volume using Diskpart to reclaim space.
        
        .PARAMETER DistributionName
            The name of the WSL distribution whose volume you want to compress.
        
        .EXAMPLE
            Compress-WslVolume -DistributionName "Ubuntu-20.04"
        
            This command compresses the WSL volume for the specified distribution.  
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$DistributionName
    )
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "This function requires Administrator privileges. Please run PowerShell as Administrator."
        return
    }
    $vdhxPath = Get-WslVolumePath -DistributionName $DistributionName
    & wsl --shutdown

    $diskpartCommands = @(
        "select vdisk file=`"$vdhxPath`"",
        "compact vdisk",
        "exit"
    )

    $tempFile = [System.IO.Path]::GetTempFileName()
    Set-Content -Path $tempFile -Value $diskpartCommands -Encoding ASCII
    diskpart /s $tempFile
    Remove-Item $tempFile -Force
}

Export-ModuleMember -Function Compress-WslVolume
