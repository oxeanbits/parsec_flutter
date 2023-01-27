import 'package:flutter/services.dart';
import 'parsec_platform.dart';

const _channel = MethodChannel('parsec_flutter');

/// An implementation of [ParsecPlatformInterfacePlatform] that uses method channels.
class MethodChannelParsec extends ParsecPlatform {
  /// The method channel used to interact with the native platform.
  @override
  Future<dynamic> nativeEval(String equation) {
    return _channel.invokeMethod(
      'nativeEval',
      {'equation': equation},
    ).then((result) => result);
  }
}
