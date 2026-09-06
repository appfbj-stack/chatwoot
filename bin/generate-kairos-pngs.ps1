#!/usr/bin/env powershell
# =============================================================================
# generate-kairos-pngs.ps1
# Regenera todos os PNGs de favicon/icone da public/ com a marca Kairos CRM
# Substitui os PNGs originais do Chatwoot por versoes emerald + "K" / "KC"
#
# Saida: 28 PNGs em public/ (favicon, apple, android, ms)
# Cor: emerald-500 (#10b981) no fundo, branco no texto
# =============================================================================

[CmdletBinding()]
param(
  [string]$PublicDir
)

if (-not $PublicDir) {
  $PublicDir = (Resolve-Path "$PSScriptRoot/../public").Path
}

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$bgColor      = [System.Drawing.Color]::FromArgb(255, 16, 185, 129)  # emerald-500
$bgDarkColor  = [System.Drawing.Color]::FromArgb(255, 15, 23, 42)    # slate-900
$fgColor      = [System.Drawing.Color]::White

function New-KairosPng {
  param(
    [int]$Size,
    [string]$Text,
    [string]$Path,
    $Background,
    $Foreground
  )

  if ($null -eq $Background) { $Background = $bgColor }
  if ($null -eq $Foreground) { $Foreground = $fgColor }

  $bmp = New-Object System.Drawing.Bitmap $Size, $Size
  $g   = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode     = 'AntiAlias'
  $g.TextRenderingHint = 'AntiAlias'
  $g.Clear($Background)

  # fonte: tamanho proporcional
  $fontSize = [Math]::Max(8, [int]($Size * 0.6))
  $font = New-Object System.Drawing.Font('Segoe UI', $fontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $brush = New-Object System.Drawing.SolidBrush($Foreground)
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment     = 'Center'
  $sf.LineAlignment = 'Center'

  $rect = New-Object System.Drawing.RectangleF 0, 0, $Size, $Size
  $g.DrawString($Text, $font, $brush, $rect, $sf)

  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose(); $font.Dispose(); $brush.Dispose()
  Write-Host "  ok $Path" -ForegroundColor Green
}

# --- spec de icones (path relativo a public/) -------------------------------
# Cada entrada: size, text, output path
$icons = @(
  # favicons
  @{ Size = 16;  Text = 'K'; Path = "$PublicDir/favicon-16x16.png" }
  @{ Size = 32;  Text = 'K'; Path = "$PublicDir/favicon-32x32.png" }
  @{ Size = 96;  Text = 'K'; Path = "$PublicDir/favicon-96x96.png" }
  @{ Size = 512; Text = 'K'; Path = "$PublicDir/favicon-512x512.png" }

  # favicon badge (notification badges - fundo slate-900)
  @{ Size = 16;  Text = 'K'; Path = "$PublicDir/favicon-badge-16x16.png";  Background = $bgDarkColor }
  @{ Size = 32;  Text = 'K'; Path = "$PublicDir/favicon-badge-32x32.png";  Background = $bgDarkColor }
  @{ Size = 96;  Text = 'K'; Path = "$PublicDir/favicon-badge-96x96.png";  Background = $bgDarkColor }

  # apple
  @{ Size = 57;  Text = 'K'; Path = "$PublicDir/apple-icon-57x57.png" }
  @{ Size = 60;  Text = 'K'; Path = "$PublicDir/apple-icon-60x60.png" }
  @{ Size = 72;  Text = 'K'; Path = "$PublicDir/apple-icon-72x72.png" }
  @{ Size = 76;  Text = 'K'; Path = "$PublicDir/apple-icon-76x76.png" }
  @{ Size = 114; Text = 'K'; Path = "$PublicDir/apple-icon-114x114.png" }
  @{ Size = 120; Text = 'K'; Path = "$PublicDir/apple-icon-120x120.png" }
  @{ Size = 144; Text = 'K'; Path = "$PublicDir/apple-icon-144x144.png" }
  @{ Size = 152; Text = 'K'; Path = "$PublicDir/apple-icon-152x152.png" }
  @{ Size = 180; Text = 'K'; Path = "$PublicDir/apple-icon-180x180.png" }
  @{ Size = 180; Text = 'K'; Path = "$PublicDir/apple-icon.png" }
  @{ Size = 180; Text = 'K'; Path = "$PublicDir/apple-icon-precomposed.png" }
  @{ Size = 180; Text = 'K'; Path = "$PublicDir/apple-touch-icon.png" }
  @{ Size = 180; Text = 'K'; Path = "$PublicDir/apple-touch-icon-precomposed.png" }

  # android
  @{ Size = 36;  Text = 'K'; Path = "$PublicDir/android-icon-36x36.png" }
  @{ Size = 48;  Text = 'K'; Path = "$PublicDir/android-icon-48x48.png" }
  @{ Size = 72;  Text = 'K'; Path = "$PublicDir/android-icon-72x72.png" }
  @{ Size = 96;  Text = 'K'; Path = "$PublicDir/android-icon-96x96.png" }
  @{ Size = 144; Text = 'K'; Path = "$PublicDir/android-icon-144x144.png" }
  @{ Size = 192; Text = 'K'; Path = "$PublicDir/android-icon-192x192.png" }

  # ms (Windows tiles)
  @{ Size = 70;  Text = 'K'; Path = "$PublicDir/ms-icon-70x70.png" }
  @{ Size = 144; Text = 'K'; Path = "$PublicDir/ms-icon-144x144.png" }
  @{ Size = 150; Text = 'K'; Path = "$PublicDir/ms-icon-150x150.png" }
  @{ Size = 310; Text = 'K'; Path = "$PublicDir/ms-icon-310x310.png" }
)

Write-Host "Gerando $($icons.Count) icones Kairos CRM em $PublicDir" -ForegroundColor Cyan
foreach ($ic in $icons) {
  New-KairosPng -Size $ic.Size -Text $ic.Text -Path $ic.Path -Background $ic.Background
}
Write-Host "`nConcluido." -ForegroundColor Green
