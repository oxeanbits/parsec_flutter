import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parsec_linux/parsec_linux.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('parsec_linux');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  test('registers instance', () {
    ParsecLinux.registerWith();
    expect(ParsecPlatform.instance, isA<ParsecLinux>());
  });
}
