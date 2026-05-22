@echo off
REM UniGearManager App Installer
REM This script builds the app and installs it to an Android device

setlocal enabledelayedexpansion

set BUILD_TYPE=debug
if "%1"=="" goto check_adb
if "%1"=="debug" set BUILD_TYPE=debug
if "%1"=="release" set BUILD_TYPE=release

:check_adb
echo Checking for ADB...

REM Try to find ADB - check if it's in PATH first
where adb >nul 2>&1
if %errorlevel% equ 0 (
    set ADB_PATH=adb
    goto adb_found
)

REM Try typical Android SDK location
if exist "%USERPROFILE%\AppData\Local\Android\Sdk\platform-tools\adb.exe" (
    set "ADB_PATH=%USERPROFILE%\AppData\Local\Android\Sdk\platform-tools\adb.exe"
    goto adb_found
)

REM Try alternative locations
if exist "C:\Android\sdk\platform-tools\adb.exe" (
    set "ADB_PATH=C:\Android\sdk\platform-tools\adb.exe"
    goto adb_found
)

if exist "C:\Program Files\Android\Sdk\platform-tools\adb.exe" (
    set "ADB_PATH=C:\Program Files\Android\Sdk\platform-tools\adb.exe"
    goto adb_found
)

if exist "C:\Program Files (x86)\Android\Sdk\platform-tools\adb.exe" (
    set "ADB_PATH=C:\Program Files (x86)\Android\Sdk\platform-tools\adb.exe"
    goto adb_found
)

echo.
echo ERROR: ADB not found!
echo.
echo Please install Android Studio from: https://developer.android.com/studio
echo Or download the SDK platform-tools from: https://developer.android.com/tools/releases/platform-tools
echo.
echo Once installed, ADB should be at: %%USERPROFILE%%\AppData\Local\Android\Sdk\platform-tools\adb.exe
echo.
pause
exit /b 1

:adb_found

echo.
echo Checking connected devices...
%ADB_PATH% devices -l | findstr "device$" >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: No connected devices found!
    echo.
    echo Please:
    echo   1. Connect an Android device via USB
    echo   2. Enable USB debugging (Settings ^> Developer Options)
    echo   3. Accept the USB debugging permission prompt
    echo.
    pause
    exit /b 1
)

echo.
echo Connected devices:
%ADB_PATH% devices -l | findstr "device$"

echo.
echo Building %BUILD_TYPE% APK...
call gradlew.bat assemble%BUILD_TYPE:~0,1%%BUILD_TYPE:~1%

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo Build completed successfully!

REM Find APK file
for /r "%CD%\app\build\outputs\apk\%BUILD_TYPE%" %%F in (*.apk) do (
    if "%%F" not match "*unaligned*" (
        set APK_PATH=%%F
        goto install_app
    )
)

:install_app
if not defined APK_PATH (
    echo.
    echo ERROR: APK file not found after build!
    pause
    exit /b 1
)

echo.
echo Installing app to device...
%ADB_PATH% install -r "%APK_PATH%"

if errorlevel 1 (
    echo.
    echo Installation failed!
    pause
    exit /b 1
)

echo.
echo ✓ App installed successfully!
echo The app should now be available on your device.
echo Package: com.example.unigearmanager
echo.
pause
