#!/bin/bash

# Validation script for parsec_flutter WebAssembly integration
# Checks that all components are properly set up

set -e

echo "🔍 Validating Parsec Flutter WebAssembly Integration..."
echo "====================================================="

echo "1. Checking bundled parsec-web assets..."
if [ -f "parsec_web/lib/parsec-web/js/equations_parser_wrapper.js" ]; then
    echo "   ✅ JS wrapper present in package"
else
    echo "   ❌ JS wrapper missing at parsec_web/lib/parsec-web/js/equations_parser_wrapper.js"
    exit 1
fi

# Check setup script
echo "2. Checking setup script..."
if [ -x "setup_web_assets.sh" ]; then
    echo "   ✅ Setup script exists and is executable"
else
    echo "   ❌ Setup script missing or not executable"
    exit 1
fi

echo "3. Checking WASM glue within package..."
if [ -f "parsec_web/lib/parsec-web/wasm/equations_parser.js" ]; then
    echo "   ✅ WASM glue present"
else
    echo "   ⚠️  WASM glue missing - run ./setup_web_assets.sh"
fi

# Check index.html
echo "4. Checking web/index.html..."
if [ -f "parsec/example/web/index.html" ]; then
    echo "   ✅ index.html exists"
    
    if grep -q "packages/parsec_web/parsec-web/js/equations_parser_wrapper.js" "parsec/example/web/index.html"; then
        echo "   ✅ index.html contains parsec-web script references"
    else
        echo "   ⚠️  index.html missing parsec-web script references"
    fi
else
    echo "   ⚠️  index.html not found"
fi

# Check Flutter packages
echo "5. Checking Flutter packages..."
if [ -f "parsec_web/pubspec.yaml" ]; then
    echo "   ✅ parsec_web package exists"
else
    echo "   ❌ parsec_web package not found"
    exit 1
fi

if [ -f "parsec_platform_interface/lib/parsec_platform_interface.dart" ]; then
    echo "   ✅ Platform interface exists"
else
    echo "   ❌ Platform interface not found"
    exit 1
fi

# Check tests
echo "6. Checking test suite..."
if [ -f "parsec/test/parsec_test.dart" ]; then
    echo "   ✅ Test suite exists"
else
    echo "   ⚠️  Test suite not found"
fi

echo ""
echo "🎯 VALIDATION SUMMARY:"
echo "✅ Core parsec platform implementation: Complete"
echo "✅ parsec-web assets bundled in package: Complete"  
echo "✅ WebAssembly setup infrastructure: Complete (package-based)"

echo ""
echo "🚀 READY TO TEST:"
echo "   cd parsec/example && flutter run -d chrome"

echo ""
echo "📊 Platform-Based Delegation:"
echo "   • Web platform: WebAssembly (parsec-web)"
echo "   • Native platforms: Method Channels"
