#!/bin/bash

# Warehouse Inventory Management System - APK Build Script
# This script builds different versions of the APK for distribution

echo "🚀 Warehouse Inventory Management System - APK Builder"
echo "=================================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter and try again"
    exit 1
fi

# Check Flutter version
echo "📱 Flutter version:"
flutter --version

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Run tests
echo "🧪 Running tests..."
flutter test

# Build debug APK
echo "🔨 Building debug APK..."
flutter build apk --debug

# Build release APK
echo "🔨 Building release APK..."
flutter build apk --release

# Build split APKs (recommended for smaller file size)
echo "🔨 Building split APKs..."
flutter build apk --split-per-abi

# Display build results
echo ""
echo "✅ Build completed successfully!"
echo "=================================================="
echo "📁 APK files location: build/app/outputs/flutter-apk/"
echo ""
echo "📱 Available APKs:"
echo "  • app-debug.apk (Debug version)"
echo "  • app-release.apk (Release version)"
echo "  • app-arm64-v8a-release.apk (ARM64 devices)"
echo "  • app-armeabi-v7a-release.apk (ARM devices)"
echo "  • app-x86_64-release.apk (x86_64 devices)"
echo ""
echo "💡 For distribution, use the split APKs or the release APK"
echo "   The split APKs are smaller and optimized for specific architectures"
echo ""
echo "🎉 Happy distributing!"
