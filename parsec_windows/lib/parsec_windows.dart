import 'package:flutter/services.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';

const MethodChannel _channel = MethodChannel('parsec_windows');

class ParsecWindows extends ParsecPlatform {
  static void registerWith() {
    ParsecPlatform.instance = ParsecWindows();
  }

  @override
  Future<dynamic> nativeEval(String equation) {
    return _channel.invokeMethod('nativeEval', {'equation': equation}).then(
        (result) => parseNativeEvalResult(result));
  }
}
