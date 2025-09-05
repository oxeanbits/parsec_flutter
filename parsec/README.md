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

For web platform support, you need to set up WebAssembly assets:

```bash
# Clone with submodules (if not already done)
git clone --recursive <your-repo-url>

# Or initialize submodules in existing repo
git submodule update --init --recursive

# Run setup script to prepare web assets
./setup_web_assets.sh
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

If you're testing the web platform for the first time, ensure WebAssembly assets are set up:

```bash
# From repository root
./setup_web_assets.sh
```

This copies the necessary WebAssembly files from the `parsec_web_lib` submodule to the Flutter web assets directory.

### Platform-Specific Implementation

- **Web**: Uses WebAssembly through the `parsec-web` JavaScript library for optimal performance
- **Android/Linux/Windows**: Uses Method Channels to communicate with native C++ implementations
- **iOS/macOS**: Not yet supported

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
# Ensure submodules are initialized
git submodule update --init --recursive

# Run the web setup script
./setup_web_assets.sh

# Verify assets were copied
ls parsec/example/web/assets/parsec-web/
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
# Run validation script to check setup
./validate_integration.sh

# Check individual components
flutter test parsec/
flutter test parsec_android/
flutter test parsec_linux/
flutter test parsec_windows/
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests: `flutter test`
5. Run validation: `./validate_integration.sh`
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## License

This project is licensed under the Apache-2.0 license - see the [LICENSE](LICENSE) file for details.
