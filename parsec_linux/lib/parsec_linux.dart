import 'package:flutter/services.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';

const MethodChannel _channel = MethodChannel('parsec_linux');

class ParsecLinux extends ParsecPlatform {
  static void registerWith() {
    ParsecPlatform.instance = ParsecLinux();
  }

  @override
  Future<dynamic> nativeEval(String equation) {
    return _channel.invokeMethod('nativeEval', {'equation': equation}).then(
        (result) => parseNativeEvalResult(result));
  }
}
