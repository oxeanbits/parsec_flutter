This is a Flutter plugin monorepo for the `parsec` math equation parser library that provides cross-platform native C++ math evaluation capabilities.

## Project Structure

This repository follows a federated Flutter plugin architecture:

- **parsec/**: Main plugin package that depends on platform implementations
- **parsec_platform_interface/**: Common interface for all platform implementations  
- **parsec_android/**: Android platform implementation using JNI
- **parsec_linux/**: Linux platform implementation using FFI
- **parsec_windows/**: Windows platform implementation using FFI  
- **parsec_web/**: Web/JavaScript implementation (separate library)

## Development Environment

- **Flutter SDK**: >=3.19.0
- **Dart SDK**: >=3.3.0 <4.0.0
- **Linting**: Uses `flutter_lints ^4.0.0` for all packages
- **Testing**: Standard Flutter test framework with platform-specific mocking

## Key Commands

### Web Asset Generation
```bash
# Generate WebAssembly files for parsec_web (required for web platform)
cd parsec_web && dart bin/generate.dart
```

### Testing
```bash
# Test all packages from their respective directories
cd parsec && flutter test
cd parsec_android && flutter test  
cd parsec_linux && flutter test
cd parsec_windows && flutter test
cd parsec_platform_interface && flutter test

# Web platform testing (requires WASM files)
cd parsec && flutter test --platform chrome
```

### Linting & Analysis
```bash
# Run analysis on each package
cd parsec && flutter analyze
cd parsec_android && flutter analyze
cd parsec_linux && flutter analyze  
cd parsec_windows && flutter analyze
cd parsec_platform_interface && flutter analyze
```

### Building Example
```bash
cd parsec/example
flutter build [linux|windows|apk]
```

## Development Standards

### Clean Code Techniques

Always apply these core principles when working with this codebase:

1. **DRY (Don't Repeat Yourself)**: If code is identical or very similar, extract it into a generalized function. Parameters are your friends.

2. **KISS (Keep It Simple Stupid)**: Make code so "stupid" that a 5-year-old could understand it.

3. **SRP (Single Responsibility Principle)**: Separate code into simple, well-defined, well-intentioned tasks with clear names. Prevents "spaghetti code".

4. **Avoid Hadouken IFs**: Avoid nested IFs → Solution: Early Returns and/or Switch-Cases.

5. **Avoid Negative Conditionals**: Positive conditionals reduce mental strain and make code easier to reason about.

6. **Encapsulate Conditionals**: For conditions with 3+ comparisons, extract into functions that convey the intent. Create names that reveal the conditional's purpose.

7. **Avoid Flag Arguments**: Avoid boolean arguments (true/false) to functions. Use descriptive strings or enums instead.

8. **Avoid Comments**: Code should be self-documenting with intention-revealing names. If comments are necessary, explain the "why" not the "what". Use SRP and intention-revealing names as your primary tools.

9. **Good Nomenclatures**: Use descriptive variable names that reveal intent. Use pronounceable and searchable names. Follow language, business, and team conventions.

10. **Use Vertical Formatting**: Code should read top to bottom without "jumping". Similar and dependent functions should be vertically close.

11. **Boy Scout Rule**: Always leave the codebase cleaner than you found it. Improve Clean Code whenever you touch existing code.

### Testing Guidelines

When working with this project, AI agents just execute tests from changed files

**Philosophy**: User-centric testing principles ensure all tests are meaningful from the user's perspective.

**Structure**: Tests must prioritize clarity, consistency, and maintainability. Write tests for people to read, not machines to execute.

**Real-world Testing**: Favor real-world interactions over mocks/stubs. Avoid mocks and stubs wherever possible.

#### BDD Structure Pattern

- **`describe()` blocks**: Describe scenarios using subordinating conjunctions
  - Pattern: Start with "when", "after", "while", "with"
  - Examples:
    - "when filtering by different column types"
    - "after the database is populated"
    - "with multiple conditions"

- **`before()`/`before(:all)`**: Prepare scenarios for testing
  - Setup database schema, create items, configure environment
  - Declare important `@variables` for testing
  - Execute operations and prerequisites

- **`it()` blocks**: Test specific outcomes and assertions
  - Pattern: Start with "should"
  - Examples:
    - "should find exact string matches"
    - "should be case sensitive"
    - "should create and associate items correctly"

## Code Patterns & Conventions

### Architecture Pattern
- Uses the **Platform Interface pattern** with `plugin_platform_interface`
- Each platform implementation extends `ParsecPlatform` abstract class
- Method channel communication with native C++ libraries
- JSON-based result parsing with type safety

### Naming Conventions
- **Package names**: Snake_case with `parsec_` prefix
- **Classes**: PascalCase (e.g., `ParsecLinux`, `ParsecAndroid`)
- **Methods**: camelCase (e.g., `nativeEval`, `parseNativeEvalResult`)
- **Constants**: UPPER_SNAKE_CASE

### Error Handling
- Custom exception: `ParsecEvalException` for math evaluation errors
- JSON response format: `{"val": "result", "type": "i|f|b|s", "error": null}`
- Platform-specific error propagation through method channels

### Testing Patterns  
- Mock `MethodChannel` for platform implementations
- Test registration of platform instances
- Focus on interface compliance rather than native C++ logic

## File Organization

### Core Plugin (`parsec/`)
- `lib/parsec.dart`: Main API class with simple `eval(String)` method
- Depends on platform interface, no direct platform dependencies

### Platform Interface (`parsec_platform_interface/`)
- `lib/parsec_platform.dart`: Abstract base class for all platforms
- `lib/parsec_eval_exception.dart`: Custom exception types
- `lib/method_channel_parsec.dart`: Default method channel implementation

### Platform Implementations
Each follows identical structure:
```
lib/
  parsec_{platform}.dart     # Main platform class
test/
  parsec_{platform}_test.dart # Registration tests
pubspec.yaml                 # Platform-specific dependencies
```

## Dependencies & Versioning

- **Platform Interface Version**: Currently ^0.2.0 across all implementations
- **Flutter Lints**: ^4.0.0 (latest) for strict code quality
- **Plugin Platform Interface**: ^2.1.8 for base platform functionality

## Native Integration Points

- **Android**: JNI bridge to C++ equations-parser library
- **Linux**: FFI integration with compiled C++ library  
- **Windows**: FFI integration with compiled C++ library
- **Method Channels**: Standard Flutter communication pattern

## Important Development Notes

- This is a **federated plugin** - changes to platform interface affect all implementations
- Native libraries are **pre-built** and included in platform packages
- Local path dependencies are used for development (see pubspec.yaml files)
- No iOS/macOS/Web support in main plugin (separate web library exists)

## Web Platform Development

The **parsec_web** package uses WebAssembly compiled from C++ for high performance:

### Prerequisites
- **Emscripten**: Required to compile C++ to WebAssembly
  ```bash
  # Ubuntu/Debian
  sudo apt-get install emscripten
  
  # Or install via emsdk
  git clone https://github.com/emscripten-core/emsdk.git
  cd emsdk && ./emsdk install latest && ./emsdk activate latest
  source ./emsdk_env.sh
  ```

### Development Workflow
1. **Generate WASM files**: `cd parsec_web && dart bin/generate.dart`
2. **Test functionality**: `cd parsec_web/lib/parsec-web && npm test`
3. **Integration testing**: `cd parsec && flutter test --platform chrome`

### What `dart bin/generate.dart` does:
- Validates parsec-web submodule exists
- Compiles C++ equations-parser (38 source files) to WebAssembly using Emscripten
- Generates `wasm/equations_parser.js` (WASM glue + binary, ~635KB)
- Verifies JavaScript wrapper and WASM files are present
- Provides user-friendly output and next steps

## When Working on This Codebase

1. **Generate WASM first** - run `cd parsec_web && dart bin/generate.dart` before web testing
2. **Always test across platforms** - changes to interface affect all implementations
3. **Maintain version consistency** - keep platform interface versions aligned
4. **Follow Flutter plugin conventions** - use established patterns for method channels
5. **Preserve JSON contract** - native libraries expect specific response format
6. **Update documentation** - especially README.md examples if API changes
7. **Run analysis** - ensure all packages pass `flutter analyze` before commits

## Pull Request Guidance

ONLY When prompted with **"draft a pull request"**:

1. **Analyze changes**
   * Compare everything done on the current branch against `master`/`main` branch of `upstream`.
   * Summarize all relevant commits, file modifications, and key impacts.

2. **Create a Markdown draft**
   * Produce content that can be pasted directly into the PR **title** and **description** fields.
   * **Structure** the description with the template imported below: .github/pull_request_template.md
   * Enhance clarity with markdown code fences with language tags, colors, tables, blockquotes for callouts, admonitions (GitHub alerts), mermaid diagrams, images, collapsible details and etc.

3. **Write the Test Guidance section**
   * Assume a tester is going to test the changes proposed on this pull request.
   * Describe step-by-step checks needs to be performed to carefully test it.

4. **Generate a Markdown file**
   * Generate a `pull_request.md` file containing the Pull Request title and description
