import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

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
      final jsResult = _parsecInstance!.eval(equation);
      final jsonResult = _formatJavaScriptResult(jsResult);
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

  String _formatJavaScriptResult(JSAny? jsResult) {
    final String resultStr = jsResult.toString();
    
    if (_isBooleanResult(resultStr)) {
      return _createJsonResult(resultStr, 'b');
    }
    
    if (_isNumericResult(resultStr)) {
      return _formatNumericResult(resultStr);
    }
    
    return _createJsonResult(resultStr, 's');
  }

  String _createJsonResult(String value, String type) {
    final Map<String, dynamic> result = {
      'val': value,
      'type': type,
      'error': null,
    };
    return jsonEncode(result);
  }

  bool _isBooleanResult(String result) => result == 'true' || result == 'false';

  bool _isNumericResult(String result) => double.tryParse(result) != null;

  String _formatNumericResult(String resultStr) {
    final num parsedNum = double.parse(resultStr);
    final bool isInteger = parsedNum == parsedNum.toInt();
    
    if (isInteger) {
      return _createJsonResult(parsedNum.toInt().toString(), 'i');
    } else {
      return _createJsonResult(parsedNum.toString(), 'f');
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
      // Use the equations-parser module built by parsec_web_lib (relative to the wrapper file)
      await _parsecInstance!.initialize('../wasm/equations_parser.js').toDart;
    } catch (error) {
      throw Exception('Failed to initialize Parsec WebAssembly module: $error');
    }
  }

  bool _isParseWebLibraryAvailable() {
    try {
      final globalParsec = web.window['Parsec'];
      return globalParsec != null;
    } catch (e) {
      return false;
    }
  }

  String _getLibraryNotFoundMessage() {
    return '''
ParsecWebError: parsec-web JavaScript library not found!

The parsec-web library should be available as a git submodule.
To set it up:

1. Run the setup script: ./setup_web_assets.sh
2. Or manually check that web/index.html includes:
   <script type="module" src="packages/parsec_web/parsec-web/js/equations_parser_wrapper.js"></script>
   <!-- The wrapper dynamically imports the WASM module; no direct tag needed. -->

Repository: https://github.com/oxeanbits/parsec-web (included as submodule)
''';
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
  external JSPromise<JSAny?> initialize(String wasmPath);
  
  /// Evaluate a mathematical equation
  /// Returns the result directly (number, string, or boolean)
  external JSAny? eval(String equation);
  
  /// Check if the module is ready
  external bool isReady();
  
  /// Get information about supported functions
  external JSObject getSupportedFunctions();
}
