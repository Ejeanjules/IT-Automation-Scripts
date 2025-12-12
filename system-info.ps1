# System Information Script
# Collects and displays comprehensive system information

Write-Host "=== System Information Report ===" -ForegroundColor Cyan
Write-Host ""

# Computer Information
Write-Host "Computer Details:" -ForegroundColor Yellow
$computerInfo = Get-ComputerInfo
Write-Host "  Computer Name: $($computerInfo.CsName)"
Write-Host "  Manufacturer: $($computerInfo.CsManufacturer)"
Write-Host "  Model: $($computerInfo.CsModel)"
Write-Host "  Domain: $($computerInfo.CsDomain)"
Write-Host ""

# Operating System
Write-Host "Operating System:" -ForegroundColor Yellow
Write-Host "  OS Name: $($computerInfo.OsName)"
Write-Host "  Version: $($computerInfo.OsVersion)"
Write-Host "  Build: $($computerInfo.OsBuildNumber)"
Write-Host "  Install Date: $($computerInfo.OsInstallDate)"
Write-Host "  Last Boot: $($computerInfo.OsLastBootUpTime)"
Write-Host ""

# CPU Information
Write-Host "Processor:" -ForegroundColor Yellow
$cpu = Get-CimInstance Win32_Processor
Write-Host "  Name: $($cpu.Name)"
Write-Host "  Cores: $($cpu.NumberOfCores)"
Write-Host "  Logical Processors: $($cpu.NumberOfLogicalProcessors)"
Write-Host ""

# Memory Information
Write-Host "Memory:" -ForegroundColor Yellow
$memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
$totalMemoryGB = [math]::Round($memory.Sum / 1GB, 2)
Write-Host "  Total RAM: $totalMemoryGB GB"
$freeMemory = Get-CimInstance Win32_OperatingSystem
$freeMemoryGB = [math]::Round($freeMemory.FreePhysicalMemory / 1MB, 2)
Write-Host "  Free RAM: $freeMemoryGB GB"
Write-Host ""

# Disk Information
Write-Host "Disk Drives:" -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | ForEach-Object {
    $usedGB = [math]::Round($_.Used / 1GB, 2)
    $freeGB = [math]::Round($_.Free / 1GB, 2)
    $totalGB = $usedGB + $freeGB
    $percentUsed = [math]::Round(($usedGB / $totalGB) * 100, 1)
    Write-Host "  Drive $($_.Name): $usedGB GB / $totalGB GB used ($percentUsed%)"
}
Write-Host ""

# Network Adapters
Write-Host "Network Adapters:" -ForegroundColor Yellow
Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | ForEach-Object {
    Write-Host "  $($_.Name) - $($_.InterfaceDescription)"
    $ipConfig = Get-NetIPAddress -InterfaceIndex $_.InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue
    if ($ipConfig) {
        Write-Host "    IP Address: $($ipConfig.IPAddress)"
    }
}

Write-Host ""
Write-Host "=== End of Report ===" -ForegroundColor Cyan
