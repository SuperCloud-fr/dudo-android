# Build a release APK even when the project lives under a non-ASCII path.
# gen_snapshot (AOT) cannot read app.dill through "Clément"-style paths on
# Windows; mapping the repo to a stable ASCII drive letter fixes it without
# moving the project.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File tool\build_release.ps1
#   powershell -ExecutionPolicy Bypass -File tool\build_release.ps1 --split-per-abi
#   powershell -ExecutionPolicy Bypass -File tool\build_release.ps1 -Clean
#
# Keep the same drive letter between runs: Flutter caches absolute paths.
param(
    [string]$Drive = "X",
    [switch]$Clean,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$BuildArgs = @()
)

$ErrorActionPreference = "Stop"

$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$flutter = (Get-Command flutter -ErrorAction SilentlyContinue).Source
if (-not $flutter) {
    $fallback = "C:\tools\flutter\bin\flutter.bat"
    if (Test-Path $fallback) { $flutter = $fallback }
}
if (-not $flutter) {
    throw "flutter introuvable. Ajoute C:\tools\flutter\bin au PATH."
}

function Invoke-FlutterBuild([string]$workingDirectory) {
    Push-Location $workingDirectory
    try {
        if ($Clean) {
            & $flutter clean
            if ($LASTEXITCODE -ne 0) { throw "flutter clean a echoue." }
        }
        & $flutter build apk --release @BuildArgs
        if ($LASTEXITCODE -ne 0) { throw "flutter build apk --release a echoue." }

        $apks = Get-ChildItem "build\app\outputs\flutter-apk\app-*release*.apk"
        foreach ($apk in $apks) {
            $relative = $apk.FullName.Substring($workingDirectory.Length).TrimStart("\", "/")
            $realPath = Join-Path $root $relative
            $size = [math]::Round($apk.Length / 1MB, 1)
            Write-Output ("{0}  ({1} MB)" -f $realPath, $size)
        }
    } finally {
        Pop-Location
    }
}

$isAscii = $root -notmatch '[^\x00-\x7F]'
if ($isAscii) {
    Invoke-FlutterBuild $root
    exit 0
}

$letter = $Drive.TrimEnd(":")
$mapping = subst | Where-Object { $_ -match "^$letter`:" }
$created = $false

if ($mapping) {
    Write-Host "Le lecteur ${letter}: est deja mappe ; reutilisation."
} else {
    if (Test-Path "${letter}:\") {
        throw "Le lecteur ${letter}: existe deja et n'est pas un mapping du depot. Passe -Drive Y."
    }
    subst "${letter}:" $root
    $created = $true
}

try {
    Write-Host "Projet monte sur ${letter}:\ (chemin ASCII stable)"
    Invoke-FlutterBuild "${letter}:\"
} finally {
    if ($created) { subst "${letter}:" /D }
}
