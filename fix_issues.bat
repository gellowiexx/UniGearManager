@echo off
REM Android Studio Preview & USB Connection Troubleshooting Script

echo.
echo ========================================
echo Android Studio Fix Script
echo ========================================
echo.

REM Check if ADB is available
set ADB_PATH=C:\Users\Shirly\AppData\Local\Android\Sdk\platform-tools\adb.exe

if not exist "%ADB_PATH%" (
    echo [ERROR] ADB not found at: %ADB_PATH%
    echo Please install Android SDK Platform-Tools first
    pause
    exit /b 1
)

:menu
cls
echo.
echo ========================================
echo Select an option:
echo ========================================
echo 1. Check connected devices
echo 2. Restart ADB daemon
echo 3. Clean Gradle cache
echo 4. Rebuild project
echo 5. Clear Android Studio cache
echo 6. All of the above
echo 0. Exit
echo.
set /p choice="Enter your choice (0-6): "

if "%choice%"=="1" goto check_devices
if "%choice%"=="2" goto restart_adb
if "%choice%"=="3" goto clean_gradle
if "%choice%"=="4" goto rebuild
if "%choice%"=="5" goto clear_studio_cache
if "%choice%"=="6" goto all_fixes
if "%choice%"=="0" exit /b 0
echo Invalid choice. Please try again.
pause
goto menu

:check_devices
cls
echo.
echo Checking connected devices...
echo.
"%ADB_PATH%" devices
echo.
echo If you see your device listed, it's connected!
echo If you see "unauthorized", enable USB debugging on your phone.
echo.
pause
goto menu

:restart_adb
cls
echo.
echo Restarting ADB daemon...
echo.
"%ADB_PATH%" kill-server
timeout /t 2 /nobreak
"%ADB_PATH%" start-server
echo.
echo ADB daemon restarted. Try connecting your phone now.
echo.
pause
goto menu

:clean_gradle
cls
echo.
echo Cleaning Gradle cache...
echo.
cd /d "C:\Users\Shirly\AndroidStudioProjects\UniGearManager"
call gradlew.bat clean
echo.
echo Gradle cache cleaned!
echo.
pause
goto menu

:rebuild
cls
echo.
echo Rebuilding project...
echo.
cd /d "C:\Users\Shirly\AndroidStudioProjects\UniGearManager"
call gradlew.bat build
echo.
echo Build complete!
echo.
pause
goto menu

:clear_studio_cache
cls
echo.
echo Clearing Android Studio cache...
echo This will delete cached files and may take a moment.
echo.
if exist "%USERPROFILE%\.gradle\caches" (
    echo Removing Gradle cache...
    rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul
    echo Done.
)
if exist "%USERPROFILE%\.android\build-cache" (
    echo Removing Android build cache...
    rmdir /s /q "%USERPROFILE%\.android\build-cache" 2>nul
    echo Done.
)
echo.
echo Cache cleared! Please restart Android Studio.
echo.
pause
goto menu

:all_fixes
cls
echo.
echo Running all fixes...
echo.
echo Step 1: Checking devices...
"%ADB_PATH%" devices
timeout /t 2 /nobreak

echo.
echo Step 2: Restarting ADB...
"%ADB_PATH%" kill-server
timeout /t 2 /nobreak
"%ADB_PATH%" start-server
timeout /t 2 /nobreak

echo.
echo Step 3: Cleaning Gradle...
cd /d "C:\Users\Shirly\AndroidStudioProjects\UniGearManager"
call gradlew.bat clean

echo.
echo Step 4: Clearing Studio cache...
if exist "%USERPROFILE%\.gradle\caches" (
    rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul
)
if exist "%USERPROFILE%\.android\build-cache" (
    rmdir /s /q "%USERPROFILE%\.android\build-cache" 2>nul
)

echo.
echo ========================================
echo All fixes completed!
echo ========================================
echo.
echo NEXT STEPS:
echo 1. Close Android Studio completely
echo 2. Reopen Android Studio
echo 3. Go to File -> Invalidate Caches -> Invalidate and Restart
echo 4. For phone connection: Make sure USB Debugging is enabled on your phone
echo 5. Try connecting your phone again
echo.
pause
goto menu
