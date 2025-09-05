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

echo "📁 Ensuring correct WASM module (equations_parser.js) is available..."

NEEDED_WASM="parsec_web_lib/wasm/equations_parser.js"

if [ ! -f "$NEEDED_WASM" ]; then
    echo "⚠️  equations_parser.js not found in parsec_web_lib/wasm. Attempting to build..."
    (
      cd parsec_web_lib
      if [ -x "./build.sh" ]; then
        ./build.sh || {
          echo "❌ Failed to build WebAssembly module. Please install Emscripten and try again.";
          echo "   See parsec_web_lib/build.sh for instructions.";
          exit 1;
        }
      else
        echo "❌ Build script not found or not executable"
        echo "Please build parsec-web manually:"
        echo "   cd parsec_web_lib && ./build.sh"
        exit 1
      fi
    )
fi

echo "📁 Copying equations_parser.js to Flutter web assets..."
cp "$NEEDED_WASM" parsec/example/web/assets/parsec-web/wasm/
echo "✅ Copied: parsec/example/web/assets/parsec-web/wasm/equations_parser.js"

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Ensure parsec/example/web/index.html includes:"
echo '   <script type="module" src="packages/parsec_web/parsec-web/js/equations_parser_wrapper.js"></script>'
echo '   <!-- WASM is loaded dynamically by the wrapper (../wasm/equations_parser.js); no direct tag needed -->'
echo ""
echo "2. Run Flutter web: flutter run -d chrome"
echo ""
echo "🚀 WebAssembly should now be available for web platform calculations!"
