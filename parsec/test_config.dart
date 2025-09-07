import 'dart:html' as html;
import 'dart:js_util' as js_util;

/// Configuration for Web-specific testing setup
/// 
/// This file handles the initialization of WebAssembly components
/// required for proper parsec_web testing in a browser environment.
class ParsecWebTestConfig {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    await _loadParsecWebLibrary();
    await _initializeWebAssembly();

    _initialized = true;
  }

  static Future<void> _loadParsecWebLibrary() async {
    if (js_util.hasProperty(html.window, 'Parsec')) {
      return;
    }

    final script = html.ScriptElement()
      ..type = 'module'
      ..src = 'packages/parsec_web/parsec-web/js/equations_parser_wrapper.js';

    html.document.head!.append(script);

    await _waitForGlobal('Parsec');
  }

  static Future<void> _initializeWebAssembly() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

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

  static bool get isConfigured => _initialized;

  static void reset() {
    _initialized = false;
  }
}
