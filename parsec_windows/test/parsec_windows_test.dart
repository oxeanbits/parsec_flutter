import 'package:flutter_test/flutter_test.dart';
import 'package:parsec_windows/parsec_windows.dart';
import 'package:parsec_windows/parsec_windows_platform_interface.dart';
import 'package:parsec_windows/parsec_windows_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockParsecWindowsPlatform
    with MockPlatformInterfaceMixin
    implements ParsecWindowsPlatform {
  @override
  Future<String?> nativeEval() => Future.value('42');
}

void main() {
  final ParsecWindowsPlatform initialPlatform = ParsecWindowsPlatform.instance;

  test('$MethodChannelParsecWindows is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelParsecWindows>());
  });

  test('getPlatformVersion', () async {
    ParsecWindows parsecWindowsPlugin = ParsecWindows();
    MockParsecWindowsPlatform fakePlatform = MockParsecWindowsPlatform();
    ParsecWindowsPlatform.instance = fakePlatform;

    expect(await parsecWindowsPlugin.nativeEval('4 * 10 + 2'), '42');
  });
}
