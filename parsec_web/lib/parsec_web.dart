import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_util' as js_util;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';
import 'package:web/web.dart' as web;

/// Web implementation of the parsec plugin using WebAssembly
/// 
/// Provides equation evaluation through the parsec-web JavaScript library
/// that wraps the equations-parser WebAssembly module for optimal performance.
class ParsecWebPlugin extends ParsecPlatform {
  ParsecWebPlugin();

  static void registerWith(Registrar registrar) {
    ParsecPlatform.instance = ParsecWebPlugin();
  }

  ParsecJS? _parsecInstance;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<dynamic> nativeEval(String equation) async {
    _validateEquation(equation);
    
    try {
      await _ensureParsecInitialized();
      
      // Use evalRaw() which returns the raw JSON from C++
      final jsonResult = _parsecInstance!.evalRaw(equation);
      return parseNativeEvalResult(jsonResult);
    } catch (error) {
      return _handleEvaluationError(error);
    }
  }


  void _validateEquation(String equation) {
    if (equation.trim().isEmpty) {
      throw ArgumentError.value(equation, 'equation', 'Equation cannot be empty');
    }
  }

  Future<void> _ensureParsecInitialized() async {
    if (!_isInitialized) {
      await _initializeParsec();
    }
    
    if (_parsecInstance == null) {
      throw Exception('Parsec WebAssembly module failed to initialize');
    }
  }


  dynamic _handleEvaluationError(Object error) {
    final Map<String, dynamic> result = {
      'val': null,
      'type': null,
      'error': error.toString(),
    };
    final errorJsonResult = jsonEncode(result);
    return parseNativeEvalResult(errorJsonResult);
  }

  Future<void> _initializeParsec() async {
    if (_isInitialized) return;

    _validateWebLibraryAvailability();
    await _createAndInitializeParsecInstance();
    _isInitialized = true;
  }

  void _validateWebLibraryAvailability() {
    if (!_isParseWebLibraryAvailable()) {
      throw Exception(_getLibraryNotFoundMessage());
    }
  }

  Future<void> _createAndInitializeParsecInstance() async {
    try {
      _parsecInstance = ParsecJS();
      await _parsecInstance!.initialize('../wasm/equations_parser.js').toDart;
    } catch (error) {
      throw Exception('Failed to initialize Parsec WebAssembly module: $error');
    }
  }

  bool _isParseWebLibraryAvailable() {
    try {
      return js_util.hasProperty(web.window, 'Parsec');
    } catch (e) {
      return false;
    }
  }

  String _getLibraryNotFoundMessage() {
    return '''
ParsecWebError: parsec-web JavaScript wrapper not found!

To enable the Web platform, ensure your app's web/index.html includes:
  <script type="module" src="packages/parsec_web/parsec-web/js/equations_parser_wrapper.js"></script>
The wrapper dynamically imports the WASM glue at: ../wasm/equations_parser.js

If the WASM glue file is missing during local development, run:
  ./setup_web_assets.sh
This syncs the prebuilt WASM glue into the package at lib/parsec-web/wasm/.
''';
  }
}

/// JavaScript interop definitions for the Parsec class
/// 
/// These bindings allow Dart to call the parsec-web JavaScript library
/// that wraps the equations-parser WebAssembly module.
@JS('Parsec')
extension type ParsecJS._(JSObject _) implements JSObject {
  external ParsecJS();

  external JSPromise<JSAny?> initialize(String wasmPath);

  external JSAny? eval(String equation);

  external String evalRaw(String equation);

  external bool isReady();

  external JSObject getSupportedFunctions();
}
