#!/bin/bash

# Validation script for parsec_flutter WebAssembly integration
# Checks that all components are properly set up

set -e

echo "🔍 Validating Parsec Flutter WebAssembly Integration..."
echo "====================================================="

# Check submodule
echo "1. Checking parsec-web submodule..."
if [ -d "parsec_web_lib" ]; then
    echo "   ✅ parsec_web_lib submodule exists"
    if [ -f "parsec_web_lib/js/equations_parser_wrapper.js" ]; then
        echo "   ✅ JavaScript wrapper found"
    else
        echo "   ❌ JavaScript wrapper not found"
        exit 1
    fi
else
    echo "   ❌ parsec_web_lib submodule not found"
    echo "   Run: git submodule update --init --recursive"
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

# Check web assets (if setup was run)
echo "3. Checking web assets..."
if [ -d "parsec/example/web/assets/parsec-web" ]; then
    echo "   ✅ Web assets directory exists"
    
    if [ -f "parsec/example/web/assets/parsec-web/js/equations_parser_wrapper.js" ]; then
        echo "   ✅ JavaScript wrapper copied"
    else
        echo "   ⚠️  JavaScript wrapper not copied - run ./setup_web_assets.sh"
    fi
    
    if [ -f "parsec/example/web/assets/parsec-web/wasm/math_functions.js" ]; then
        echo "   ✅ WebAssembly module found"
    else
        echo "   ⚠️  WebAssembly module not found - run ./setup_web_assets.sh"
    fi
else
    echo "   ⚠️  Web assets not set up - run ./setup_web_assets.sh"
fi

# Check index.html
echo "4. Checking web/index.html..."
if [ -f "parsec/example/web/index.html" ]; then
    echo "   ✅ index.html exists"
    
    if grep -q "parsec-web" "parsec/example/web/index.html"; then
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
echo "✅ parsec-web git submodule integration: Complete"  
echo "✅ WebAssembly setup infrastructure: Complete"

if [ -d "parsec/example/web/assets/parsec-web" ]; then
    echo "✅ Web assets ready: Yes"
    echo ""
    echo "🚀 READY TO TEST:"
    echo "   cd parsec/example && flutter run -d chrome"
else
    echo "⚠️  Web assets ready: No"
    echo ""
    echo "🔧 TO COMPLETE SETUP:"
    echo "   ./setup_web_assets.sh"
    echo "   cd parsec/example && flutter run -d chrome"
fi

echo ""
echo "📊 Platform-Based Delegation:"
echo "   • Web platform: WebAssembly (parsec-web)"
echo "   • Native platforms: Method Channels"