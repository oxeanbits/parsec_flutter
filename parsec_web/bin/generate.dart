#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';

/// Dart command to generate WASM files for parsec_web
/// 
/// This command replaces the shell scripts (setup_web_assets.sh and build.sh)
/// by performing the same operations in Dart:
/// 1. Checks for parsec-web submodule
/// 2. Builds WebAssembly files using Emscripten if needed
/// 3. Verifies all required files are present

Future<void> main(List<String> args) async {
  final generator = ParsecWebGenerator();
  await generator.generate();
}

class ParsecWebGenerator {
  static const String parsecWebPath = 'lib/parsec-web';
  static const String wasmOutputPath = '$parsecWebPath/wasm';
  static const String wasmOutputFile = '$wasmOutputPath/equations_parser.js';
  static const String jsWrapperFile = '$parsecWebPath/js/equations_parser_wrapper.js';
  
  Future<void> generate() async {
    print('🔧 Generating parsec-web WebAssembly assets...');
    print('================================================');
    
    try {
      await _checkSubmoduleExists();
      await _buildWasmFilesIfNeeded();
      await _verifyRequiredFiles();
      
      print('');
      print('✅ Generation complete!');
      print('');
      print('📋 Next steps:');
      print('1. Ensure your app\'s web/index.html includes:');
      print('   <script type="module" src="packages/parsec_web/parsec-web/js/equations_parser_wrapper.js"></script>');
      print('   <!-- WASM glue is loaded dynamically by the wrapper (../wasm/equations_parser.js). -->');
      print('');
      print('2. Run Flutter web: cd parsec/example && flutter run -d chrome');
      print('');
      print('🚀 WebAssembly is now bundled from the parsec_web package!');
      
    } catch (e) {
      print('❌ Generation failed: $e');
      exit(1);
    }
  }
  
  Future<void> _checkSubmoduleExists() async {
    print('📁 Checking parsec-web submodule...');
    
    final submoduleDir = Directory(parsecWebPath);
    if (!await submoduleDir.exists()) {
      throw Exception(
        'parsec-web submodule not found!\n'
        '   Expected location: $parsecWebPath/\n'
        '   Please initialize the submodule first:\n'
        '   git submodule update --init --recursive'
      );
    }
    
    print('✅ Submodule found at: $parsecWebPath/');
  }
  
  Future<void> _buildWasmFilesIfNeeded() async {
    print('🔧 Checking WASM files...');
    
    final wasmFile = File(wasmOutputFile);
    if (await wasmFile.exists()) {
      print('✅ WASM file already exists: $wasmOutputFile');
      return;
    }
    
    print('🔧 Building WebAssembly files...');
    
    if (!await _isEmscriptenAvailable()) {
      print('❕ Emscripten C++ compiler (em++) not found; skipping WASM build.');
      print('   Tests may use a Dart fallback; to build locally, install Emscripten and re-run.');
      return;
    }
    
    await _runBuildScript();
  }
  
  Future<bool> _isEmscriptenAvailable() async {
    try {
      final result = await Process.run('which', ['em++']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> _runBuildScript() async {
    print('🔧 Compiling with Emscripten...');
    
    // Create wasm output directory if it doesn't exist
    final wasmDir = Directory(wasmOutputPath);
    await wasmDir.create(recursive: true);
    
    // Collect all equations-parser source files
    final parserSourcesDir = Directory('$parsecWebPath/equations-parser/parser');
    final cppFiles = await parserSourcesDir
        .list(recursive: false)
        .where((entity) => entity is File && entity.path.endsWith('.cpp'))
        .cast<File>()
        .toList();
    
    final List<String> sources = [
      'cpp/equations_parser_wrapper.cpp',
      ...cppFiles.map((f) => f.path.replaceFirst('$parsecWebPath/', '')),
    ];
    
    print('📋 Found equations-parser sources: ${cppFiles.length} files');
    
    // Build Emscripten command
    final List<String> compilerArgs = [
      ...sources,
      '-I', 'equations-parser/parser',
      '-std=c++17',
      '-fwasm-exceptions',
      '-s', 'WASM=1',
      '-s', 'ALLOW_MEMORY_GROWTH=1',
      '-s', 'MODULARIZE=1',
      '-s', 'EXPORT_NAME=EquationsModule',
      '-s', 'EXPORT_ES6=1',
      '--bind',
      '-O3',
      '-s', 'ENVIRONMENT=web',
      '-s', 'SINGLE_FILE=1',
      '-o', 'wasm/equations_parser.js',
    ];
    
    final process = await Process.run('em++', compilerArgs, workingDirectory: parsecWebPath);
    
    if (process.exitCode != 0) {
      throw Exception('Emscripten build failed:\n${process.stderr}');
    }
    
    print('✅ Build successful!');
    final wasmFile = File(wasmOutputFile);
    final stats = await wasmFile.stat();
    print('Generated file: $wasmOutputFile (${_formatFileSize(stats.size)})');
  }
  
  Future<void> _verifyRequiredFiles() async {
    print('📁 Verifying required files...');
    
    final jsWrapper = File(jsWrapperFile);
    if (await jsWrapper.exists()) {
      print('✅ JavaScript wrapper found at: $jsWrapperFile');
    } else {
      throw Exception('JavaScript wrapper missing at: $jsWrapperFile');
    }
    
    final wasmGlue = File(wasmOutputFile);
    if (await wasmGlue.exists()) {
      print('✅ WASM glue found at: $wasmOutputFile');
    } else {
      print('⚠️  WASM glue missing at: $wasmOutputFile');
      print('   Continuing without WASM; web tests may use fallback or skip WASM paths.');
    }
  }
  
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
