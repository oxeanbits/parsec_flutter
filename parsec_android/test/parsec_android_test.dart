import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parsec_android/parsec_android.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('parsec_android');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('registers instance', () {
    ParsecAndroid.registerWith();
    expect(ParsecPlatform.instance, isA<ParsecAndroid>());
  });
}
