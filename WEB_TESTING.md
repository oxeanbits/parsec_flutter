# Web Testing Guide for Parsec Flutter

This document provides comprehensive guidance for testing the **parsec_flutter** plugin with **WebAssembly backend** integration.

## 🎯 Overview

The Web testing suite validates that all equation parsing functionality works correctly with the **parsec_web** WebAssembly implementation, ensuring true cross-platform compatibility.

### Key Testing Components

- **Real WebAssembly Integration**: Tests use actual C++ compiled to WASM, not mocks
- **BDD Structure**: Behavioral Driven Development test patterns following CLAUDE.md guidelines
- **Comprehensive Coverage**: All equation types, error handling, and performance validation
- **Automated CI/CD**: GitHub Actions workflows for continuous testing

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK**: >=3.19.0
- **Dart SDK**: >=3.3.0 <4.0.0
- **Chrome Browser**: For Web testing
- **Emscripten**: For WebAssembly compilation

### Running Tests

```bash
# Run all Web integration tests
cd parsec
flutter test --platform chrome

# Run specific Web integration test
flutter test --platform chrome test/parsec_web_integration_test.dart

# Run with coverage
flutter test --platform chrome --coverage
```

## 📋 Test Suite Structure

### Core Test Files

```
parsec/test/
├── parsec_test.dart                    # Main WebAssembly integration tests
├── parsec_web_integration_test.dart    # Detailed Web-specific tests
├── web_test_runner.dart                # Web test configuration runner
└── test_config.dart                    # Web environment setup
```

### Test Categories (BDD Structure)

#### 1. **Arithmetic Operations with WebAssembly Backend**
- **Basic Operations**: Addition, subtraction, multiplication, division
- **Order of Operations**: Precedence rules and parentheses
- **Power Operations**: Exponentiation (`^`) and `pow()` function
- **Mathematical Functions**: `abs()`, `sqrt()`, `cbrt()`, rounding
- **Min/Max Functions**: `min()`, `max()` operations
- **Constants**: `pi`, `e` mathematical constants

#### 2. **Trigonometric Functions with WebAssembly Backend**
- **Basic Trigonometry**: `sin()`, `cos()`, `tan()`
- **Inverse Functions**: `asin()`, `acos()`, `atan()`
- **Hyperbolic Functions**: `sinh()`, `cosh()`, `tanh()`

#### 3. **Logarithmic and Exponential Functions with WebAssembly Backend**
- **Natural Logarithm**: `ln()` function
- **Base Logarithms**: `log10()`, `log2()`
- **Exponential**: `exp()` function
- **Edge Cases**: Division by zero, negative arguments

#### 4. **String Functions with WebAssembly Backend**
- **String Literals**: Quoted string handling
- **Concatenation**: `concat()` function
- **Length Calculation**: `length()` function
- **Case Conversion**: `toupper()`, `tolower()`
- **Substring Operations**: `left()`, `right()`
- **Type Conversion**: `str2number()`, `string()`

#### 5. **Boolean and Comparison Operations with WebAssembly Backend**
- **Boolean Literals**: `true`, `false`
- **Comparison Operators**: `>`, `<`, `==`, `!=`
- **Logical Operators**: `&&`, `||`
- **Ternary Operator**: `condition ? value1 : value2`

#### 6. **Complex Expressions with WebAssembly Backend**
- **Multi-function Combinations**: Nested function calls
- **Mixed Type Operations**: Different return types in same expression

#### 7. **Error Handling with WebAssembly Backend**
- **Invalid Syntax**: Malformed expressions
- **Undefined Functions**: Unknown function names
- **Invalid Arguments**: Out-of-range parameters
- **Empty Input**: Empty or whitespace-only equations

#### 8. **WebAssembly-Specific Functionality**
- **Advanced Functions**: `fmod()`, `remainder()`, aggregations
- **Scientific Notation**: `1e2`, `2.5e-1` formats
- **Vector Operations**: `hypot()` function
- **Performance Validation**: Computational efficiency tests

## 🔧 Test Configuration

### Web Environment Setup

The `test_config.dart` file handles:
- Dynamic loading of parsec-web JavaScript library
- WebAssembly module initialization
- Global object availability verification
- Proper timing for WASM readiness

### BDD Test Structure Pattern

Following CLAUDE.md guidelines:

```dart
group('when evaluating [functionality] with WebAssembly backend', () {
  group('after setting up [specific scenario]', () {
    test('should [expected behavior]', () async {
      expect(await parsec.eval('expression'), expectedResult);
    });
  });
});
```

### Performance Testing

```dart
test('should handle computationally intensive calculations efficiently', () async {
  final startTime = DateTime.now();
  
  // Complex nested calculations
  final result1 = await parsec.eval('sqrt(pow(sin(pi/3), 2) + pow(cos(pi/3), 2))');
  final result2 = await parsec.eval('exp(ln(e * e))');
  final result3 = await parsec.eval('log10(pow(10, 3))');
  
  final endTime = DateTime.now();
  final duration = endTime.difference(startTime);
  
  // Verify results are correct (proving WebAssembly computation)
  expect(result1, closeTo(1, 0.0001));
  expect(result2, closeTo(7.389, 0.01));
  expect(result3, closeTo(3, 0.0001));
  
  // Performance assertion - WebAssembly should be fast
  expect(duration.inMilliseconds, lessThan(1000), 
        reason: 'WebAssembly should provide fast computation');
});
```

## 🤖 Automated Testing (CI/CD)

### GitHub Actions Workflow

The `.github/workflows/web_tests.yml` provides:

#### **Web Integration Tests**
- Multi-Flutter version testing (3.19.0, 3.24.0)
- WebAssembly module compilation
- Browser-based test execution
- Build validation

#### **Web Compatibility Tests**
- npm package validation
- JavaScript import testing (CommonJS/ES6)
- WebAssembly file integrity checks

#### **Performance Tests**
- WebAssembly benchmark execution
- Performance results archival

### Running CI Tests Locally

```bash
# Install dependencies
sudo apt-get install emscripten
npm install -g chrome-browser

# Setup Web assets
./setup_web_assets.sh

# Run full CI test suite
cd parsec_web/lib/parsec-web && npm test
cd ../../.. && cd parsec && flutter test --platform chrome
```

## 🧪 Advanced Testing Features

### Custom Test Matchers

```dart
// Floating-point precision matching
expect(result, closeTo(expectedValue, 0.0001));

// NaN/Infinity validation
expect(await parsec.eval('sqrt(-1)'), isNaN);
expect(await parsec.eval('5 / 0'), equals(double.infinity));

// Exception type validation
expect(() async => await parsec.eval('invalid++syntax'), 
       throwsA(isA<ParsecEvalException>()));
```

### WebAssembly Validation Tests

```dart
test('should verify WebAssembly backend is actually running', () {
  expect(ParsecPlatform.instance, isA<ParsecWebPlugin>());
  expect((ParsecPlatform.instance as ParsecWebPlugin).isInitialized, isTrue);
});
```

### Cross-Platform Verification

```dart
test('should produce identical results across platforms', () async {
  // These results should match native platform implementations
  expect(await parsec.eval('sin(pi/2)'), closeTo(1, 0.0001));
  expect(await parsec.eval('2^10'), equals(1024));
  expect(await parsec.eval('concat("Hello", " World")'), equals('Hello World'));
});
```

## 🐛 Debugging and Troubleshooting

### Common Issues

#### **WebAssembly Not Loading**
```bash
# Check that WASM files exist
ls -la parsec_web/lib/parsec-web/wasm/

# Verify build script execution
cd parsec_web/lib/parsec-web && ./build.sh
```

#### **JavaScript Library Not Found**
```dart
// Check global availability in browser console
console.log(window.Parsec); // Should not be undefined
```

#### **Test Timing Issues**
```dart
// Increase WebAssembly initialization delay
await Future.delayed(const Duration(milliseconds: 1000));
```

### Debugging Commands

```bash
# Run single test with verbose output
flutter test --platform chrome test/parsec_test.dart --reporter expanded

# Run with browser debugging
flutter test --platform chrome --pause-after-load

# Generate coverage report
flutter test --platform chrome --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📊 Performance Benchmarking

### WebAssembly vs JavaScript Performance

The test suite includes performance validation to ensure WebAssembly provides computational advantages:

```dart
group('after setting up WebAssembly performance validation', () {
  test('should outperform pure JavaScript implementations', () async {
    // Complex calculations that benefit from WebAssembly speed
    final complexExpressions = [
      'sqrt(pow(sin(pi/3), 2) + pow(cos(pi/3), 2))',
      'exp(ln(e * e))',
      'log10(pow(10, 3))',
      'abs(-sin(pi/6)) + cos(pi/4) * tan(pi/8)'
    ];
    
    final startTime = DateTime.now();
    for (final expr in complexExpressions) {
      await parsec.eval(expr);
    }
    final endTime = DateTime.now();
    
    expect(endTime.difference(startTime).inMilliseconds, lessThan(500),
           reason: 'WebAssembly should provide fast computation');
  });
});
```

## 🎯 Best Practices

### Test Organization

1. **Use BDD Structure**: Follow "when/after/should" pattern
2. **Group Related Tests**: Logical functionality groupings
3. **Descriptive Names**: Clear test intention description
4. **Setup/Teardown**: Proper test lifecycle management

### WebAssembly Testing

1. **Initialization Timing**: Allow sufficient WASM startup time
2. **Real Integration**: Always test actual WebAssembly, never mock
3. **Cross-Platform Consistency**: Verify identical results across platforms
4. **Performance Validation**: Include computational efficiency checks

### Error Handling

1. **Exception Types**: Use specific exception matchers
2. **Edge Cases**: Test boundary conditions
3. **Invalid Input**: Validate error responses
4. **Graceful Degradation**: Ensure proper fallback behavior

## 📈 Test Coverage Goals

- **Functionality Coverage**: 100% of equation parser features
- **Error Coverage**: All error conditions and edge cases
- **Platform Coverage**: WebAssembly-specific functionality
- **Performance Coverage**: Computational efficiency validation

## 🔗 Related Resources

- [Parsec Web Library Documentation](parsec_web/lib/parsec-web/README.md)
- [JavaScript Test Suite](parsec_web/lib/parsec-web/tests/)
- [WebAssembly Build Scripts](parsec_web/lib/parsec-web/build.sh)
- [GitHub Actions Workflows](.github/workflows/web_tests.yml)

---

This testing framework ensures **parsec_flutter** provides reliable, high-performance equation evaluation across all platforms, with the Web platform leveraging WebAssembly for optimal computational efficiency. 🚀