# Network Diagnostics Script
# Tests connectivity and displays network information

param(
    [string]$TargetHost = "8.8.8.8",
    [int]$PingCount = 4
)

Write-Host "=== Network Diagnostics ===" -ForegroundColor Cyan
Write-Host ""

# Display active network adapters
Write-Host "Active Network Adapters:" -ForegroundColor Yellow
Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Format-Table Name, InterfaceDescription, Status, LinkSpeed -AutoSize
Write-Host ""

# Display IP configuration
Write-Host "IP Configuration:" -ForegroundColor Yellow
Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" } | 
    Format-Table InterfaceAlias, IPAddress, PrefixLength -AutoSize
Write-Host ""

# Test internet connectivity
Write-Host "Testing Connectivity to $TargetHost..." -ForegroundColor Yellow
$pingResult = Test-Connection -ComputerName $TargetHost -Count $PingCount -ErrorAction SilentlyContinue

if ($pingResult) {
    $avgLatency = ($pingResult | Measure-Object -Property ResponseTime -Average).Average
    Write-Host "  Status: Connected" -ForegroundColor Green
    Write-Host "  Average Latency: $([math]::Round($avgLatency, 2)) ms"
    Write-Host "  Packets Sent: $PingCount"
    Write-Host "  Packets Received: $($pingResult.Count)"
} else {
    Write-Host "  Status: Failed" -ForegroundColor Red
}
Write-Host ""

# DNS Resolution Test
Write-Host "DNS Resolution Test:" -ForegroundColor Yellow
$testDomains = @("google.com", "microsoft.com")
foreach ($domain in $testDomains) {
    try {
        $dnsResult = Resolve-DnsName -Name $domain -ErrorAction Stop
        Write-Host "  $domain -> $($dnsResult[0].IPAddress)" -ForegroundColor Green
    } catch {
        Write-Host "  $domain -> Failed" -ForegroundColor Red
    }
}
Write-Host ""

# Display Default Gateway
Write-Host "Default Gateway:" -ForegroundColor Yellow
Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1 | ForEach-Object {
    Write-Host "  Gateway: $($_.NextHop)"
    Write-Host "  Interface: $($_.InterfaceAlias)"
}
Write-Host ""

# Display DNS Servers
Write-Host "DNS Servers:" -ForegroundColor Yellow
Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { $_.ServerAddresses.Count -gt 0 } | ForEach-Object {
    Write-Host "  Interface: $($_.InterfaceAlias)"
    $_.ServerAddresses | ForEach-Object { Write-Host "    DNS: $_" }
}

Write-Host ""
Write-Host "=== Diagnostics Complete ===" -ForegroundColor Cyan
