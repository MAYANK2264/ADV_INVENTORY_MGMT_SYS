# Warehouse Inventory Management System - Build Guide

## Quick Build Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android SDK with command line tools
- Java Development Kit (JDK 8 or higher)

### Build APK

1. **Run the build script**:
   ```bash
   scripts\build_apk.bat
   ```

2. **Or build manually**:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

### APK Location
After successful build, find your APK at:
```
build/app/outputs/flutter-apk/app-release.apk
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

### Debug Commands
```bash
# Check Flutter installation
flutter doctor -v

# Analyze project
flutter analyze

# Check dependencies
flutter pub deps
```

## Project Structure

- `lib/` - Flutter application code
- `android/` - Android-specific configuration
- `scripts/` - Build scripts
- `google_apps_script/` - Backend API code
- `assets/` - Application assets

## Features

- 📊 Real-time dashboard with warehouse statistics
- 🗺️ Interactive warehouse map visualization
- 📦 Complete inventory management system
- 🔍 Advanced search and filtering
- 🎨 Modern glassmorphism UI design
- ☁️ Google Sheets backend integration

## Support

For issues or questions:
1. Check the Issues page on GitHub
2. Create a new issue if your problem isn't already reported
3. Contact the maintainer

---

**Made with ❤️ using Flutter**
