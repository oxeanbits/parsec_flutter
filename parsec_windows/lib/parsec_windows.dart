import 'dart:convert';
import 'package:parsec_platform_interface/parsec_eval_exception.dart';
import 'package:flutter/services.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';

const MethodChannel _channel = MethodChannel('parsec_windows');

class ParsecWindows extends ParsecPlatform {
  static void registerWith() {
    ParsecPlatform.instance = ParsecWindows();
  }

  @override
  Future<dynamic> nativeEval(String equation) {
    return _channel.invokeMethod(
      'nativeEval',
      {'equation': equation},
    ).then((result) => parseNativeEvalResult(result));
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
        return double.parse(val);
      case 'b':
        return val == 'true';
      default:
        return val;
    }
  }
}
