#!/bin/bash
# Build script for Debian Developer Setup package

set -e

echo "🔨 Building Debian Developer Setup package..."

# Check if we're in the right directory
if [ ! -f "DEBIAN/control" ]; then
    echo "❌ Error: DEBIAN/control file not found. Please run this script from the package root directory."
    exit 1
fi

# Create a temporary build directory
BUILD_DIR=$(mktemp -d)
PACKAGE_NAME="debian-dev-setup"
VERSION=$(grep "^Version:" DEBIAN/control | cut -d' ' -f2)
ARCHITECTURE=$(grep "^Architecture:" DEBIAN/control | cut -d' ' -f2)
DEB_FILE="${PACKAGE_NAME}_${VERSION}_${ARCHITECTURE}.deb"

echo "📦 Building package: $DEB_FILE"
echo "🗂️  Using temporary build directory: $BUILD_DIR"

# Copy only the necessary files to build directory
cp -r DEBIAN usr "$BUILD_DIR/"

# Ensure correct permissions
chmod 755 "$BUILD_DIR/DEBIAN"
chmod 755 "$BUILD_DIR/DEBIAN/postinst" "$BUILD_DIR/DEBIAN/prerm"
chmod 755 "$BUILD_DIR/usr/bin/debian-dev-setup"
chmod 755 "$BUILD_DIR/usr/share/debian-dev-setup/dev-setup.sh"

# Build the .deb package
dpkg-deb --build "$BUILD_DIR" "../$DEB_FILE"

# Clean up
rm -rf "$BUILD_DIR"

echo "✅ Package built successfully: ../$DEB_FILE"
echo ""
echo "📋 To install the package:"
echo "   sudo dpkg -i ../$DEB_FILE"
echo "   sudo apt-get install -f  # Fix any dependency issues"
echo ""
echo "📋 To run after installation:"
echo "   debian-dev-setup install"
echo ""
echo "📊 Package information:"
dpkg -I "../$DEB_FILE"
