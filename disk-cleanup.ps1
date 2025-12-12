# Disk Cleanup Script
# Cleans temporary files and frees up disk space

#Requires -RunAsAdministrator

Write-Host "=== Disk Cleanup Script ===" -ForegroundColor Cyan
Write-Host ""

# Display disk space before cleanup
Write-Host "Disk Space Before Cleanup:" -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | ForEach-Object {
    $freeGB = [math]::Round($_.Free / 1GB, 2)
    Write-Host "  Drive $($_.Name): $freeGB GB free"
}
Write-Host ""

$cleanedSize = 0

# Clean Windows Temp folder
Write-Host "Cleaning Windows Temp folder..." -ForegroundColor Yellow
$tempPath = "$env:SystemRoot\Temp"
if (Test-Path $tempPath) {
    $beforeSize = (Get-ChildItem $tempPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    Get-ChildItem $tempPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    $afterSize = (Get-ChildItem $tempPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $cleaned = $beforeSize - $afterSize
    $cleanedSize += $cleaned
    Write-Host "  Cleaned: $([math]::Round($cleaned / 1MB, 2)) MB" -ForegroundColor Green
}

# Clean User Temp folder
Write-Host "Cleaning User Temp folder..." -ForegroundColor Yellow
$userTempPath = "$env:TEMP"
if (Test-Path $userTempPath) {
    $beforeSize = (Get-ChildItem $userTempPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    Get-ChildItem $userTempPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    $afterSize = (Get-ChildItem $userTempPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $cleaned = $beforeSize - $afterSize
    $cleanedSize += $cleaned
    Write-Host "  Cleaned: $([math]::Round($cleaned / 1MB, 2)) MB" -ForegroundColor Green
}

# Clean Recycle Bin
Write-Host "Cleaning Recycle Bin..." -ForegroundColor Yellow
try {
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "  Recycle Bin emptied" -ForegroundColor Green
} catch {
    Write-Host "  Could not empty Recycle Bin" -ForegroundColor Yellow
}

# Clean Windows Update cache
Write-Host "Cleaning Windows Update cache..." -ForegroundColor Yellow
$updateCache = "$env:SystemRoot\SoftwareDistribution\Download"
if (Test-Path $updateCache) {
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    $beforeSize = (Get-ChildItem $updateCache -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    Get-ChildItem $updateCache -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    $afterSize = (Get-ChildItem $updateCache -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $cleaned = $beforeSize - $afterSize
    $cleanedSize += $cleaned
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    Write-Host "  Cleaned: $([math]::Round($cleaned / 1MB, 2)) MB" -ForegroundColor Green
}

# Clean Browser Caches (Edge)
Write-Host "Cleaning Edge browser cache..." -ForegroundColor Yellow
$edgeCachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
if (Test-Path $edgeCachePath) {
    $beforeSize = (Get-ChildItem $edgeCachePath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    Get-ChildItem $edgeCachePath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    $afterSize = (Get-ChildItem $edgeCachePath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $cleaned = $beforeSize - $afterSize
    $cleanedSize += $cleaned
    Write-Host "  Cleaned: $([math]::Round($cleaned / 1MB, 2)) MB" -ForegroundColor Green
}

Write-Host ""
Write-Host "Total Space Freed: $([math]::Round($cleanedSize / 1GB, 2)) GB" -ForegroundColor Green
Write-Host ""

# Display disk space after cleanup
Write-Host "Disk Space After Cleanup:" -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | ForEach-Object {
    $freeGB = [math]::Round($_.Free / 1GB, 2)
    Write-Host "  Drive $($_.Name): $freeGB GB free"
}

Write-Host ""
Write-Host "=== Cleanup Complete ===" -ForegroundColor Cyan
