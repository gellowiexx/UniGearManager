# UniGearManager App Installer

This directory contains automated installer scripts to build and deploy the UniGearManager app to an Android device.

## Available Installers

### PowerShell Installer (Recommended)
- **File**: `install_app.ps1`
- **Platform**: Windows PowerShell
- **Features**: Better error handling and device detection

**Usage:**
```powershell
# Install debug build (default)
.\install_app.ps1

# Install release build
.\install_app.ps1 -buildType release

# Install to specific device
.\install_app.ps1 -buildType debug -deviceSerial "device_serial_number"
```

### Batch File Installer
- **File**: `install_app.bat`
- **Platform**: Windows CMD
- **Compatibility**: Works with older Windows systems

**Usage:**
```cmd
# Install debug build (default)
install_app.bat

# Install release build
install_app.bat release
```

## Prerequisites

### 1. Android SDK & ADB (Android Debug Bridge)
The installer requires ADB to be installed and available in your system PATH.

**Installation:**
- Install Android Studio from https://developer.android.com/studio
- During installation, make sure to install "Android SDK Platform Tools"
- Add ADB to PATH (usually at: `C:\Users\YourUsername\AppData\Local\Android\Sdk\platform-tools`)

**Verify Installation:**
```powershell
adb version
```

### 2. USB Debugging on Android Device
Before connecting your device, enable USB debugging:

1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times (until "Developer Mode Enabled" message)
3. Go to **Settings** → **System** → **Developer Options**
4. Enable **USB Debugging**
5. Connect your device via USB
6. Accept the "Allow USB debugging" permission on your device

### 3. Gradle & Java
These are included with the project, but ensure:
- Java Development Kit (JDK) 11 or higher is installed
- The `gradlew` files are executable

## How It Works

1. **Detection** - Finds connected Android devices
2. **Build** - Compiles the app into an APK file
3. **Install** - Deploys the APK to your device using ADB

## Output Locations

After a successful build:
- **Debug APK**: `app/build/outputs/apk/debug/*.apk`
- **Release APK**: `app/build/outputs/apk/release/*.apk`

## Troubleshooting

### "No connected devices found"
- Ensure USB cable is properly connected
- Enable USB Debugging on your device (see Prerequisites section)
- On your Android device, accept the USB debugging permission prompt
- Restart ADB: `adb kill-server` then `adb start-server`

### "ADB not found"
- Install Android SDK if not already installed
- Add ADB to your system PATH
- Restart your terminal/PowerShell after adding to PATH

### Build fails
- Ensure you're in the project root directory
- Run `.\gradlew.bat clean` to clean the build
- Check that all dependencies are downloaded: `.\gradlew.bat build`

### PowerShell execution policy error
If you get an execution policy error, run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Manual Installation Alternative

If the automated scripts don't work, you can manually install:

1. **Build the APK:**
   ```cmd
   .\gradlew.bat assembleDebug
   ```

2. **Find the APK** at: `app/build/outputs/apk/debug/app-debug.apk`

3. **Install manually:**
   ```cmd
   adb install -r app/build/outputs/apk/debug/app-debug.apk
   ```

## Common Commands

```powershell
# List connected devices
adb devices -l

# Uninstall the app
adb uninstall com.example.unigearmanager

# View app logs
adb logcat | findstr "unigearmanager"

# Open app after installation
adb shell am start -n com.example.unigearmanager/.MainActivity
```

## Building for Release

For production releases to Google Play:

```cmd
# Build signed release APK (requires keystore setup)
.\gradlew.bat assembleRelease

# Build App Bundle
.\gradlew.bat bundleRelease
```

## Support

If you encounter issues:
1. Check this troubleshooting section
2. Review the build output for specific error messages
3. Ensure all prerequisites are properly installed
4. Try the manual installation alternative above
