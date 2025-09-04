import 'dart:async';
import 'dart:js_interop';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';
import 'package:web/web.dart' as web;

/// Web implementation of the parsec plugin using WebAssembly
/// 
/// This implementation uses dart:js_interop to call the parsec-web JavaScript
/// library that wraps the equations-parser WebAssembly module.
class ParsecWebPlugin extends ParsecPlatform {
  /// Constructs a ParsecWebPlugin
  ParsecWebPlugin();

  static void registerWith(Registrar registrar) {
    ParsecPlatform.instance = ParsecWebPlugin();
  }

  ParsecJS? _parsecInstance;
  bool _isInitialized = false;

  /// Initialize the parsec-web WebAssembly module
  Future<void> _initializeParsec() async {
    if (_isInitialized) {
      return;
    }

    try {
      // Create new Parsec instance from the global JavaScript context
      _parsecInstance = ParsecJS();
      
      // Initialize the WebAssembly module
      // The parsec-web library should be loaded in the HTML page
      await _parsecInstance!.initialize().toDart;
      
      _isInitialized = true;
      print('✅ Parsec WebAssembly module initialized successfully');
    } catch (error) {
      print('❌ Failed to initialize Parsec WebAssembly module: $error');
      rethrow;
    }
  }

  @override
  Future<dynamic> nativeEval(String equation) async {
    try {
      // Ensure the module is initialized
      await _initializeParsec();

      if (_parsecInstance == null) {
        throw Exception('Parsec WebAssembly module not initialized');
      }

      // Call the eval method and get the result
      final result = _parsecInstance!.eval(equation);
      
      // The parsec-web library returns the value directly (number, string, or boolean)
      // We need to simulate the JSON format that the platform interface expects
      final String jsonResult;
      
      if (result is String) {
        jsonResult = '{"val": "$result", "type": "s", "error": null}';
      } else if (result is bool) {
        jsonResult = '{"val": "${result.toString()}", "type": "b", "error": null}';
      } else if (result is num) {
        // Determine if it's an integer or float
        if (result is int || (result is double && result == result.toInt())) {
          jsonResult = '{"val": "${result.toInt()}", "type": "i", "error": null}';
        } else {
          jsonResult = '{"val": "$result", "type": "f", "error": null}';
        }
      } else {
        // Fallback for any other type
        jsonResult = '{"val": "$result", "type": "s", "error": null}';
      }

      // Parse the result using the platform interface method
      return parseNativeEvalResult(jsonResult);
      
    } catch (error) {
      print('❌ Error in parsec-web eval: $error');
      
      // Return error in the expected JSON format
      final errorJsonResult = '{"val": null, "type": null, "error": "$error"}';
      return parseNativeEvalResult(errorJsonResult);
    }
  }
}

/// JavaScript interop definitions for the Parsec class
/// 
/// These bindings allow Dart to call the parsec-web JavaScript library
/// that wraps the equations-parser WebAssembly module.
@JS('Parsec')
extension type ParsecJS._(JSObject _) implements JSObject {
  /// Create a new Parsec instance
  external ParsecJS();
  
  /// Initialize the WebAssembly module
  /// Returns a Promise that resolves when the module is ready
  external JSPromise<JSAny?> initialize();
  
  /// Evaluate a mathematical equation
  /// Returns the result directly (number, string, or boolean)
  external JSAny? eval(String equation);
  
  /// Check if the module is ready
  external bool isReady();
  
  /// Get information about supported functions
  external JSObject getSupportedFunctions();
}