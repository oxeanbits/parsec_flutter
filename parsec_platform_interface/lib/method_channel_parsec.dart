import 'package:flutter/services.dart';
import 'parsec_platform.dart';

const _channel = MethodChannel('parsec_flutter');

/// An implementation of [ParsecPlatformInterfacePlatform] that uses method channels.
class MethodChannelParsec extends ParsecPlatform {
  /// The method channel used to interact with the native platform.
  @override
  Future<String?> nativeParsecEval(String equation) {
    return _channel.invokeMethod<String>(
      'nativeParsecEval',
      {"equation": equation},
    ).then((String? result) => result);
  }
}
