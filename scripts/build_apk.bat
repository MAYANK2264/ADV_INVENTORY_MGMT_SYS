@echo off
echo 🚀 Warehouse Inventory Management System - APK Builder
echo ==================================================

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Flutter is not installed or not in PATH
    echo Please install Flutter and try again
    pause
    exit /b 1
)

REM Check Flutter version
echo 📱 Flutter version:
flutter --version

REM Clean everything thoroughly
echo 🧹 Cleaning previous builds and caches...
flutter clean
cd android
call gradlew clean
cd ..

REM Remove build directories
if exist "build" rmdir /s /q "build"
if exist "android\build" rmdir /s /q "android\build"
if exist "android\app\build" rmdir /s /q "android\app\build"

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Pre-build checks
echo  Running pre-build checks...
flutter doctor
flutter analyze

REM Build release APK with verbose output
echo 🔨 Building release APK...
flutter build apk --release --verbose

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Release build failed
    echo 🔧 Trying debug build...
    flutter build apk --debug --verbose
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ Both builds failed
        echo.
        echo 🔍 Troubleshooting steps:
        echo 1. Check Flutter doctor output above
        echo 2. Ensure Android SDK is properly installed
        echo 3. Check if all dependencies are compatible
        echo 4. Try running: flutter clean && flutter pub get
        pause
        exit /b 1
    )
)

REM Display build results
echo.
echo ✅ Build completed successfully!
echo ==================================================
echo 📁 APK files location: build/app/outputs/flutter-apk/
echo.

REM Check if APK files exist
if exist "build\app\outputs\flutter-apk\*.apk" (
    echo  Available APKs:
    dir /b "build\app\outputs\flutter-apk\*.apk"
    echo.
    echo  APK ready for distribution!
) else (
    echo ❌ No APK files found in expected location
    echo 📁 Checking all build outputs...
    dir /s /b "build\app\outputs\*.apk"
)

pause
