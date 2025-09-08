# parsec [![package publisher](https://img.shields.io/pub/publisher/parsec.svg)](https://pub.dev/packages/parsec/publisher) [![pub package](https://img.shields.io/pub/v/parsec.svg)](https://pub.dev/packages/parsec)

The multi-platform `parsec` plugin for Flutter to calculate math equations using C++ library on native platforms and WebAssembly on web.

## Platform Support

| Android | iOS | Windows | Linux | MacOS | Web |
| :-----: | :-: | :-----: | :---: | :---: | :-: |
|   ✔️    | ❌️ |   ✔️    |  ✔️   |  ❌️  | ✔️  |

## Installation

Add `parsec` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  parsec: ^0.3.1  # Use latest version
```

Then run:

```bash
flutter pub get
```

### Web Platform Setup (Additional Step)

For web platform support, include the parsec-web wrapper JS in your app's `web/index.html`:

```html
<script type="module" src="packages/parsec_web/parsec-web/js/equations_parser_wrapper.js"></script>
```

The wrapper dynamically imports the WASM glue from `packages/parsec_web/parsec-web/wasm/equations_parser.js`.
If the WASM glue is missing during local development, run:

```bash
cd parsec_web
dart bin/generate.dart
```

## Requirements

| Platform | Requirements |
|----------|-------------|
| **Android** | Android SDK, NDK |
| **Linux** | GCC/Clang compiler |
| **Windows** | Visual Studio Build Tools |
| **Web** | Modern browser with WebAssembly support |

## Usage

### Example

```dart
import 'package:parsec/parsec.dart';

void main() {
    final Parsec parsec = Parsec();
    dynamic result;

    try {
        result = await parsec.eval('5*5 + 5!');
    } catch (e) {
        result = e.toString();
    }
}
```

### Here are examples of equations which are accepted by the parsec

```dart
final Parsec parsec = Parsec();

# Simple Math equations
parsec.eval('(5 + 1) + (6 - 2)')  # result => 10
parsec.eval('4 + 4 * 3')          # result => 16
parsec.eval('10.5 / 5.25')        # result => 2
parsec.eval('abs(-5)')            # result => 5
parsec.eval('sqrt(16) + cbrt(8)') # result => 6
parsec.eval('log10(10)')          # result => 1
parsec.eval('round(4.4)')         # result => 4
parsec.eval('(3^3)^2')            # result => 729
parsec.eval('3^(3^(2))')          # result => 19683
parsec.eval('10!')                # result => 3628800
parsec.eval('string(10)')         # result => "10"

# Complex Math equations
parsec.eval('log10(10) + ln(e) + log(10)')       # result => 4.30259
parsec.eval('sin(1) + cos(0) + tan(0.15722)')    # result => 2.0
parsec.eval('max(1, 2) + min(3, 4) + sum(5, 6)') # result => 16
parsec.eval('avg(9, 9.8, 10)')                   # result => 9.6
parsec.eval('pow(2, 3)')                         # result => 8
parsec.eval('round_decimal(4.559, 2)')           # result => 4.56

# IF THEN ELSE equations
parsec.eval('4 > 2 ? "bigger" : "smaller"')    # result => "bigger"
parsec.eval('2 == 2 ? true : false')           # result => true
parsec.eval('2 != 2 ? true : false')           # result => false
parsec.eval('"this" == "this" ? "yes" : "no"') # result => "yes"
parsec.eval('"this" != "that" ? "yes" : "no"') # result => "yes"

# Logic equations
parsec.eval('true and false')    # result => false
parsec.eval('true or false')     # result => true
parsec.eval('(3==3) and (3!=3)') # result => false
parsec.eval('exp(1) == e')       # result => true

# String equations
parsec.eval('length("test string")')     # result => 11
parsec.eval('toupper("test string")')    # result => "TEST STRING"
parsec.eval('tolower("TEST STRING")')    # result => "test string"
parsec.eval('concat("Hello ", "World")') # result => "Hello World"
parsec.eval('link("Title", "http://foo.bar")') # result => "<a href="http://foo.bar">Title</a>"
parsec.eval('str2number("5")')           # result => 5
parsec.eval('left("Hello World", 5)')    # result => "Hello"
parsec.eval('right("Hello World", 5)')   # result => "World"
parsec.eval('number("5")')               # result => 5

# Date equations (return the difference in days)
parsec.eval("current_date()"))                        # result => "2018-10-03"
parsec.eval('daysdiff(current_date(), "2018-10-04")') # result => 1
parsec.eval('daysdiff("2018-01-01", "2018-12-31")')   # result => 364

# DateTime equations (return the difference in hours)
parsec.eval('hoursdiff("2018-01-01", "2018-01-02")')             # result => 24
parsec.eval('hoursdiff("2019-02-01T08:00", "2019-02-01T12:00")') # result => 4
parsec.eval('hoursdiff("2019-02-01T08:20", "2019-02-01T12:00")') # result => 3.67
parsec.eval('hoursdiff("2018-01-01", "2018-01-01")')             # result => 0
```

### The following functions can be used

- Math trigonometric functions: **sin**, **cos**, **tan**, **sinh**, **cosh**, **tanh**, **asin**, **acos**, **atan**, **asinh**, **acosh**, **atanh**
- Math logarithm functions: **ln**, **log**, **log10**
- Math standard functions: **abs**, **sqrt**, **cbrt**, **pow**, **exp**, **round**, **round_decimal**
- Number functions: **string**
- Math constants: **e**, **pi**
- Unlimited number of arguments: **min**, **max**, **sum**, **avg**
- String functions: **concat**, **length**, **toupper**, **tolower**, **left**, **right**, **str2number**, **number**, **link**
- Complex functions: **real**, **imag**, **conj**, **arg**, **norm**
- Array functions: **sizeof**, **eye**, **ones**, **zeros**
- Date functions: **current_date**, **daysdiff**, **hoursdiff**
- Extra functions: **default_value**

## Testing

### Running Automated Tests

#### Main Package Tests
```bash
cd parsec
flutter test
```

#### Platform-Specific Tests
```bash
# Android implementation
cd parsec_android
flutter test

# Linux implementation  
cd parsec_linux
flutter test

# Windows implementation
cd parsec_windows
flutter test
```

#### Integration Validation
```bash
# From repository root
./validate_integration.sh
```

### Manual Testing

#### Web Platform (WebAssembly)
```bash
cd parsec/example
flutter run -d chrome
```

#### Native Platforms
```bash
cd parsec/example

# Linux
flutter run -d linux

# Android (with device connected)
flutter run -d android

# Windows (on Windows machine)  
flutter run -d windows
```

### Web Setup (First Time Only)

If you're testing the web platform for the first time, ensure the WASM files are generated:

```bash
cd parsec_web
dart bin/generate.dart
```

This builds the necessary WebAssembly files in the `parsec_web` package so they can be served from `packages/parsec_web/parsec-web/...`.

### Platform-Specific Implementation

- **Web**: Uses WebAssembly through the `parsec-web` JavaScript library for optimal performance
  - Utilizes `evalRaw()` function for direct C++ JSON output, ensuring platform consistency
  - Bypasses JavaScript type conversion for cleaner data flow: C++ → JSON → Dart
- **Android/Linux/Windows**: Uses Method Channels to communicate with native C++ implementations
- **iOS/macOS**: Not yet supported

### Technical Implementation Details

#### Web Platform Architecture

The web implementation has been optimized for performance and consistency:

```
Flutter Dart Code
       ↓
parsec_web Platform Channel
       ↓
JavaScript evalRaw() Function
       ↓
WebAssembly (C++ equations-parser)
       ↓
Raw JSON Response
```

**Key Features:**
- **Direct JSON Flow**: Uses `evalRaw()` to get raw C++ JSON output without JavaScript type conversion
- **Platform Consistency**: All platforms now receive identical JSON format from C++ 
- **Simplified Architecture**: Eliminated complex type normalization and conversion layers
- **Better Performance**: Direct data path reduces processing overhead
- **KISS Principle**: Much cleaner codebase with 150+ lines of complex code removed

## Performance

| Platform | Implementation | Typical Performance | Network Required |
|----------|---------------|-------------------|------------------|
| **Web** | WebAssembly | ~1-10ms | No (offline) |
| **Android** | Method Channels + C++ | ~5-20ms | No (offline) |
| **Linux** | Method Channels + C++ | ~5-20ms | No (offline) |
| **Windows** | Method Channels + C++ | ~5-20ms | No (offline) |

### Expected Behavior

The same equation should produce identical results across all supported platforms:

```dart
final parsec = Parsec();
final result = await parsec.eval('2 + 3 * sin(pi/2)'); // Should return 5.0 on all platforms
```

## Troubleshooting

### Web Platform Issues

#### "parsec-web JavaScript library not found"
```bash
# Ensure your app's web/index.html includes the wrapper:
# <script type="module" src="packages/parsec_web/parsec-web/js/equations_parser_wrapper.js"></script>

# Generate WASM files to ensure they are present
cd parsec_web
dart bin/generate.dart

# Verify bundled assets
ls parsec_web/lib/parsec-web/{js,wasm}/
```

#### WebAssembly module fails to load
- Ensure your browser supports WebAssembly (all modern browsers do)
- Check browser console for detailed error messages
- Try hard refresh (Ctrl+Shift+R) to clear cache

### Native Platform Issues

#### Build errors on Android
```bash
# Ensure NDK is installed
flutter doctor

# Clean and rebuild
flutter clean
flutter pub get
flutter build android
```

#### Build errors on Linux/Windows
```bash
# Ensure proper build tools are installed
flutter doctor

# Verify platform is enabled
flutter create --platforms=linux,windows .
```

#### Tests failing
```bash
# Generate WASM files first for web platform
cd parsec_web && dart bin/generate.dart

# Check individual components
flutter test parsec/
flutter test parsec_android/
flutter test parsec_linux/
flutter test parsec_windows/
flutter test --platform chrome parsec/  # Web-specific tests
```

## Web Testing (WebAssembly Integration)

The Web platform uses **real WebAssembly** compiled from the same C++ equations-parser library used by native platforms, ensuring true cross-platform consistency.

### Running Web Tests

```bash
# Run all Web integration tests
cd parsec
flutter test --platform chrome

# Run specific Web integration tests
flutter test --platform chrome test/parsec_web_integration_test.dart

# Run with coverage
flutter test --platform chrome --coverage
```

### Automated Testing

GitHub Actions automatically runs comprehensive Web tests:

- **Multi-Flutter Versions**: Tests against Flutter 3.19.0 and 3.24.0  
- **Browser Testing**: Chrome-based automated testing
- **Performance Benchmarks**: WebAssembly efficiency validation
- **Cross-Platform Consistency**: Identical results across all platforms

See [WEB_TESTING.md](WEB_TESTING.md) for detailed testing documentation.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Generate WASM files for web: `cd parsec_web && dart bin/generate.dart`
5. Run tests: `flutter test`
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## License

This project is licensed under the Apache-2.0 license - see the [LICENSE](LICENSE) file for details.
