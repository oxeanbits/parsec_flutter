import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';
import 'package:parsec_windows/parsec_windows.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('parsec_windows');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  test('registers instance', () {
    ParsecWindows.registerWith();
    expect(ParsecPlatform.instance, isA<ParsecWindows>());
  });
}
