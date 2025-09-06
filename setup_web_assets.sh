#!/bin/bash

# Setup script to make parsec-web available to Flutter web builds
# This script verifies the parsec-web submodule is properly set up and builds
# the WebAssembly files if needed. The parsec-web submodule is located at:
#   parsec_web/lib/parsec-web/
# Flutter web builds can load them directly from:
#   packages/parsec_web/parsec-web/js/equations_parser_wrapper.js
#   packages/parsec_web/parsec-web/wasm/equations_parser.js

set -e

echo "🔧 Setting up parsec-web assets from submodule..."
echo "==============================================="

# Check if parsec-web submodule exists
if [ ! -d "parsec_web/lib/parsec-web" ]; then
  echo "❌ parsec-web submodule not found!"
  echo "   Expected location: parsec_web/lib/parsec-web/"
  echo "   Please initialize the submodule first:"
  echo "   git submodule update --init --recursive"
  exit 1
fi

# Ensure WASM files are built in the submodule (or gracefully skip if toolchain missing)
if [ ! -f "parsec_web/lib/parsec-web/wasm/equations_parser.js" ]; then
  echo "🔧 Building WebAssembly files in submodule..."
  if command -v emcc >/dev/null 2>&1; then
    (
      set -e
      cd parsec_web/lib/parsec-web
      ./build.sh
    )
  else
    echo "❕ Emscripten (emcc) not found; skipping WASM build."
    echo "   Tests may use a Dart fallback; to build locally, install Emscripten and re-run."
  fi
fi

# The parsec-web submodule is already in the correct location (parsec_web/lib/parsec-web/)
echo "📁 Verifying JavaScript wrapper exists..."
if [ -f "parsec_web/lib/parsec-web/js/equations_parser_wrapper.js" ]; then
  echo "✅ JavaScript wrapper found at: parsec_web/lib/parsec-web/js/equations_parser_wrapper.js"
else
  echo "❌ JavaScript wrapper missing at: parsec_web/lib/parsec-web/js/equations_parser_wrapper.js"
  exit 1
fi

echo "📁 Verifying WASM glue exists..."
if [ -f "parsec_web/lib/parsec-web/wasm/equations_parser.js" ]; then
  echo "✅ WASM glue found at: parsec_web/lib/parsec-web/wasm/equations_parser.js"
else
  echo "⚠️  WASM glue missing at: parsec_web/lib/parsec-web/wasm/equations_parser.js"
  echo "   Continuing without WASM; web tests may use fallback or skip WASM paths."
fi

echo
echo "✅ Setup complete!"
echo
echo "📋 Next steps:"
echo "1. Ensure your app's web/index.html includes:"
echo '   <script type="module" src="packages/parsec_web/parsec-web/js/equations_parser_wrapper.js"></script>'
echo '   <!-- WASM glue is loaded dynamically by the wrapper (../wasm/equations_parser.js). -->'
echo
echo "2. Run Flutter web: cd parsec/example && flutter run -d chrome"
echo
echo "🚀 WebAssembly is now bundled from the parsec_web package!"
