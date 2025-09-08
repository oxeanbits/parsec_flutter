import 'dart:convert';
import 'package:parsec_platform_interface/parsec_eval_exception.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'method_channel_parsec.dart';

abstract class ParsecPlatform extends PlatformInterface {
  /// Constructs a ParsecPlatformInterfacePlatform.
  ParsecPlatform() : super(token: _token);

  static final Object _token = Object();

  static ParsecPlatform _instance = MethodChannelParsec();

  /// The default instance of [ParsecPlatform] to use.
  ///
  /// Defaults to [MethodChannelParsecPlatformInterface].
  static ParsecPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ParsecPlatform] when
  /// they register themselves.
  static set instance(ParsecPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<dynamic> nativeEval(String equation) {
    throw UnimplementedError('nativeEval() has not been implemented.');
  }

  dynamic parseNativeEvalResult(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    var val = jsonData['val'];
    var type = jsonData['type'];
    var error = jsonData['error'];

    if (error != null) {
      throw ParsecEvalException(error);
    }

    switch (type) {
      case 'i':
        return int.parse(val);
      case 'f':
        // Handle special float values from C++
        switch (val) {
          case 'inf':
            return double.infinity;
          case '-inf':
            return double.negativeInfinity;
          case '-nan':
            return double.nan;
          default:
            return double.parse(val);
        }
      case 'b':
        return val == 'true';
      default:
        return val;
    }
  }
}
