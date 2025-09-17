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

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Build release APK
echo 🔨 Building release APK...
flutter build apk --release

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Release build failed
    echo 🔧 Trying debug build...
    flutter build apk --debug
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ Both builds failed
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
echo 📱 Available APKs:
dir /b "build\app\outputs\flutter-apk\*.apk"
echo.
echo 🎉 APK ready for distribution!
pause
