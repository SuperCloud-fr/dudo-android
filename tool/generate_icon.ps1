$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$Res = Join-Path $Root "android\app\src\main\res"

function New-RoundedPath([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $r * 2
    $path.AddArc($x, $y, $d, $d, 180, 90)
    $path.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
    $path.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
    $path.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    return $path
}

function Draw-Background($g, [float]$s) {
    $rect = New-Object System.Drawing.RectangleF(0, 0, $s, $s)
    $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 29, 19, 12),
        [System.Drawing.Color]::FromArgb(255, 8, 6, 4),
        45.0)
    $g.FillRectangle($bg, $rect)
    $bg.Dispose()

    $glowRect = New-Object System.Drawing.RectangleF(($s * 0.18), (-$s * 0.12), ($s * 0.9), ($s * 0.9))
    $glow = New-Object System.Drawing.Drawing2D.GraphicsPath
    $glow.AddEllipse($glowRect)
    $brush = New-Object System.Drawing.Drawing2D.PathGradientBrush($glow)
    $brush.CenterColor = [System.Drawing.Color]::FromArgb(70, 255, 217, 138)
    $brush.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 217, 138))
    $g.FillPath($brush, $glow)
    $brush.Dispose()
    $glow.Dispose()
}

function Draw-Ring($g, [float]$cx, [float]$cy, [float]$radius, [float]$width) {
    $rect = New-Object System.Drawing.RectangleF(($cx - $radius), ($cy - $radius), ($radius * 2), ($radius * 2))
    $outer = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(230, 210, 162, 84), $width)
    $g.DrawEllipse($outer, $rect)
    $outer.Dispose()
    $innerRect = New-Object System.Drawing.RectangleF(($cx - $radius + $width * 1.8), ($cy - $radius + $width * 1.8), (($radius - $width * 1.8) * 2), (($radius - $width * 1.8) * 2))
    $inner = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 242, 206, 134), [Math]::Max(1.0, $width * 0.35))
    $g.DrawEllipse($inner, $innerRect)
    $inner.Dispose()
}

function Draw-Die($g, [float]$cx, [float]$cy, [float]$size) {
    $state = $g.Save()
    $g.TranslateTransform($cx, $cy)
    $g.RotateTransform(-9.0)

    $half = $size / 2
    $path = New-RoundedPath (-$half) (-$half) $size $size ($size * 0.19)

    $shadow = New-RoundedPath ((-$half) + $size * 0.025) ((-$half) + $size * 0.045) $size $size ($size * 0.19)
    $g.FillPath((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 0, 0, 0))), $shadow)
    $shadow.Dispose()

    $bodyRect = New-Object System.Drawing.RectangleF(-$half, -$half, $size, $size)
    $body = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $bodyRect,
        [System.Drawing.Color]::FromArgb(255, 246, 235, 211),
        [System.Drawing.Color]::FromArgb(255, 210, 189, 153),
        55.0)
    $g.FillPath($body, $path)
    $body.Dispose()
    $edge = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 122, 99, 69), [Math]::Max(1.0, $size * 0.025))
    $g.DrawPath($edge, $path)
    $edge.Dispose()

    # Five pips, the centre one is the red ace.
    $offset = $size * 0.235
    $pips = @(
        @(-$offset, -$offset), @($offset, -$offset),
        @(0, 0),
        @(-$offset, $offset), @($offset, $offset)
    )
    $pipRadius = $size * 0.072
    foreach ($pip in $pips) {
        $px = [float]$pip[0]
        $py = [float]$pip[1]
        $isAce = ($px -eq 0 -and $py -eq 0)
        $color = if ($isAce) {
            [System.Drawing.Color]::FromArgb(255, 163, 52, 44)
        } else {
            [System.Drawing.Color]::FromArgb(255, 36, 26, 18)
        }
        $g.FillEllipse((New-Object System.Drawing.SolidBrush($color)), ($px - $pipRadius), ($py - $pipRadius), ($pipRadius * 2), ($pipRadius * 2))
        if (-not $isAce) {
            $g.FillEllipse((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(45, 255, 255, 255))), ($px - $pipRadius * 0.5), ($py - $pipRadius * 0.55), ($pipRadius * 0.45), ($pipRadius * 0.45))
        }
    }

    $path.Dispose()
    $g.Restore($state)
}

function New-Icon([int]$size, [bool]$withBackground, [bool]$round) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    if ($round -and $withBackground) {
        $clip = New-Object System.Drawing.Drawing2D.GraphicsPath
        $clip.AddEllipse(0, 0, $size, $size)
        $g.SetClip($clip)
    }

    if ($withBackground) { Draw-Background $g $size }

    $ringRadius = if ($withBackground) { $size * 0.405 } else { $size * 0.315 }
    $dieSize = if ($withBackground) { $size * 0.36 } else { $size * 0.28 }
    $center = $size / 2.0
    Draw-Ring $g $center $center $ringRadius ($size * 0.032)
    Draw-Die $g $center $center $dieSize

    $g.Dispose()
    return $bmp
}

function Save-Png($bitmap, [string]$path) {
    $dir = Split-Path -Parent $path
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
}

$densities = @{
    "mdpi" = 1.0
    "hdpi" = 1.5
    "xhdpi" = 2.0
    "xxhdpi" = 3.0
    "xxxhdpi" = 4.0
}

foreach ($density in $densities.Keys) {
    $scale = $densities[$density]
    $legacy = [int](48 * $scale)
    $foreground = [int](108 * $scale)

    $bmp = New-Icon $legacy $true $false
    Save-Png $bmp (Join-Path $Res "mipmap-$density\ic_launcher.png")
    $bmp.Dispose()

    $bmp = New-Icon $legacy $true $true
    Save-Png $bmp (Join-Path $Res "mipmap-$density\ic_launcher_round.png")
    $bmp.Dispose()

    $bmp = New-Icon $foreground $false $false
    Save-Png $bmp (Join-Path $Res "mipmap-$density\ic_launcher_foreground.png")
    $bmp.Dispose()
}

$splash = New-Icon 384 $false $false
Save-Png $splash (Join-Path $Res "drawable-xxxhdpi\splash_logo.png")
$splash.Dispose()

Write-Output "Icons generated under $Res"
