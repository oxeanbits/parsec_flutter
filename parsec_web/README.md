# parsec_web

Web implementation of the [`parsec`](../parsec) plugin using WebAssembly for high-performance mathematical equation evaluation.

> [!NOTE]
> This is an [endorsed](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#endorsed-federated-plugin) federated plugin. Use `parsec` normally - this package is automatically included for web platforms.

## Installation

Add `parsec` to your `pubspec.yaml`:

```yaml
dependencies:
  parsec: ^0.3.1
```

**Web Setup Required**: Include the JavaScript wrapper in your `web/index.html`:

```html
<script type="module" src="packages/parsec_web/parsec-web/js/equations_parser_wrapper.js"></script>
```

## Usage

```dart
import 'package:parsec/parsec.dart';

final parsec = Parsec();
final result = await parsec.eval('sqrt(16) + pow(2,3)'); // 12.0
```

## Development

### Generate WebAssembly files

```bash
cd parsec_web
dart bin/generate.dart
```

Requires Emscripten:
```bash
# Ubuntu/Debian
sudo apt-get install emscripten

# Or via emsdk
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk && ./emsdk install latest && ./emsdk activate latest
source ./emsdk_env.sh
```

### Testing

```bash
# JavaScript tests
cd parsec_web/lib/parsec-web && npm test

# Flutter web tests  
cd parsec && flutter test --platform chrome
```

## Architecture

- **Flutter App** → **parsec_web** → **dart:js_interop** → **WebAssembly** → **C++ equations-parser**
- Same API and results as other platforms
- Offline-first, no network dependencies
- ~635KB WebAssembly module with 100+ math functions

For detailed documentation, see the main [`parsec`](../parsec) package.
