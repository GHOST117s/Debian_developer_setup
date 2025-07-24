#!/bin/bash
# Test installation script for Debian Developer Setup

echo "🧪 Testing Debian Developer Setup Package Installation..."

# Check if package file exists
if [ ! -f "../debian-dev-setup_1.0.0_all.deb" ]; then
    echo "❌ Package file not found. Please build the package first with ./build.sh"
    exit 1
fi

echo "📦 Package file found: ../debian-dev-setup_1.0.0_all.deb"

# Display package information
echo ""
echo "📊 Package Information:"
dpkg -I "../debian-dev-setup_1.0.0_all.deb"

echo ""
echo "📋 Package Contents:"
dpkg -c "../debian-dev-setup_1.0.0_all.deb"

echo ""
echo "✅ Package validation completed!"
echo ""
echo "🚀 To install and test:"
echo "   sudo dpkg -i ../debian-dev-setup_1.0.0_all.deb"
echo "   sudo apt-get install -f"
echo "   debian-dev-setup install"
echo ""
echo "🗑️  To remove after testing:"
echo "   sudo apt remove debian-dev-setup"
