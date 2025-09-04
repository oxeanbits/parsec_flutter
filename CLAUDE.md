# CLAUDE.md - Parsec Flutter Plugin Guide

## Project Overview

**parsec_flutter** is a multi-platform Flutter plugin for evaluating mathematical equations using a C++ equations-parser library. The plugin features intelligent load balancing that routes equations to optimal evaluation methods based on platform capabilities and equation complexity.

### Supported Platforms
- ✅ Android (via C++ library)
- ✅ Linux (via C++ library) 
- ✅ Windows (via C++ library)
- ⚠️  Web (via WebAssembly - currently in development on `implement_parsec_web` branch)
- ❌ iOS (not yet implemented)
- ❌ macOS (not yet implemented)

## Repository Structure

```
parsec_flutter/
├── parsec/                          # Main plugin package
│   ├── lib/parsec.dart              # Smart load balancer with routing logic
│   ├── example/                     # Example app demonstrating usage
│   └── pubspec.yaml                 # Main package dependencies
├── parsec_platform_interface/       # Platform interface and routing logic
│   ├── lib/
│   │   ├── parsec_platform_interface.dart    # Main interface exports
│   │   ├── parsec_platform.dart              # Platform abstraction
│   │   ├── parsec_load_balancer.dart         # Smart routing logic
│   │   ├── parsec_backend_service.dart       # Backend API service
│   │   └── parsec_custom_function_detector.dart # Custom function detection
│   └── pubspec.yaml
├── parsec_android/                  # Android implementation (Method Channels)
├── parsec_linux/                   # Linux implementation (Method Channels)  
├── parsec_windows/                 # Windows implementation (Method Channels)
├── parsec_web/                     # Web implementation (WebAssembly) - IN DEVELOPMENT
└── .gitmodules                     # Git submodules for C++ equations-parser
```

## Architecture & Load Balancing

The plugin uses an intelligent **3-tier routing system**:

### 1. WebAssembly Route (`EvaluationRoute.webAssembly`)
- **Platform**: Web only
- **Condition**: No custom functions detected
- **Performance**: ~1ms (fastest)
- **Implementation**: `parsec_web/lib/parsec_web.dart`
- **Purpose**: Maximum performance for pure mathematical equations

### 2. Native Route (`EvaluationRoute.native`)  
- **Platform**: Android, Linux, Windows
- **Condition**: No custom functions detected
- **Performance**: ~5-10ms (very fast)
- **Implementation**: Method Channels to C++ equations-parser library
- **Purpose**: Native performance on mobile/desktop platforms

### 3. Backend Route (`EvaluationRoute.backend`)
- **Platform**: Any platform
- **Condition**: Custom functions detected (requires database access)
- **Performance**: ~110ms (slower due to network/database)
- **Implementation**: `parsec_backend_service.dart`
- **Purpose**: Complex functions requiring server-side database operations

### Smart Routing Logic
The routing decision is made in `parsec_platform_interface/lib/parsec_load_balancer.dart:69`:

```dart
// Analyze equation and route optimally
final decision = ParsecLoadBalancer.analyzeEquation(equation);
```

## Development Tools & Commands

### Environment
- **Flutter**: 3.27.4 (specified in `.tool-versions`)
- **Dart**: 3.6.2 (specified in `.tool-versions`)
- **SDK Requirements**: `>=3.3.0 <4.0.0`

### Testing
- **Framework**: `flutter_test` (built-in)
- **Run tests**: `flutter test` (from each package directory)
- **Test locations**: 
  - `parsec_android/test/`
  - `parsec_linux/test/`  
  - `parsec_windows/test/`

### Linting & Analysis
- **Configuration**: `analysis_options.yaml` in each package
- **Linter**: `flutter_lints ^2.0.1` (platform interface uses ^4.0.0)
- **Run analysis**: `flutter analyze`

### Build Commands
Since this is a Flutter plugin, standard Flutter commands apply:
- `flutter pub get` - Get dependencies
- `flutter build <platform>` - Build for specific platform
- `flutter run` - Run example app
- `flutter test` - Run tests

## Git Workflow

### Branches
- **main**: Production branch
- **implement_parsec_web**: Current development branch for Web support
- Various feature branches as needed

### Development Process
1. Create feature branch from `main`
2. Make changes following existing patterns
3. Test on relevant platforms
4. Create PR using the template in `.github/pull_request_template.md`
5. Merge after review

## Key Implementation Notes

### 1. Custom Function Detection
Custom functions are detected in `parsec_custom_function_detector.dart` and include:
- Database lookup functions (`xlookup`, `vlookup`)
- Changed/updated field functions (`changed`, `updated`) 
- Other functions requiring server-side data access

### 2. WebAssembly Integration (In Development)
- Uses `dart:js_interop` for JavaScript bridge
- Calls parsec-web JavaScript library wrapping WebAssembly
- Implementation: `parsec_web/lib/parsec_web.dart`

### 3. Method Channel Pattern
Native platforms use standard Flutter Method Channels:
```dart
@override
Future<dynamic> nativeEval(String equation) async {
  return await methodChannel.invokeMethod<String>('eval', equation);
}
```

### 4. Error Handling
Consistent error format across all platforms:
```json
{"val": "result_value", "type": "s|i|f|b", "error": null}
```

## Common Development Tasks

### Adding a New Platform
1. Create `parsec_<platform>/` directory
2. Implement `ParsecPlatform` interface
3. Add platform entry to main `parsec/pubspec.yaml`
4. Update README.md platform support table

### Adding Custom Functions
1. Update detection patterns in `parsec_custom_function_detector.dart`
2. Implement server-side support in backend service
3. Test routing logic ensures backend route is chosen

### Performance Optimization
- Monitor routing decisions via debug logs
- Use `ParsecLoadBalancer.getPerformanceAnalysis()` for metrics
- Profile WebAssembly vs native vs backend performance

### Testing New Features
1. Test pure math equations (should route to WebAssembly/native)
2. Test custom function equations (should route to backend)  
3. Verify error handling across all routes
4. Test on target platforms

## Debugging

### Enable Routing Debug Logs
The load balancer logs routing decisions:
```dart
print('🎯 Parsec Routing Decision: ${decision.reasoning}');
print('🚀 Routing to WebAssembly (parsec-web) for optimal performance');
```

### Platform Information
```dart
final info = parsec.getPlatformInfo();
print(info); // Shows platform capabilities and supported routes
```

### Performance Analysis
```dart
final analysis = parsec.getPerformanceAnalysis(EvaluationRoute.webAssembly);
print(analysis['estimatedTime']); // "~1ms"
```

## Dependencies & Versions

### Main Plugin (`parsec/pubspec.yaml`)
- `parsec_platform_interface: ^0.1.1`
- `parsec_android`: Local path dependency  
- `parsec_linux: ^0.3.1`
- `parsec_windows: ^0.1.0`
- `parsec_web`: Local path dependency (in development)

### Platform Interface (`parsec_platform_interface/pubspec.yaml`)
- `plugin_platform_interface: ^2.1.8`
- `flutter_lints: ^4.0.0`

### Web Implementation (`parsec_web/pubspec.yaml`)
- `js: ^0.7.1` 
- `web: ^1.0.0`
- Uses `dart:js_interop` for WebAssembly integration

## C++ Equations Parser

### Git Submodules
The native C++ library is included via git submodules:
- Android: `parsec_android/android/src/main/ext/equations-parser`  
- Linux: `parsec_linux/linux/ext/equations-parser`
- Windows: `parsec_windows/windows/ext/equations-parser` (uses `windows-version` branch)

### Submodule Management
- **Update**: `git submodule update --init --recursive`
- **Source**: https://github.com/niltonvasques/equations-parser

## Example Usage Patterns

### Basic Math (Routes to WebAssembly/Native)
```dart
final parsec = Parsec();
final result = await parsec.eval('5*5 + 5!'); // Routes to optimal platform
```

### Custom Functions (Routes to Backend)
```dart
final result = await parsec.eval('xlookup("id", "record.name", "=", "value", "MAX", "record.age")');
```

### Debug Routing
```dart
final decision = parsec.analyzeEquation('2 + sin(pi/2)');
print(decision.route); // EvaluationRoute.webAssembly (on web)
```

## Contributing Guidelines

1. **Follow existing patterns**: Study similar implementations before adding new features
2. **Test across platforms**: Ensure changes work on all supported platforms  
3. **Update documentation**: Keep README.md and this CLAUDE.md file updated
4. **Performance first**: Consider routing implications of new features
5. **Error handling**: Maintain consistent error format across platforms

This project demonstrates sophisticated plugin architecture with intelligent routing - perfect for learning Flutter platform integration patterns!

## Pull Request Guidance

When prompted with **"draft a pull request"**:

1. **Analyze changes**
   - Compare everything done on the current branch against `main`.
   - Summarize all relevant commits, file modifications, and key impacts.

2. **Create a Markdown draft**
   - Produce content that can be pasted directly into the PR **title** and **description** fields.
   - **Structure** the description with the template imported below: .github/pull_request_template.md
   - Enhance clarity with markdown code fences with language tags, colors, tables, blockquotes for callouts, admonitions (GitHub alerts), mermaid diagrams, images, collapsible details and etc.

3. **Write the Test Guidance section**
   - Assume the tester has minimal backend or API knowledge.
   - Describe step-by-step checks performed purely through the frontend—mouse clicks, typing, and other UI interactions.

4. **Generate a Markdown file**
   - Generate a `pull_request.md` file containing the Pull Request title and description
