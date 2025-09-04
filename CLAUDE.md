# CLAUDE.md - Parsec Web Development Guide

## 🎯 Project Vision

**Parsec Web** is a generalized JavaScript library that connects to the equations-parser WebAssembly module (C++ code compiled to WASM) for high-performance, cross-platform equation evaluation.

### Core Purpose

- **Generalization**: Make the library reusable across different JavaScript environments
- **Cross-Platform**: Support frontend projects, Flutter web, Node.js applications
- **Performance**: Leverage WebAssembly for fast, client-side equation processing
- **Offline-First**: No server dependency, completely self-contained

## 🏗️ Architecture Overview

```
JavaScript Applications
       ↓
Parsec Web Library (js/equations_parser_wrapper.js)
       ↓
WebAssembly Module (wasm/equations_parser.js/.wasm)
       ↓
C++ equations-parser Library
```

### Target Platforms

1. **Frontend Projects**: React, Vue, Angular, vanilla JavaScript
2. **Flutter Web**: Via dart:js_interop integration
3. **Node.js Applications**: As importable npm package
4. **Cross-Platform Solutions**: Any JavaScript environment

## 🧪 Testing Framework

The project uses **Vitest** as the primary testing framework for comprehensive equation evaluation testing.

### Test Implementation Strategy

**Test Categories:**

- **Unit Tests** (8 modules): `tests/unit/`
  - `arithmetic.test.js` - Basic math operations, order of operations
  - `trigonometry.test.js` - sin, cos, tan, inverse functions, hyperbolic
  - `logarithms.test.js` - ln, log, exp functions
  - `strings.test.js` - concat, length, toupper, tolower, substring functions
  - `dates.test.js` - current_date, daysdiff, hoursdiff functions
  - `complex.test.js` - real, imag, conj, arg, norm functions
  - `arrays.test.js` - sizeof, eye, ones, zeros functions

- **Integration Tests** (2 modules): `tests/integration/`
  - `complex-expressions.test.js` - Multi-function combinations
  - `mixed-types.test.js` - Different return types (number, string, boolean)

- **Error Handling** (3 modules): `tests/errors/`
  - `syntax-errors.test.js` - Invalid equation syntax
  - `runtime-errors.test.js` - Division by zero, invalid arguments
  - `type-errors.test.js` - Type mismatches, invalid operations

- **Performance Benchmarks** (3 modules): `tests/performance/`
  - `simple-ops.bench.js` - Basic arithmetic benchmarking
  - `function-calls.bench.js` - Function call performance
  - `complex-expr.bench.js` - Complex expression performance

**Testing Commands:**

```bash
npm test                 # Run all tests
npm run test:watch       # Watch mode for development
npm run test:coverage    # Generate coverage report
npm run test:unit        # Unit tests only
npm run test:integration # Integration tests only
npm run test:performance # Performance benchmarks
```

## 📦 Library Features

### NPM Package Structure

- `package.json` - Complete npm configuration with proper scripts and metadata
- Multi-format exports supporting ES6, CommonJS, and UMD patterns
- TypeScript definitions included for full type safety
- Professional package structure ready for npm publishing

### Enhanced API

```javascript
// Parsec class with enhanced functionality
const parsec = new Parsec()
await parsec.initialize()

// Batch evaluation
const results = parsec.evaluateBatch(['2+2', 'sqrt(16)', 'sin(pi/2)'])

// Timeout protection
const result = await parsec.evaluateWithTimeout('expression', 5000)

// Library metadata
const info = parsec.getInfo()
console.log(info.supportedPlatforms) // Multiple platform support info
```

### Cross-Platform Import Support

```javascript
// ES6 Modules
import { Parsec } from 'parsec-web'

// CommonJS (Node.js)
const { Parsec } = require('parsec-web')

// TypeScript
import { Parsec, EquationResult } from 'parsec-web'
```

### Code Quality Infrastructure

- **Prettier**: Automatic code formatting with consistent style rules
- **ESLint**: Code quality checking with modern JavaScript best practices
- **npm scripts**: `style:fix`, `lint:fix`, `format`, `test` commands
- **Vitest configuration**: Modern testing framework setup

**Development Workflow:**

```bash
npm run style:fix    # Auto-fix formatting and linting
npm test            # Run comprehensive test suite
npm run dev         # Start development server
npm run build       # Build WebAssembly module
```

## 🔮 Future Development

### Flutter Web Integration

- **Goal**: `dart:js_interop` integration
- **Planned**: Dart bindings for JavaScript library
- **Status**: Future enhancement

## 🧪 Testing Philosophy

**Modern Automated Testing Approach:**

- **Vitest**: Modern testing framework
- **Automated**: Runs via npm scripts
- **Comprehensive**: All equations-parser functionality covered
- **CI/CD Ready**: JSON reports, coverage metrics
- **Cross-Platform**: Works in any Node.js environment

## 🚀 Quick Development Commands

### Setup & Installation

```bash
npm install                   # Install all dependencies
chmod +x build.sh             # Make build script executable
./build.sh                    # Compile C++ to WebAssembly
```

#### WebAssembly Build Requirements

The project requires **Emscripten** to compile the C++ equations-parser library to WebAssembly:

- **System Installation**: Install via package manager (`apt-get install emscripten`)
- **Official Download**: From https://emscripten.org/docs/getting_started/downloads.html
- **Manual emsdk Setup**: Clone and configure emsdk repository manually

**Manual emsdk Setup** (if needed):

```bash
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest        # Install latest Emscripten
./emsdk activate latest       # Activate for use
source ./emsdk_env.sh         # Set environment variables
cd ..
./build.sh                    # Build WebAssembly module
```

### Testing (Vitest Framework)

```bash
npm test                      # Run complete test suite
npm run test:watch            # Development mode with auto-rerun
npm run test:coverage         # Generate coverage report
npm run test:unit             # Unit tests only
npm run test:integration      # Integration tests only
npm run test:performance      # Performance benchmarks only
```

### Code Quality & Formatting

```bash
npm run lint          # 🔍 Run ESLint checks
npm run lint:fix      # 🤖 Auto-fix linting issues
npm run format:check  # 🔍 Check formatting without changes
npm run format        # 🤖 Format code with Prettier
npm run style:fix     # 🤖 🦾 Fix both linting and formatting
```

### Development Server

```bash
npm run dev                   # Start development server (port 8000)
npm run serve                 # Alternative server command
# Access: http://localhost:8000
```

### Library Usage Testing

```bash
# Test CommonJS import in Node.js
node -e "const E = require('./index.js'); console.log('✅ CommonJS works')"

# Test ES6 import (requires Node.js with ES modules support)
node --input-type=module -e "import('./index.mjs').then(()=>console.log('✅ ES6 works'))"
```

### Publishing to npm

The repository is configured as a production-ready npm package with dual CommonJS/ES module support:

```bash
# 1. Ensure everything is built and tested
npm run build          # Builds WebAssembly module
npm test              # Runs comprehensive test suite
npm run lint          # Checks code quality

# 2. Test package creation
npm pack --dry-run    # Preview what will be published

# 3. Login to npm (if not already)
npm login

# 4. Publish to npm registry
npm publish

# 5. Or publish as scoped package
npm publish --access public
```

**Package Structure:**

- **CommonJS entry**: `index.cjs` for Node.js `require()`
- **ES Module entry**: `index.mjs` for modern `import`
- **TypeScript definitions**: `types.d.ts` with complete type safety
- **Automated scripts**: `prepublishOnly` and `prepack` ensure quality

**Installation for users:**

```bash
npm install parsec-web
```

**Usage examples:**

```javascript
// CommonJS (Node.js)
const { Parsec } = require('parsec-web')

// ES Modules (modern)
import { Parsec } from 'parsec-web'

// Usage
const parsec = new Parsec()
await parsec.initialize()
const result = parsec.eval('2 + 3 * 4') // Returns: 14
```

## 📁 Project Structure

```
parsec-web/
├── cpp/                      # C++ source files
│   └── equations-parser/     # Git submodule
├── js/                       # JavaScript library
│   └── equations_parser_wrapper.js  # Core WebAssembly wrapper (Parsec class)
├── wasm/                     # Generated WebAssembly files
│   └── equations_parser.js   # Main WebAssembly module
├── tests/                    # Vitest test suites
│   ├── setup.js              # Global test configuration
│   ├── unit/                 # Function category tests
│   ├── integration/          # Complex expression tests
│   ├── errors/               # Error handling tests
│   └── performance/          # Benchmark tests
├── index.js                  # CommonJS entry point
├── index.mjs                 # ES6 module entry point
├── types.d.ts                # TypeScript definitions
├── package.json              # npm package configuration
├── vitest.config.js          # Vitest configuration
├── .eslintrc.js              # ESLint configuration
├── .prettierrc               # Prettier configuration
├── .prettierignore           # Prettier ignore patterns
├── build.sh                  # WebAssembly build script
├── README.md                 # Public documentation
└── CLAUDE.md                 # This development guide
```

## 🎯 Key API Usage

### Primary Interface

```javascript
// Import the library
import Parsec from './js/equations_parser_wrapper.js'

// Initialize WebAssembly module
const parsec = new Parsec()
await parsec.initialize()

// Evaluate equations
const result = parsec.eval('2 + 3 * 4') // Returns: 14
const trig = parsec.eval('sin(pi/2)') // Returns: 1
const complex = parsec.eval('real(3+4i)') // Returns: 3
const string = parsec.eval('concat("a","b")') // Returns: "ab"
```

### Test Structure Pattern

```javascript
// All tests follow this pattern
class SomeTests {
  constructor(testRunner) {
    this.testRunner = testRunner
  }

  async runTests() {
    const result = await this.testRunner.evaluate('some_equation')
    this.testRunner.assertEqual(result, expected, 'Test description')
  }
}
```

## 🚦 Development Workflow

1. **Make Changes**: Edit C++, JavaScript, or test files
2. **Rebuild WASM**: `./build.sh` (if C++ changed)
3. **Run Tests**: `npm test` (verify functionality)
4. **Fix Issues**: Address any failing tests
5. **Lint Code**: `npm run lint` (maintain code quality)
6. **Update Docs**: Keep README.md and CLAUDE.md current

## 🔍 Debugging & Troubleshooting

### Common Issues

- **Module Loading**: Ensure proper ES6 module paths
- **WebAssembly Path**: Check WASM file path resolution
- **Import Errors**: Verify proper import/export statements
- **Test Failures**: Use `npm run test:watch` for iterative debugging

### Debug Commands

```bash
# Detailed test output
npm test -- --reporter verbose

# Run single test file
npm test -- arithmetic.test.js

# Debug mode with console output
npm test -- --reporter verbose --silent false
```

This guide serves as the definitive reference for Parsec Web development, focusing on the modern testing approach and cross-platform generalization goals.

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
