function Compress-All {
    <#
        .SYNOPSIS
            Compresses all files in a specified folder into archives of a specified format.

        .DESCRIPTION
            This function compresses all files in the specified folder into archives of the specified format (zip, 7z, or tar).
            It can also delete the original files after compression if the -Delete switch is used.

        .PARAMETER FolderPath
            The path to the folder containing the files to be compressed.

        .PARAMETER Delete
            If specified, deletes the original files after compression.

        .PARAMETER Format
            The format of the archive. Supported formats are: zip, 7z, tar. Default is zip.

        .EXAMPLE
            Compress-All "C:\path\to\folder" -Delete -Format "zip"

            This command compresses all files in "C:\path\to\folder" into zip archives and deletes the original files.
    #>
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$FolderPath,
        [Parameter(Mandatory=$false)]
        [switch]$Delete,
        [Parameter(Mandatory=$false)]
        [string]$Format = "zip"
    )
    Initialize-7z
    $files = Get-ChildItem -Path $FolderPath -File
    $parameters = @{
        "7z" = "-t7z -mx=9"
        "tar" = "-ttar"
        "zip" = "-tzip -mx=9"
    }

    if ($Format -notin $parameters.Keys) {
        Write-Error "Unsupported format: $Format. Supported formats are: ${($parameters.Keys -join ', ')}"
        return
    }
    if (-not (Test-Path $FolderPath)) {
        Write-Error "The specified folder does not exist: $FolderPath"
        return
    }

    foreach ($file in $files) {
        $archiveName = Join-Path -Path $FolderPath -ChildPath ($file.BaseName + ".${Format}")
        & 7z a $parameters[$Format].Split() $archiveName $file.FullName
        if ($Delete) {
            Remove-Item -Path $file.FullName
        }
    }
}

Export-ModuleMember -Function Compress-All
