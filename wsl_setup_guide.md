# WSL Setup Guide - Making Windows Act Like Linux VM

## What is WSL?

**Windows Subsystem for Linux (WSL)** lets you run a **real Linux environment** directly on Windows without the overhead of a traditional virtual machine or dual-boot setup.

### WSL vs Traditional VM
- **Traditional VM**: Heavy, uses lots of resources, slow startup
- **WSL**: Lightweight, fast startup, integrated with Windows, minimal resource overhead

## Prerequisites

- Windows 10 (version 2004 and higher) or Windows 11
- Administrator access
- At least 4GB RAM recommended

## Step-by-Step Installation

### Method 1: Simple Installation (Recommended)

**1. Open PowerShell as Administrator**
- Press `Win + X`
- Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

**2. Install WSL with one command:**
```powershell
wsl --install
```

This automatically:
- Enables WSL feature
- Enables Virtual Machine Platform
- Downloads and installs Ubuntu (default distribution)
- Sets WSL 2 as default version

**3. Restart your computer**
- Required to complete installation

**4. Set up Ubuntu**
- Ubuntu will launch automatically after restart
- Create a username (can be different from Windows username)
- Create a password (won't show characters while typing - this is normal)

### Method 2: Manual Installation (If Method 1 fails)

**1. Enable WSL Feature**
```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

**2. Enable Virtual Machine Platform**
```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**3. Restart your computer**

**4. Download WSL2 Linux kernel update**
- Go to: https://aka.ms/wsl2kernel
- Download and install the update package

**5. Set WSL 2 as default version**
```powershell
wsl --set-default-version 2
```

**6. Install Ubuntu from Microsoft Store**
- Open Microsoft Store
- Search for "Ubuntu"
- Click "Get" to install

## Verification and Setup

### 1. Verify Installation
```powershell
wsl --list --verbose
```

Expected output:
```
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

### 2. Check WSL Version
```bash
wsl --version
```

### 3. Access Your Linux Environment

**From Windows:**
- Type "Ubuntu" in Start Menu
- Or open Command Prompt/PowerShell and type: `wsl`

**Your Linux Home Directory:**
```bash
pwd  # Shows current directory
ls   # List files
```

## Essential Configuration

### 1. Update Linux System
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Essential Tools
```bash
# Install common development tools
sudo apt install -y curl wget git vim nano build-essential

# Install Python and pip
sudo apt install -y python3 python3-pip

# Install Node.js (if needed)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 3. Configure Git (if you use it)
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Key WSL Features and Usage

### 1. File System Integration

**Windows files from WSL:**
```bash
# Access Windows C: drive
cd /mnt/c/

# Access Windows Desktop
cd /mnt/c/Users/YourWindowsUsername/Desktop/
```

**Linux files from Windows:**
- In File Explorer, type: `\\wsl$\Ubuntu\home\yourusername\`

### 2. Running Windows Programs from WSL
```bash
# Open Windows Notepad
notepad.exe

# Open current directory in Windows Explorer
explorer.exe .

# Run PowerShell from WSL
powershell.exe
```

### 3. Running Linux Commands from Windows
```cmd
# From Command Prompt or PowerShell
wsl ls -la
wsl cat /etc/os-release
wsl sudo apt update
```

## Managing WSL

### Common WSL Commands

```powershell
# List installed distributions
wsl --list

# List with detailed info
wsl --list --verbose

# Start WSL
wsl

# Start specific distribution
wsl -d Ubuntu

# Shutdown WSL
wsl --shutdown

# Shutdown specific distribution
wsl --terminate Ubuntu

# Set default distribution
wsl --set-default Ubuntu

# Convert distribution to WSL 2
wsl --set-version Ubuntu 2
```

### Multiple Distributions

You can install multiple Linux distributions:

```powershell
# Install from Microsoft Store:
# - Ubuntu
# - Debian
# - openSUSE
# - Fedora
# - Alpine
```

## Performance Optimization

### 1. Configure WSL Settings
Create `.wslconfig` file in your Windows user directory:

**Location:** `C:\Users\YourUsername\.wslconfig`

```ini
[wsl2]
memory=4GB
processors=2
swap=2GB
localhostforwarding=true
```

### 2. Restart WSL to apply settings
```powershell
wsl --shutdown
wsl
```

## Development Workflow

### 1. VS Code Integration
- Install "Remote - WSL" extension in VS Code
- Open WSL terminal in VS Code: `Ctrl+Shift+P` → "WSL: New Window"
- Or from WSL: `code .` to open current directory

### 2. Docker Integration
```bash
# Install Docker in WSL
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Restart WSL session
exit
wsl
```

### 3. Web Development Server
```bash
# Start a web server (example with Python)
python3 -m http.server 8000

# Access from Windows browser: http://localhost:8000
```

## Troubleshooting

### Common Issues:

**1. WSL not starting:**
```powershell
# Restart WSL service
wsl --shutdown
wsl
```

**2. "WslRegisterDistribution failed with error: 0x8007019e"**
- Enable "Windows Subsystem for Linux" in Windows Features
- Restart computer

**3. Ubuntu/Linux not found in Start Menu:**
- Check Microsoft Store for installation
- Or run: `wsl --install -d Ubuntu`

**4. Permission denied errors:**
```bash
# Fix file permissions
sudo chmod +x filename
# Or for directories
sudo chmod -R 755 directory/
```

**5. Can't access internet in WSL:**
```bash
# Check DNS
cat /etc/resolv.conf

# If needed, update DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

## Advanced Tips

### 1. Custom Shell Setup
```bash
# Install zsh (optional)
sudo apt install zsh
chsh -s $(which zsh)

# Install oh-my-zsh for better terminal experience
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 2. Backup and Restore WSL
```powershell
# Export WSL distribution
wsl --export Ubuntu C:\backup\ubuntu-backup.tar

# Import WSL distribution
wsl --import Ubuntu C:\wsl\ubuntu C:\backup\ubuntu-backup.tar
```

### 3. Resource Monitoring
```bash
# Check system resources in WSL
htop  # Install with: sudo apt install htop

# Check disk usage
df -h

# Check memory usage
free -h
```

## ✅ Result

After following this guide, you have:
- ✅ **Full Linux environment** running inside Windows
- ✅ **Native Linux commands** and tools
- ✅ **Integrated file system** between Windows and Linux
- ✅ **Development environment** ready for coding
- ✅ **Docker and Kubernetes** capability

**Your Windows machine now acts like a Linux VM** but with better performance and integration than traditional virtualization!