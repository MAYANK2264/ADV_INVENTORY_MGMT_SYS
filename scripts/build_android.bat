@echo off
echo ===== Building Android APK =====

echo Cleaning previous builds...
flutter clean

echo Installing dependencies...
flutter pub get

echo Running tests...
flutter test

echo Building debug APK...
flutter build apk --debug

echo Building release APK...
flutter build apk --release

echo ===== Build Complete =====
echo Debug APK location: build\app\outputs\flutter-apk\app-debug.apk
echo Release APK location: build\app\outputs\flutter-apk\app-release.apk

echo Listing all APK files:
dir /s /b "build\*.apk"