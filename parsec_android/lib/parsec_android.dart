// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter/services.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';

const MethodChannel _channel = MethodChannel('parsec_android');

class ParsecAndroid extends ParsecPlatform {
  static void registerWith() {
    ParsecPlatform.instance = ParsecAndroid();
  }

  @override
  Future<dynamic> eval(String equation) {
    return _channel.invokeMethod(
      'eval',
      {'equation': equation},
    ).then((result) => result);
  }
}
