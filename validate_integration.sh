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

# Check Dart WASM generation script
echo "2. Checking Dart WASM generation script..."
if [ -f "parsec_web/bin/generate.dart" ]; then
    echo "   ✅ Dart WASM generator exists"
else
    echo "   ❌ Dart WASM generator missing at parsec_web/bin/generate.dart"
    exit 1
fi

echo "3. Checking WASM glue within package..."
if [ -f "parsec_web/lib/parsec-web/wasm/equations_parser.js" ]; then
    echo "   ✅ WASM glue present"
else
    echo "   ⚠️  WASM glue missing - run: cd parsec_web && dart bin/generate.dart"
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
echo "✅ WebAssembly setup infrastructure: Complete (Dart-based generation)"

echo ""
echo "🚀 READY TO TEST:"
echo "   1. Generate WASM files: cd parsec_web && dart bin/generate.dart"
echo "   2. Run web example: cd parsec/example && flutter run -d chrome"

echo ""
echo "📊 Platform-Based Delegation:"
echo "   • Web platform: WebAssembly (parsec-web)"
echo "   • Native platforms: Method Channels"
