# IT Scripts Collection

A collection of PowerShell scripts for common IT administration tasks.

## Scripts

### 1. system-info.ps1
Displays comprehensive system information including:
- Computer details
- Operating system information
- CPU specifications
- Memory usage
- Disk space
- Network adapters

**Usage:**
```powershell
.\system-info.ps1
```

### 2. network-diagnostics.ps1
Performs network diagnostics including:
- Active network adapters
- IP configuration
- Connectivity tests
- DNS resolution
- Gateway and DNS server information

**Usage:**
```powershell
# Basic usage
.\network-diagnostics.ps1

# Test specific host
.\network-diagnostics.ps1 -TargetHost "google.com" -PingCount 10
```

### 3. disk-cleanup.ps1
Cleans temporary files and frees disk space:
- Windows temp folder
- User temp folder
- Recycle bin
- Windows Update cache
- Browser caches

**Usage:**
```powershell
# Run as Administrator
.\disk-cleanup.ps1
```

### 4. user-management.ps1
Manages local user accounts:
- List all users
- Create new users
- Enable/disable accounts

**Usage:**
```powershell
# List users
.\user-management.ps1

# Create user
.\user-management.ps1 -Action Create -Username "newuser"

# Disable user
.\user-management.ps1 -Action Disable -Username "username"

# Enable user
.\user-management.ps1 -Action Enable -Username "username"
```

### 5. service-manager.ps1
Manages Windows services:
- List services
- Start/stop/restart services
- Check service status

**Usage:**
```powershell
# List all services
.\service-manager.ps1

# Start a service
.\service-manager.ps1 -Action Start -ServiceName "Spooler"

# Stop a service
.\service-manager.ps1 -Action Stop -ServiceName "Spooler"

# Restart a service
.\service-manager.ps1 -Action Restart -ServiceName "Spooler"

# Check service status
.\service-manager.ps1 -Action Status -ServiceName "Spooler"
```

## Requirements

- Windows PowerShell 5.1 or later
- Administrator privileges (for disk-cleanup.ps1 and user-management.ps1)

## Notes

- Always test scripts in a safe environment before running in production
- Some scripts require administrator privileges
- Review script contents before execution to understand what they do
