# UniGearManager App Installer
# This script builds the app and installs it to an Android device

param(
    [ValidateSet("debug", "release")]
    [string]$buildType = "debug",
    [string]$deviceSerial = $null
)

# Colors for output
$successColor = "Green"
$errorColor = "Red"
$infoColor = "Cyan"

function Write-Success {
    Write-Host $args[0] -ForegroundColor $successColor
}

function Write-Error-Custom {
    Write-Host $args[0] -ForegroundColor $errorColor
}

function Write-Info {
    Write-Host $args[0] -ForegroundColor $infoColor
}

# Check if adb is available
Write-Info "Checking for ADB..."
$adbPath = "adb"

# Try to find ADB in PATH first
if (-not (Get-Command $adbPath -ErrorAction SilentlyContinue)) {
    # Try typical Android SDK location
    $androidSdkPath = "$env:APPDATA\..\Local\Android\Sdk\platform-tools\adb.exe"
    if (Test-Path $androidSdkPath) {
        $adbPath = $androidSdkPath
        Write-Info "Found ADB at: $adbPath"
    } else {
        # Try alternative Android SDK locations
        $alternativePaths = @(
            "C:\Android\sdk\platform-tools\adb.exe",
            "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe",
            "C:\Program Files\Android\Sdk\platform-tools\adb.exe",
            "C:\Program Files (x86)\Android\Sdk\platform-tools\adb.exe"
        )
        
        $found = $false
        foreach ($path in $alternativePaths) {
            if (Test-Path $path) {
                $adbPath = $path
                Write-Info "Found ADB at: $adbPath"
                $found = $true
                break
            }
        }
        
        if (-not $found) {
            Write-Error-Custom "ADB not found!"
            Write-Info "Please install Android SDK from: https://developer.android.com/studio"
            Write-Info "Or add Android SDK platform-tools to your PATH"
            exit 1
        }
    }
}

# Get connected devices
Write-Info "`nChecking connected devices..."
$devices = & $adbPath devices -l | Select-Object -Skip 1 | Where-Object { $_ -match "device$" }

if ($devices.Count -eq 0) {
    Write-Error-Custom "No connected devices found!"
    Write-Info "Please:"
    Write-Info "  1. Connect an Android device via USB"
    Write-Info "  2. Enable USB debugging on the device (Settings > Developer Options)"
    Write-Info "  3. Accept the USB debugging permission prompt"
    exit 1
}

Write-Success "Found $(($devices | Measure-Object).Count) connected device(s):`n"
$devices | ForEach-Object { Write-Host "  $_" }

# Select device if multiple are connected
if (($devices | Measure-Object).Count -gt 1) {
    if ($deviceSerial) {
        $selectedDevice = $devices | Where-Object { $_ -match $deviceSerial } | Select-Object -First 1
        if (-not $selectedDevice) {
            Write-Error-Custom "Device with serial $deviceSerial not found!"
            exit 1
        }
    } else {
        Write-Info "`nMultiple devices detected. Using first device."
    }
} else {
    $selectedDevice = $devices[0]
}

$deviceName = ($selectedDevice -split "\s+")[0]
Write-Success "`nUsing device: $deviceName"

# Build the APK
Write-Info "`nBuilding $buildType APK..."
$buildCommand = ".\gradlew.bat assemble${buildType.Substring(0,1).ToUpper()}${buildType.Substring(1)}"

try {
    & cmd /c "cd $PSScriptRoot && $buildCommand"
    if ($LASTEXITCODE -ne 0) {
        Write-Error-Custom "Build failed with exit code $LASTEXITCODE"
        exit 1
    }
}
catch {
    Write-Error-Custom "Error running build: $_"
    exit 1
}

Write-Success "`nBuild completed successfully!"

# Find the APK file
$apkPath = Get-ChildItem -Path "$PSScriptRoot\app\build\outputs\apk\$buildType" -Filter "*.apk" -Recurse | 
    Where-Object { $_.Name -notmatch "unaligned" } | 
    Select-Object -First 1

if (-not $apkPath) {
    Write-Error-Custom "APK file not found after build!"
    exit 1
}

Write-Success "Found APK: $($apkPath.Name)"

# Install the APK
Write-Info "`nInstalling app to device: $deviceName..."
& $adbPath -s $deviceName install -r $apkPath.FullName

if ($LASTEXITCODE -eq 0) {
    Write-Success "`n[SUCCESS] App installed successfully!"
    Write-Info "The app should now be available on your device."
    Write-Info "Package: com.example.unigearmanager"
} else {
    Write-Error-Custom "`n[FAILED] Installation failed!"
    exit 1
}
