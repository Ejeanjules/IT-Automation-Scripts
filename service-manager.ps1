# Service Manager Script
# Manages Windows services

param(
    [ValidateSet("List", "Start", "Stop", "Restart", "Status")]
    [string]$Action = "List",
    [string]$ServiceName
)

Write-Host "=== Service Manager ===" -ForegroundColor Cyan
Write-Host ""

switch ($Action) {
    "List" {
        Write-Host "Running Services:" -ForegroundColor Yellow
        Get-Service | Where-Object { $_.Status -eq "Running" } | 
            Sort-Object DisplayName | 
            Format-Table Name, DisplayName, Status -AutoSize | Out-Host
        
        Write-Host ""
        Write-Host "Stopped Services:" -ForegroundColor Yellow
        Get-Service | Where-Object { $_.Status -eq "Stopped" } | 
            Sort-Object DisplayName | 
            Select-Object -First 10 |
            Format-Table Name, DisplayName, Status -AutoSize
        Write-Host "(Showing first 10 stopped services)"
    }
    
    "Start" {
        if (-not $ServiceName) {
            Write-Host "Error: ServiceName required" -ForegroundColor Red
            Write-Host "Usage: .\service-manager.ps1 -Action Start -ServiceName 'ServiceName'"
            exit
        }
        
        try {
            Start-Service -Name $ServiceName
            Write-Host "Service '$ServiceName' started successfully" -ForegroundColor Green
        } catch {
            Write-Host "Error starting service: $_" -ForegroundColor Red
        }
    }
    
    "Stop" {
        if (-not $ServiceName) {
            Write-Host "Error: ServiceName required" -ForegroundColor Red
            Write-Host "Usage: .\service-manager.ps1 -Action Stop -ServiceName 'ServiceName'"
            exit
        }
        
        try {
            Stop-Service -Name $ServiceName -Force
            Write-Host "Service '$ServiceName' stopped successfully" -ForegroundColor Green
        } catch {
            Write-Host "Error stopping service: $_" -ForegroundColor Red
        }
    }
    
    "Restart" {
        if (-not $ServiceName) {
            Write-Host "Error: ServiceName required" -ForegroundColor Red
            Write-Host "Usage: .\service-manager.ps1 -Action Restart -ServiceName 'ServiceName'"
            exit
        }
        
        try {
            Restart-Service -Name $ServiceName -Force
            Write-Host "Service '$ServiceName' restarted successfully" -ForegroundColor Green
        } catch {
            Write-Host "Error restarting service: $_" -ForegroundColor Red
        }
    }
    
    "Status" {
        if (-not $ServiceName) {
            Write-Host "Error: ServiceName required" -ForegroundColor Red
            Write-Host "Usage: .\service-manager.ps1 -Action Status -ServiceName 'ServiceName'"
            exit
        }
        
        try {
            $service = Get-Service -Name $ServiceName
            Write-Host "Service: $($service.DisplayName)" -ForegroundColor Yellow
            Write-Host "  Name: $($service.Name)"
            Write-Host "  Status: $($service.Status)"
            Write-Host "  Start Type: $($service.StartType)"
            
            # Get additional details
            $serviceWMI = Get-CimInstance Win32_Service | Where-Object { $_.Name -eq $ServiceName }
            if ($serviceWMI) {
                Write-Host "  Path: $($serviceWMI.PathName)"
                Write-Host "  Process ID: $($serviceWMI.ProcessId)"
            }
        } catch {
            Write-Host "Error getting service status: $_" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "=== Operation Complete ===" -ForegroundColor Cyan
