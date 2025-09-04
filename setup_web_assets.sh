#!/bin/bash

# Setup script to make parsec-web available to Flutter web builds
# This script copies the necessary files from the parsec_web_lib submodule
# to the Flutter web assets

set -e

echo "🔧 Setting up parsec-web assets for Flutter web..."
echo "================================================="

# Check if parsec_web_lib submodule exists
if [ ! -d "parsec_web_lib" ]; then
    echo "❌ Error: parsec_web_lib submodule not found!"
    echo "Please run: git submodule add https://github.com/oxeanbits/parsec-web.git parsec_web_lib"
    exit 1
fi

# Create web assets directory for parsec-web
mkdir -p parsec/example/web/assets/parsec-web/js/
mkdir -p parsec/example/web/assets/parsec-web/wasm/

echo "📁 Copying JavaScript wrapper..."
cp parsec_web_lib/js/equations_parser_wrapper.js parsec/example/web/assets/parsec-web/js/

echo "📁 Checking for WASM files..."
if [ -d "parsec_web_lib/wasm" ] && [ -n "$(ls -A parsec_web_lib/wasm/)" ]; then
    echo "📁 Copying WASM files..."
    cp parsec_web_lib/wasm/* parsec/example/web/assets/parsec-web/wasm/
else
    echo "⚠️  WASM files not found. Building them..."
    cd parsec_web_lib
    
    # Check if build script exists and is executable
    if [ -x "./build.sh" ]; then
        ./build.sh
        echo "✅ WASM build completed"
        
        # Copy the built files
        if [ -d "wasm" ]; then
            cp wasm/* ../parsec/example/web/assets/parsec-web/wasm/
            echo "📁 WASM files copied to Flutter web assets"
        fi
    else
        echo "❌ Build script not found or not executable"
        echo "Please build parsec-web manually:"
        echo "cd parsec_web_lib && ./build.sh"
    fi
    
    cd ..
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Add to parsec/example/web/index.html:"
echo '   <script src="assets/parsec-web/js/equations_parser_wrapper.js"></script>'
echo '   <script src="assets/parsec-web/wasm/equations_parser.js"></script>'
echo ""
echo "2. Run Flutter web: flutter run -d chrome"
echo ""
echo "🚀 WebAssembly should now be available for web platform calculations!"