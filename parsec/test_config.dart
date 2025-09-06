import 'dart:html' as html;
import 'dart:js_util' as js_util;

/// Configuration for Web-specific testing setup
/// 
/// This file handles the initialization of WebAssembly components
/// required for proper parsec_web testing in a browser environment.
class ParsecWebTestConfig {
  static bool _initialized = false;
  
  /// Initialize the Web testing environment
  /// 
  /// This ensures all necessary WebAssembly components and JavaScript
  /// libraries are properly loaded before running tests.
  static Future<void> initialize() async {
    if (_initialized) return;
    
    await _loadParsecWebLibrary();
    await _initializeWebAssembly();
    
    _initialized = true;
  }
  
  /// Load the parsec-web JavaScript wrapper library
  static Future<void> _loadParsecWebLibrary() async {
    // Check if the Parsec global is already available
    if (js_util.hasProperty(html.window, 'Parsec')) {
      return;
    }
    
    // Dynamically load the parsec-web wrapper if not available
    final script = html.ScriptElement()
      ..type = 'module'
      ..src = 'packages/parsec_web/parsec-web/js/equations_parser_wrapper.js';
    
    html.document.head!.append(script);
    
    // Wait for the script to load
    await _waitForGlobal('Parsec');
  }
  
  /// Initialize WebAssembly components
  static Future<void> _initializeWebAssembly() async {
    // The WebAssembly initialization is handled by the parsec-web library
    // This method is reserved for any additional WASM setup if needed
    
    // Wait a moment for WASM initialization
    await Future.delayed(const Duration(milliseconds: 200));
  }
  
  /// Wait for a global JavaScript object to become available
  static Future<void> _waitForGlobal(String globalName) async {
    const maxAttempts = 50;
    int attempts = 0;
    
    while (!js_util.hasProperty(html.window, globalName) && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
    
    if (!js_util.hasProperty(html.window, globalName)) {
      throw Exception('Failed to load $globalName after ${maxAttempts * 100}ms');
    }
  }
  
  /// Check if the testing environment is properly configured
  static bool get isConfigured => _initialized;
  
  /// Reset configuration (useful for testing)
  static void reset() {
    _initialized = false;
  }
}
