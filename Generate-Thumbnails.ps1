$inputDir = "./media"
$outputDir = "./thumbs"

if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Get-ChildItem $inputDir -Filter *.webm | ForEach-Object {
    $name = $_.BaseName
    $videoPath = $_.FullName
    $outputPath = Join-Path $outputDir "$name.webp"

    # get duration (float)
    $duration = ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $videoPath

    # calculate 40%
    $timestamp = [double]$duration * 0.4

    Write-Host "Generating thumbnail for $name.webm at $timestamp seconds..."

    ffmpeg -y -i $videoPath -ss $timestamp -vframes 1 $outputPath
}

Write-Host "Done! Thumbnails saved in $outputDir"
