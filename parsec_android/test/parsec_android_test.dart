import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parsec_android/parsec_android.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('parsec_android');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return null;
    });
  });

  test('registers instance', () {
    ParsecAndroid.registerWith();
    expect(ParsecPlatform.instance, isA<ParsecAndroid>());
  });
}
