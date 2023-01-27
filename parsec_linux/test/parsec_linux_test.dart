import 'package:flutter_test/flutter_test.dart';
import 'package:parsec_linux/parsec_linux.dart';
import 'package:parsec_linux/parsec_linux_platform_interface.dart';
import 'package:parsec_linux/parsec_linux_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockParsecLinuxPlatform
    with MockPlatformInterfaceMixin
    implements ParsecLinuxPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ParsecLinuxPlatform initialPlatform = ParsecLinuxPlatform.instance;

  test('$MethodChannelParsecLinux is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelParsecLinux>());
  });

  test('getPlatformVersion', () async {
    ParsecLinux parsecLinuxPlugin = ParsecLinux();
    MockParsecLinuxPlatform fakePlatform = MockParsecLinuxPlatform();
    ParsecLinuxPlatform.instance = fakePlatform;

    expect(await parsecLinuxPlugin.getPlatformVersion(), '42');
  });
}
