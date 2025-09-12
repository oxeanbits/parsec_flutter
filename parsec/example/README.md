# parsec_example

Demonstrates how to use the parsec plugin.

## Getting Started

### Native Platforms

```sh
flutter run -d linux
flutter run -d android
flutter run -d windows  # On Windows
```

### Web Platform

First, generate the WebAssembly files:

```sh
cd ../parsec_web
dart bin/generate.dart
cd ../example
```

Then run the web version:

```sh
flutter run -d chrome
```

