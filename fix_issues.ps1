# Android Studio Preview & USB Connection Troubleshooting Script (PowerShell)

$AdbPath = "C:\Users\Shirly\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$ProjectPath = "C:\Users\Shirly\AndroidStudioProjects\UniGearManager"

function Show-Menu {
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "Android Studio Fix Script"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "1. Check connected devices"
    Write-Host "2. Restart ADB daemon"
    Write-Host "3. Clean Gradle cache"
    Write-Host "4. Rebuild project"
    Write-Host "5. Clear Android Studio cache"
    Write-Host "6. Run all fixes"
    Write-Host "0. Exit"
    Write-Host ""
}

function Check-ADB {
    if (-not (Test-Path $AdbPath)) {
        Write-Host "[ERROR] ADB not found at: $AdbPath"
        Write-Host "Please install Android SDK Platform-Tools first"
        Read-Host "Press Enter to exit"
        exit 1
    }
}

function Check-Devices {
    Clear-Host
    Write-Host ""
    Write-Host "Checking connected devices..."
    Write-Host ""
    & $AdbPath devices
    Write-Host ""
    Write-Host "If you see your device listed, it's connected!"
    Write-Host "If you see 'unauthorized', enable USB debugging on your phone."
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Restart-ADB {
    Clear-Host
    Write-Host ""
    Write-Host "Restarting ADB daemon..."
    Write-Host ""
    & $AdbPath kill-server
    Start-Sleep -Seconds 2
    & $AdbPath start-server
    Write-Host ""
    Write-Host "ADB daemon restarted. Try connecting your phone now."
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Clean-Gradle {
    Clear-Host
    Write-Host ""
    Write-Host "Cleaning Gradle cache..."
    Write-Host ""
    Set-Location $ProjectPath
    & .\gradlew.bat clean
    Write-Host ""
    Write-Host "Gradle cache cleaned!"
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Rebuild-Project {
    Clear-Host
    Write-Host ""
    Write-Host "Rebuilding project..."
    Write-Host ""
    Set-Location $ProjectPath
    & .\gradlew.bat build
    Write-Host ""
    Write-Host "Build complete!"
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Clear-StudioCache {
    Clear-Host
    Write-Host ""
    Write-Host "Clearing Android Studio cache..."
    Write-Host ""
    
    $gradleCache = "$env:USERPROFILE\.gradle\caches"
    $buildCache = "$env:USERPROFILE\.android\build-cache"
    
    if (Test-Path $gradleCache) {
        Write-Host "Removing Gradle cache..."
        Remove-Item -Path $gradleCache -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Done."
    }
    
    if (Test-Path $buildCache) {
        Write-Host "Removing Android build cache..."
        Remove-Item -Path $buildCache -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Done."
    }
    
    Write-Host ""
    Write-Host "Cache cleared! Please restart Android Studio."
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Run-AllFixes {
    Clear-Host
    Write-Host ""
    Write-Host "Running all fixes..."
    Write-Host ""
    
    Write-Host "Step 1: Checking devices..."
    & $AdbPath devices
    Start-Sleep -Seconds 2
    
    Write-Host ""
    Write-Host "Step 2: Restarting ADB..."
    & $AdbPath kill-server
    Start-Sleep -Seconds 2
    & $AdbPath start-server
    Start-Sleep -Seconds 2
    
    Write-Host ""
    Write-Host "Step 3: Cleaning Gradle..."
    Set-Location $ProjectPath
    & .\gradlew.bat clean
    
    Write-Host ""
    Write-Host "Step 4: Clearing Studio cache..."
    
    $gradleCache = "$env:USERPROFILE\.gradle\caches"
    $buildCache = "$env:USERPROFILE\.android\build-cache"
    
    if (Test-Path $gradleCache) {
        Remove-Item -Path $gradleCache -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path $buildCache) {
        Remove-Item -Path $buildCache -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host ""
    Write-Host "========================================"
    Write-Host "All fixes completed!"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "NEXT STEPS:"
    Write-Host "1. Close Android Studio completely"
    Write-Host "2. Reopen Android Studio"
    Write-Host "3. Go to File -> Invalidate Caches -> Invalidate and Restart"
    Write-Host "4. For phone connection: Make sure USB Debugging is enabled"
    Write-Host "5. Try connecting your phone again"
    Write-Host ""
    Read-Host "Press Enter to continue"
}

# Main loop
Check-ADB

do {
    Show-Menu
    $choice = Read-Host "Enter your choice (0-6)"
    
    switch ($choice) {
        '1' { Check-Devices }
        '2' { Restart-ADB }
        '3' { Clean-Gradle }
        '4' { Rebuild-Project }
        '5' { Clear-StudioCache }
        '6' { Run-AllFixes }
        '0' { exit 0 }
        default { Write-Host "Invalid choice. Please try again."; Start-Sleep -Seconds 2 }
    }
} while ($true)
