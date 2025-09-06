#!/bin/bash

# Setup script to make parsec-web available to Flutter web builds
# This script syncs the JS wrapper and WASM glue into the parsec_web package
# so Flutter web builds can load them directly from:
#   packages/parsec_web/parsec-web/js/equations_parser_wrapper.js
#   packages/parsec_web/parsec-web/wasm/equations_parser.js

set -e

echo "🔧 Setting up parsec-web assets inside parsec_web package..."
echo "==========================================================="

# Create package asset directories
mkdir -p parsec_web/lib/parsec-web/js/
mkdir -p parsec_web/lib/parsec-web/wasm/

echo "📁 Ensuring JavaScript wrapper exists in package..."
if [ -f "parsec_web/lib/parsec-web/js/equations_parser_wrapper.js" ]; then
  echo "✅ Wrapper present at parsec_web/lib/parsec-web/js/equations_parser_wrapper.js"
else
  echo "❌ Wrapper missing at parsec_web/lib/parsec-web/js/equations_parser_wrapper.js"
  echo "   This file should be committed to the repository."
  exit 1
fi

echo "📁 Ensuring WASM glue (equations_parser.js) is available..."
if [ -n "$WASM_SOURCE" ]; then
  if [ -f "$WASM_SOURCE" ]; then
    cp "$WASM_SOURCE" parsec_web/lib/parsec-web/wasm/equations_parser.js
    echo "✅ Copied from WASM_SOURCE to parsec_web/lib/parsec-web/wasm/equations_parser.js"
  else
    echo "❌ WASM_SOURCE path does not exist: $WASM_SOURCE"
    exit 1
  fi
elif [ -f "parsec_web/lib/parsec-web/wasm/equations_parser.js" ]; then
  echo "✅ WASM glue already present: parsec_web/lib/parsec-web/wasm/equations_parser.js"
else
  echo "❌ WASM glue missing. Provide it via environment variable WASM_SOURCE, e.g.:"
  echo "   WASM_SOURCE=/path/to/equations_parser.js ./setup_web_assets.sh"
  exit 1
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
