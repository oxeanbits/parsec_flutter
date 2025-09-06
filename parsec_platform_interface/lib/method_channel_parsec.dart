import 'package:flutter/services.dart';
import 'parsec_platform.dart';

const _channelName = 'parsec_flutter';
const _evalMethodName = 'nativeEval';

/// Method channel implementation for native platform communication.
/// 
/// Handles equation evaluation on Android, iOS, Windows, Linux, and macOS
/// through platform-specific implementations using method channels.
class MethodChannelParsec extends ParsecPlatform {
  final MethodChannel _methodChannel = const MethodChannel(_channelName);

  @override
  Future<dynamic> nativeEval(String equation) async {
    if (equation.trim().isEmpty) {
      throw ArgumentError.value(equation, 'equation', 'Equation cannot be empty');
    }

    return _methodChannel.invokeMethod(_evalMethodName, {'equation': equation});
  }
}
