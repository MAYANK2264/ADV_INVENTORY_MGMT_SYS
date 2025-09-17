# Android Build Guide

## GitHub Actions Workflow

This project uses a GitHub Actions workflow to automatically build Android APKs. The workflow is defined in `.github/workflows/build-android.yml` and is triggered on:

- Push to `main` or `master` branches
- Pull requests to `main` or `master` branches
- Manual trigger via GitHub Actions UI

## Build Process

The workflow performs the following steps:

1. Checks out the repository code
2. Sets up Java 11
3. Sets up Flutter 3.19.3
4. Installs dependencies with `flutter pub get`
5. Configures Flutter for Android
6. Runs tests (continues even if tests fail)
7. Builds debug APK
8. Builds release APK
9. Uploads both APKs as artifacts

## Downloading APKs

After the workflow completes successfully, you can download the APKs:

1. Go to your GitHub repository
2. Click on the "Actions" tab
3. Select the latest workflow run
4. Scroll down to the "Artifacts" section
5. Download either:
   - `warehouse-inventory-debug` - Debug version for testing
   - `warehouse-inventory-release` - Release version for distribution

## Installing APKs

### On Android Device

1. Download the APK to your Android device
2. Open the APK file
3. If prompted about installing from unknown sources, enable the setting for your browser or file manager
4. Follow the on-screen instructions to install

### Using ADB (Android Debug Bridge)

1. Download the APK to your computer
2. Connect your Android device via USB and enable USB debugging
3. Run: `adb install path/to/downloaded-apk.apk`

## Troubleshooting

If you encounter build issues:

1. Check the workflow logs for specific error messages
2. Ensure your Flutter code is compatible with Flutter 3.19.3
3. Verify that all dependencies in `pubspec.yaml` are available and compatible
4. Check that Android configuration in `android/app/build.gradle` is correct

## Manual Building

To build the APK locally:

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

The APKs will be available at:
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- Release: `build/app/outputs/flutter-apk/app-release.apk`