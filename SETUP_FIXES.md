# Android Studio Preview & Phone Connection Fix Guide

## Issue 1: XML Design Preview Not Showing in Android Studio

### Quick Fixes (Do these first):

1. **Invalidate Caches & Restart**
   - In Android Studio: File → Invalidate Caches → Invalidate and Restart
   - This clears cached files that may be corrupt

2. **Rebuild the Project**
   - In Android Studio: Build → Rebuild Project
   - Or run: `gradlew build` in terminal

3. **Clear Android Studio Cache**
   - Close Android Studio
   - Delete: `C:\Users\Shirly\.android\build-cache`
   - Restart Android Studio

### If Preview Still Doesn't Show:

4. **Check Build Variants**
   - At the bottom of Android Studio, look for "Build Variants"
   - Make sure you're on the `debug` variant
   - Select a layout file and open the Design tab

5. **Switch Preview API Level**
   - Open any XML layout file
   - In the Design tab (right panel)
   - Look for "API Level" selector at the top
   - Change to API 30 or API 33 (matches your targetSdk: 36)

6. **Reset Preview Settings**
   - Right-click on the layout file in Project view
   - Select: Open in → Text Editor
   - Then switch to Design view
   - This resets the preview state

7. **Try Building Debug APK**
   - Run: `gradlew assembleDebug` in terminal
   - This forces a full build that may fix preview issues

---

## Issue 2: Phone Not Connecting to Laptop via USB

### On Your Phone (Android Device):

**Enable USB Debugging:**
1. Go to Settings → About phone
2. Tap "Build number" 7 times rapidly (until you see "Developer mode enabled")
3. Go back to Settings → System → Developer options (or Advanced)
4. Enable "USB Debugging"
5. Enable "USB Debugging (Security settings)"
6. (Optional) Enable "Install via USB" if available

**USB Connection Settings:**
1. Plug phone into laptop with USB cable
2. A popup will appear on phone asking for "Allow access to device data?"
3. Tap "Allow" or "OK"
4. In notification panel, tap USB notification
5. Select "File Transfer" or "Android Debug Bridge (ADB)" mode (NOT "Charge only")

### On Your Laptop (Windows):

**Install ADB Drivers:**

If Android Studio doesn't recognize your phone:

1. Open Android Studio
2. Go to: Tools → SDK Manager → SDK Tools tab
3. Check that these are installed:
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Google USB Driver

4. If Google USB Driver isn't installed:
   - Check the box and click "OK" to install
   - Restart your laptop after installation

5. Verify ADB Path:
   - Platform-Tools should be at: `C:\Users\Shirly\AppData\Local\Android\Sdk\platform-tools`

**Check if Device is Connected:**

Open PowerShell/Command Prompt and run:
```powershell
cd C:\Users\Shirly\AppData\Local\Android\Sdk\platform-tools
.\adb devices
```

You should see:
```
List of attached devices
XXXXXXXXXXXXX     device
```

If you see "unauthorized" instead of "device":
- On your phone, tap "Allow" when the USB authorization popup appears
- Run `adb devices` again

### Verify Connection in Android Studio:

1. Tools → Device Manager (or AVD Manager)
2. You should see your phone listed under "Physical devices"
3. If not shown, try:
   - Unplug USB cable
   - Unplug from USB port, wait 5 seconds
   - Plug back in
   - Unlock phone
   - Check phone notification and allow access

---

## Complete Solution Checklist:

### For Preview Issues:
- [ ] File → Invalidate Caches → Invalidate and Restart
- [ ] Build → Rebuild Project
- [ ] Close & reopen layout XML file
- [ ] Check Build Variants (select "debug")
- [ ] Set Preview API Level to 30+

### For Phone Connection:
- [ ] Enable USB Debugging on phone (Settings → Developer options)
- [ ] Enable USB Debugging Security settings
- [ ] Change USB mode to "File Transfer" or "ADB"
- [ ] Tap "Allow" on phone USB authorization popup
- [ ] Install Google USB Driver in SDK Manager
- [ ] Verify with: `adb devices` command
- [ ] Unplug/replug USB cable and try again

---

## Need More Help?

If issues persist:

1. **For Preview:** 
   - Try File → New → Sample Data Directory
   - If that works, preview was disabled

2. **For USB Connection:**
   - Update phone Android version
   - Try different USB port/cable
   - Update drivers: Device Manager → Update driver (right-click phone)
   - Factory reset Google USB Driver from SDK Manager

