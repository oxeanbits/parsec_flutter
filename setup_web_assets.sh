#!/bin/bash

# Setup script to make parsec-web available to Flutter web builds
# This script creates symbolic links from the parsec-web submodule files
# into the parsec_web package so Flutter web builds can load them directly from:
#   packages/parsec_web/parsec-web/js/equations_parser_wrapper.js
#   packages/parsec_web/parsec-web/wasm/equations_parser.js

set -e

echo "🔧 Setting up parsec-web assets via symbolic links..."
echo "===================================================="

# Check if parsec-web submodule exists
if [ ! -d "parsec-web" ]; then
  echo "❌ parsec-web submodule not found!"
  echo "   Please initialize the submodule first:"
  echo "   git submodule update --init --recursive"
  exit 1
fi

# Ensure WASM files are built in the submodule
if [ ! -f "parsec-web/wasm/equations_parser.js" ]; then
  echo "🔧 Building WebAssembly files in submodule..."
  cd parsec-web
  ./build.sh
  cd ..
fi

# Create package asset directories
mkdir -p parsec_web/lib/parsec-web/js/
mkdir -p parsec_web/lib/parsec-web/wasm/

echo "📁 Creating symbolic link to JavaScript wrapper from submodule..."
if [ -L "parsec_web/lib/parsec-web/js/equations_parser_wrapper.js" ]; then
  echo "✅ Symbolic link already exists: parsec_web/lib/parsec-web/js/equations_parser_wrapper.js"
else
  ln -sf ../../../../../parsec-web/js/equations_parser_wrapper.js parsec_web/lib/parsec-web/js/equations_parser_wrapper.js
  echo "✅ Created symbolic link: parsec_web/lib/parsec-web/js/equations_parser_wrapper.js → parsec-web/js/"
fi

echo "📁 Creating symbolic link to WASM glue from submodule..."
if [ -L "parsec_web/lib/parsec-web/wasm/equations_parser.js" ]; then
  echo "✅ Symbolic link already exists: parsec_web/lib/parsec-web/wasm/equations_parser.js"
else
  ln -sf ../../../../../parsec-web/wasm/equations_parser.js parsec_web/lib/parsec-web/wasm/equations_parser.js
  echo "✅ Created symbolic link: parsec_web/lib/parsec-web/wasm/equations_parser.js → parsec-web/wasm/"
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
