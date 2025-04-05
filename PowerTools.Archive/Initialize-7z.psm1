function Initialize-7z {
    [CmdletBinding()]
    param()

    $exeDirPath = Join-Path $env:ProgramFiles "7-Zip"
    $exePath = Join-Path $exeDirPath "7z.exe"
    $sevenZipVer = "2409"
    $installerUrl = "https://www.7-zip.org/a/7z${sevenZipVer}-x64.exe"

    if (Test-Path $exePath) {
        Add-ToPath $exePath
        return
    }

    Write-Warning "7-Zip is not installed on this system."
    $choice = Read-Host "Do you want to install it now? (Y/N)"
    if ($choice -notin @('Y', 'y')) {
        return
    }

    Write-Host "Installing 7-Zip..."
    $installerPath = "$env:TEMP\7zInstaller.exe"
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait

    if (Test-Path $exePath) {
        Add-ToPath $exePath
        Write-Host "7-Zip installed successfully."
        return
    }
    
    Write-Error "7-Zip installation failed."
}

Export-ModuleMember -Function Initialize-7z
