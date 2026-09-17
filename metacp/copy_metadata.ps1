Param (
    [Parameter(Mandatory=$True)] [ValidateNotNull()] [string] $sourceDir,
    [Parameter(Mandatory=$True)] [ValidateNotNull()] [string] $destDir
)

$extensions = @("MOV", "MP4")

function CopyMedatada {
    param($source,$destination)
    exifwin -overwrite_original -extractEmbedded -TagsFromFile $source -All:All $destination
}


# count files for progress
$count = (Get-ChildItem $destDir -Recurse | Where-Object {
    $_.Extension.ToUpper() -eq ".mp4"
} | Measure-Object).Count
Write-Output "Found $count image videos to update"

$iterator = 0
$skipped = 0
Get-ChildItem $destDir -Recurse | Where-Object {
    $_.Extension.ToUpper() -eq ".mp4"
} | ForEach-Object {
    $destFileName = $_.BaseName
    $destPath = $_.FullName

    $sourceFound = $false
    foreach ($ext in $extensions) {
        $sourcePath = "$sourceDir/$destFileName.$ext"

        if (Test-Path -Path "$sourceDir/$destFileName.$ext" -PathType Leaf) {
            CopyMedatada -Source $sourcePath -Destination $destPath
            $sourceFound = $true
            break
        }
    }
    if (-not ($sourceFound)) {
        $skipped ++
    }


    # update progress
    # https://docs.microsoft.com/de-de/powershell/scripting/learn/deep-dives/write-progress-across-multiple-threads?view=powershell-7.1
    $iterator++
    $percent = $iterator / $count * 100
    $percentReadable = "{0:N2}" -f $percent
    Write-Progress -Activity "Copied metadata of $count files" -Status "$percentReadable% complete ($skipped videos skipped because no source file was found)" -PercentComplete $percent
}

Write-Output "Finished! Skipped $skipped files."