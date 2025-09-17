@echo off
echo 🔧 Warehouse Inventory - Build Issues Fixer
echo ===========================================

echo 🧹 Step 1: Complete cleanup...
flutter clean
cd android
call gradlew clean
cd ..
if exist "build" rmdir /s /q "build"
if exist "android\build" rmdir /s /q "android\build"
if exist "android\app\build" rmdir /s /q "android\app\build"

echo 🗑️ Step 2: Clear Flutter cache...
flutter pub cache clean
flutter pub cache repair

echo 📦 Step 3: Update dependencies with compatible versions...
flutter pub get
flutter pub upgrade

echo  Step 4: Check Flutter environment...
flutter doctor -v

echo 🔨 Step 5: Build with fixed configuration...
flutter build apk --release

if %ERRORLEVEL% EQU 0 (
    echo ✅ Build successful!
    echo 📱 APK location: build\app\outputs\flutter-apk\
    echo.
    echo  Available APKs:
    dir /b "build\app\outputs\flutter-apk\*.apk"
) else (
    echo ❌ Build failed. Trying debug build...
    flutter build apk --debug
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Debug build successful!
        echo 📱 APK location: build\app\outputs\flutter-apk\
    ) else (
        echo ❌ Both builds failed. Check the error messages above.
        echo.
        echo 🔍 Additional troubleshooting:
        echo 1. Ensure Android SDK is properly installed
        echo 2. Check if Java 8 is installed and configured
        echo 3. Try running: flutter doctor --android-licenses
    )
)

pause
