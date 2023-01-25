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

  Future<String?> nativeParsecEval(String equation) {
    throw UnimplementedError('nativeParsecEval() has not been implemented.');
  }
}
