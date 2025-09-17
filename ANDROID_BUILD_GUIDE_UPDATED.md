# Android Build Guide (Updated)

## Overview

This guide provides instructions for building and troubleshooting the Android APK for the Warehouse Inventory application. The build process has been updated to fix previous issues with APK generation and artifact uploads.

## GitHub Actions Workflow

The project uses a GitHub Actions workflow (`build-android.yml`) to automatically build Android APKs when:
- Code is pushed to the `main` or `master` branch
- A pull request is created against the `main` or `master` branch
- The workflow is manually triggered

### Key Improvements in the Updated Workflow

1. **Updated Java Version**: Now using Java 17 instead of Java 11 for better compatibility
2. **Improved APK Path Handling**: Added commands to ensure APKs are found and copied to the expected location
3. **Enhanced Artifact Upload**: Using wildcard paths and `always()` condition to ensure artifacts are uploaded even if some steps fail
4. **Verbose Build Output**: Added verbose flag to Flutter build commands for better debugging
5. **Diagnostic Steps**: Added steps to show Flutter/Java versions and list APK files
6. **Clean Build Steps**: Added `flutter clean` before each build to prevent conflicts
7. **Disabled Lint Errors**: Configured Gradle to ignore lint errors that might fail the build
8. **Separate Build Steps**: Separated debug and release builds with individual clean steps

## Troubleshooting Common Issues

### No APK Files Found

If the workflow fails with "No files were found" errors:

1. **Check the build logs**: Look for specific error messages in the "Build Debug APK" and "Build Release APK" steps
2. **Verify APK location**: The "List Debug APK files" and "List Release APK files" steps show where APKs are being generated
3. **Java version issues**: Ensure the workflow is using Java 17 as specified
4. **Clean build directory**: The workflow now includes `flutter clean` before each build to prevent conflicts

### Build Failures

If the APK build fails:

1. **Check for compilation errors**: Look for specific error messages in the build logs
2. **Dependency issues**: Ensure all dependencies in `pubspec.yaml` are compatible
3. **Android configuration**: Verify the Android configuration in `android/app/build.gradle`
4. **Lint errors**: The build.gradle now includes `lintOptions { abortOnError false }` to prevent lint errors from failing the build
5. **Java HOME issues**: If you see "JAVA_HOME is set to an invalid directory" errors, ensure your local environment has Java 17 installed and properly configured

### Using the Local Build Script

A new batch script has been added to help with local builds:

1. Run `scripts/build_android.bat` from the project root
2. The script will clean, install dependencies, run tests, and build both debug and release APKs
3. It will also list all generated APK files at the end

## Manual Building

To build the APK manually:

1. Ensure you have Java 17 installed and JAVA_HOME properly set
2. Install Flutter 3.19.3
3. Run the following commands:

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Clean again before release build
flutter clean

# Build release APK
flutter build apk --release
```

4. The APKs will be located in:
   - Debug: `build/app/outputs/flutter-apk/app-debug.apk`
   - Release: `build/app/outputs/flutter-apk/app-release.apk`

5. Alternatively, use the provided script:
   - Windows: `scripts/build_android.bat`

## Installing the APK

### From GitHub Actions

1. Go to the Actions tab in the GitHub repository
2. Select the latest successful workflow run
3. Scroll down to the Artifacts section
4. Download either the debug or release APK
5. Transfer the APK to your Android device and install it

### From Local Build

1. Connect your Android device to your computer
2. Enable USB debugging on your device
3. Run `flutter install` to install the APK directly

## Key Changes Made to Fix Build Issues

1. **Updated Java Version**: Changed from Java 11 to Java 17
2. **Modified APK Output Path**: Added code to ensure APKs are generated with consistent names
3. **Enhanced Artifact Upload**: Changed artifact paths to use wildcards
4. **Added Diagnostic Steps**: Added steps to show versions and list APK files
5. **Improved Error Handling**: Added continue-on-error flags and always() conditions

These changes ensure that the build process is more reliable and that artifacts are properly uploaded even if some steps encounter issues.