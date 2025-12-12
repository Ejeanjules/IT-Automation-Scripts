# User Management Script
# Displays and manages local user accounts

#Requires -RunAsAdministrator

param(
    [ValidateSet("List", "Create", "Disable", "Enable")]
    [string]$Action = "List",
    [string]$Username,
    [string]$Password
)

Write-Host "=== User Management Script ===" -ForegroundColor Cyan
Write-Host ""

switch ($Action) {
    "List" {
        Write-Host "Local User Accounts:" -ForegroundColor Yellow
        Get-LocalUser | Format-Table Name, Enabled, LastLogon, PasswordLastSet -AutoSize
        
        Write-Host ""
        Write-Host "Local Groups:" -ForegroundColor Yellow
        Get-LocalGroup | Format-Table Name, Description -AutoSize
    }
    
    "Create" {
        if (-not $Username) {
            Write-Host "Error: Username required for Create action" -ForegroundColor Red
            Write-Host "Usage: .\user-management.ps1 -Action Create -Username 'newuser' -Password 'SecureP@ss123'"
            exit
        }
        
        try {
            if (-not $Password) {
                $SecurePassword = Read-Host "Enter password for $Username" -AsSecureString
            } else {
                $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
            }
            
            New-LocalUser -Name $Username -Password $SecurePassword -FullName $Username -Description "Created by IT script"
            Write-Host "User '$Username' created successfully" -ForegroundColor Green
        } catch {
            Write-Host "Error creating user: $_" -ForegroundColor Red
        }
    }
    
    "Disable" {
        if (-not $Username) {
            Write-Host "Error: Username required for Disable action" -ForegroundColor Red
            Write-Host "Usage: .\user-management.ps1 -Action Disable -Username 'username'"
            exit
        }
        
        try {
            Disable-LocalUser -Name $Username
            Write-Host "User '$Username' disabled successfully" -ForegroundColor Green
        } catch {
            Write-Host "Error disabling user: $_" -ForegroundColor Red
        }
    }
    
    "Enable" {
        if (-not $Username) {
            Write-Host "Error: Username required for Enable action" -ForegroundColor Red
            Write-Host "Usage: .\user-management.ps1 -Action Enable -Username 'username'"
            exit
        }
        
        try {
            Enable-LocalUser -Name $Username
            Write-Host "User '$Username' enabled successfully" -ForegroundColor Green
        } catch {
            Write-Host "Error enabling user: $_" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "=== Operation Complete ===" -ForegroundColor Cyan
