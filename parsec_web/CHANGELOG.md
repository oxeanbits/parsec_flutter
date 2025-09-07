# Changelog

All notable changes to the **parsec_web** package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-12-07

### 🎉 Initial Release

The first stable release of **parsec_web** - a high-performance Web implementation of the parsec plugin using WebAssembly compiled from C++.

### ✨ Added

#### Core Features
- **WebAssembly Integration**: Native C++ equations-parser library compiled to WebAssembly for optimal performance
- **dart:js_interop Support**: Modern JavaScript interoperability using Flutter 3.19+ APIs
- **Cross-Platform Consistency**: Identical mathematical results across all Flutter platforms
- **Offline-First Architecture**: Self-contained WebAssembly module with no server dependencies

#### Mathematical Functions
- **Basic Arithmetic**: Addition, subtraction, multiplication, division with proper operator precedence
- **Advanced Math**: `abs()`, `sqrt()`, `cbrt()`, `pow()`, `exp()`, `round()`, `round_decimal()`
- **Trigonometric**: `sin()`, `cos()`, `tan()`, `asin()`, `acos()`, `atan()`, plus hyperbolic variants
- **Logarithmic**: `ln()`, `log()`, `log10()` with full precision
- **Constants**: Mathematical constants `pi` and `e` with high precision

#### String Operations
- **String Functions**: `concat()`, `length()`, `toupper()`, `tolower()`, `left()`, `right()`
- **Type Conversion**: `str2number()`, `string()`, `number()` with proper type handling
- **Advanced Features**: `contains()`, `link()`, `default_value()`, `calculate()`

#### Logical & Comparison
- **Comparison Operators**: `>`, `<`, `>=`, `<=`, `==`, `!=` for all data types
- **Logical Operations**: `and`, `or`, `&&`, `||` with short-circuit evaluation
- **Conditional Logic**: Ternary operator `condition ? true_value : false_value`
- **Boolean Literals**: Native `true`, `false`, and `null` support

#### Aggregation Functions
- **Statistical**: `min()`, `max()`, `sum()`, `avg()` with unlimited arguments
- **Array Support**: Proper handling of multiple values in single expressions

#### Development Tools
- **Dart Generation Command**: `dart bin/generate.dart` for WebAssembly compilation
- **Emscripten Integration**: Automated C++ to WASM compilation pipeline
- **Error Handling**: Comprehensive error messages and graceful failure modes
- **Development Workflow**: Integrated tooling for local development and testing

### 🏗️ Architecture

#### WebAssembly Pipeline
```
C++ Source (38 files) → Emscripten → WebAssembly → JavaScript Wrapper → Flutter Web
```

#### Performance Optimizations
- **Single File Distribution**: WASM binary embedded in JavaScript (~635KB)
- **Compile-Time Optimization**: Built with `-O3` for maximum performance
- **Memory Management**: Dynamic memory growth with efficient allocation
- **Browser Compatibility**: Optimized for all modern web browsers

### 🧪 Testing

#### Comprehensive Test Suite
- **95+ JavaScript Tests**: Full WebAssembly functionality validation using Vitest
- **Integration Tests**: Flutter web integration with Chrome automation
- **Cross-Platform Tests**: Consistency verification across all parsec implementations
- **Performance Benchmarks**: WebAssembly vs native performance comparisons

#### Test Categories
- **Arithmetic Tests**: Basic math operations and operator precedence
- **Function Tests**: All mathematical, trigonometric, and string functions
- **Boolean Tests**: Logical operations and comparison operators
- **Error Handling**: Invalid input and edge case management
- **API Tests**: Batch evaluation, timeout handling, and comprehensive validation

### 📋 Requirements

#### Runtime Requirements
- **Flutter SDK**: >=3.19.0 (for modern `dart:js_interop` support)
- **Dart SDK**: >=3.3.0 <4.0.0
- **Web Browser**: Any modern browser with WebAssembly support

#### Development Requirements
- **Emscripten**: For compiling C++ to WebAssembly (optional for end users)
- **Node.js**: For running JavaScript tests (development only)

### 🔧 Technical Specifications

#### Dependencies
- `flutter: sdk` - Flutter framework integration
- `flutter_web_plugins: sdk` - Web plugin infrastructure
- `js: ^0.7.1` - JavaScript interoperability (transitional)
- `web: ^0.5.1` - Modern web APIs
- `parsec_platform_interface: ^0.2.0` - Common plugin interface

#### Platform Integration
- **Plugin Type**: Federated Flutter plugin with web implementation
- **Registration**: Automatic platform detection and registration
- **Method Channels**: Bridged through JavaScript interop layer
- **JSON Protocol**: Standardized `{"val": "result", "type": "i|f|b|s", "error": null}` format

### 📚 Documentation

#### Comprehensive Guides
- **README.md**: Complete usage guide with examples and troubleshooting
- **API Documentation**: Full function reference with type information  
- **Development Guide**: WASM compilation and testing instructions
- **Integration Examples**: Flutter web setup and configuration

#### Code Examples
- **Basic Usage**: Simple mathematical expressions
- **Advanced Features**: Complex functions and string operations
- **Error Handling**: Proper exception management
- **Performance Tips**: Best practices for optimal performance

### 🚀 Performance Benchmarks

#### Typical Performance
- **Simple Operations**: 1-5ms execution time
- **Complex Expressions**: 5-10ms execution time  
- **String Operations**: 2-8ms execution time
- **WebAssembly Loading**: One-time ~100ms initialization

#### Comparison with Native Platforms
- **Consistency**: Identical mathematical precision across platforms
- **Speed**: Competitive with native C++ implementations
- **Memory**: Efficient memory usage with automatic garbage collection

---

## [Unreleased]

### 🔄 Planned Features

#### Enhanced WebAssembly Support
- **Multi-threading**: Web Workers integration for parallel computation
- **Streaming Compilation**: Progressive WASM loading for faster startup
- **Memory Optimization**: Advanced memory management techniques

#### Extended Mathematical Functions
- **Matrix Operations**: Linear algebra support with `eye()`, `ones()`, `zeros()`
- **Complex Numbers**: Full complex number arithmetic with `real()`, `imag()`, `conj()`
- **Date Functions**: `current_date()`, `daysdiff()`, `hoursdiff()` implementations

#### Developer Experience
- **Hot Reload**: Faster development iteration with WASM hot reload
- **Debug Mode**: Enhanced error reporting and performance profiling
- **Source Maps**: Better debugging experience with source map support

---

## Migration Guide

### From Shell Scripts to Dart Command

If you were previously using shell scripts for WASM generation:

#### ❌ Old Approach
```bash
./setup_web_assets.sh
cd parsec-web && ./build.sh
```

#### ✅ New Approach  
```bash
cd parsec_web
dart bin/generate.dart
```

### Benefits of Migration
- **Cross-Platform**: Works on all operating systems
- **Better Error Handling**: Clear error messages and troubleshooting
- **Flutter Integration**: Native Flutter development workflow
- **Automatic Detection**: Checks prerequisites and provides guidance

---

## Support

### 🐛 Issues & Bug Reports
- **GitHub Issues**: [Report bugs and request features](https://github.com/your-repo/parsec_flutter/issues)
- **Discussions**: [Community support and questions](https://github.com/your-repo/parsec_flutter/discussions)

### 📖 Documentation
- **Package Documentation**: [pub.dev/packages/parsec_web](https://pub.dev/packages/parsec_web)
- **API Reference**: [Complete function documentation](https://pub.dev/documentation/parsec_web/)
- **Flutter Plugin Guide**: [Official Flutter documentation](https://flutter.dev/docs/development/packages-and-plugins)

### 🤝 Contributing
We welcome contributions! Please see our [Contributing Guide](../CONTRIBUTING.md) for details on:
- Code style and standards
- Testing requirements  
- Pull request process
- Development setup

---

*This changelog follows the [Keep a Changelog](https://keepachangelog.com/) format and [Semantic Versioning](https://semver.org/) principles.*