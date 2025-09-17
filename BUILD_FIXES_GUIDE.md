# Build Fixes Guide

This guide documents the fixes applied to resolve build issues in the Warehouse Inventory Management System.

## Issues Fixed

### 1. Android Build Configuration
- **Reverted to stable versions**: Using Gradle 7.5 and Kotlin 1.7.10 for compatibility
- **Android Gradle Plugin**: Using 7.3.0 for stability
- **Kotlin version**: Using 1.7.10 to match plugin requirements
- **SDK versions**: Using Flutter's default SDK versions for compatibility
- **NDK version**: Using Flutter's default NDK version

### 2. Gradle Properties Optimization
- **Increased JVM memory**: From 1536M to 2048M
- **Added build optimizations**: Parallel builds and caching enabled
- **Disabled R8 full mode**: Prevents potential build issues

### 3. Dependencies Updates
- **Updated HTTP package**: From ^1.1.0 to ^1.2.0 for better stability
- **Maintained compatibility**: All other dependencies kept at stable versions

### 4. Build Scripts Simplification
- **Simplified build process**: Removed complex error handling that was causing issues
- **Single build script**: Only `scripts/build_apk.bat` remains
- **Fallback mechanism**: Tries release build first, then debug if release fails
- **Clean output**: Simple, clear build status messages

## Build Script Available

### `scripts/build_apk.bat`
- Simple and reliable build script
- Builds release APK first, falls back to debug if needed
- Lists generated APK files
- Minimal error handling for better compatibility

## Prerequisites

### Required Tools
1. **Flutter SDK**: Version 3.24.5 or higher
2. **Android SDK**: With command line tools installed
3. **Java Development Kit**: JDK 8 or higher

### Android SDK Setup
If you encounter Android toolchain issues:

1. **Install Android Studio** (recommended)
2. **Install command line tools**:
   ```bash
   # Navigate to Android SDK directory
   cd %ANDROID_HOME%\cmdline-tools
   
   # Install latest command line tools
   sdkmanager --install "cmdline-tools;latest"
   ```

3. **Set environment variables**:
   ```
   ANDROID_HOME=C:\Users\%USERNAME%\AppData\Local\Android\Sdk
   PATH=%PATH%;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\cmdline-tools\latest\bin
   ```

## Build Process

### Quick Test
```bash
# Run the test build script
scripts\test_build.bat
```

### Full Build
```bash
# Run the main build script
scripts\build_apk.bat
```

### Manual Build Commands
```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Build debug APK
flutter build apk --debug --no-sound-null-safety

# Build release APK
flutter build apk --release --no-sound-null-safety

# Build split APKs
flutter build apk --split-per-abi --no-sound-null-safety
```

## Troubleshooting

### Common Issues

1. **"cmdline-tools component is missing"**
   - Install Android Studio or command line tools
   - Set ANDROID_HOME environment variable

2. **"Gradle build failed"**
   - Check internet connection
   - Clear Gradle cache: `flutter clean`
   - Try building with verbose output: `flutter build apk --verbose`

3. **"Dependencies conflict"**
   - Run `flutter pub deps` to check dependencies
   - Update dependencies: `flutter pub upgrade`

4. **"Build timeout"**
   - Increase JVM memory in `android/gradle.properties`
   - Disable parallel builds temporarily

### Debug Commands
```bash
# Check Flutter installation
flutter doctor -v

# Analyze project
flutter analyze

# Check dependencies
flutter pub deps

# Build with verbose output
flutter build apk --verbose --no-sound-null-safety
```

## Output Files

After successful build, APK files will be located in:
```
build/app/outputs/flutter-apk/
├── app-debug.apk
├── app-release.apk
├── app-arm64-v8a-release.apk
├── app-armeabi-v7a-release.apk
└── app-x86_64-release.apk
```

## Performance Tips

1. **Use split APKs** for distribution (smaller file sizes)
2. **Enable Gradle caching** for faster subsequent builds
3. **Use parallel builds** for multi-core systems
4. **Increase JVM memory** for large projects

## Support

If you encounter issues not covered in this guide:

1. Check Flutter documentation: https://docs.flutter.dev
2. Check Android build documentation: https://developer.android.com/studio/build
3. Run `flutter doctor -v` for detailed environment information
4. Check the build logs for specific error messages
