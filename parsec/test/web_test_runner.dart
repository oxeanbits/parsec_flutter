import 'package:flutter_test/flutter_test.dart';
import '../test_config.dart';
import 'parsec_test.dart' as parsec_tests;

/// Web-specific test runner for parsec_flutter
/// 
/// This runner ensures proper initialization of WebAssembly components
/// before executing the main test suite on the Web platform.
void main() async {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await ParsecWebTestConfig.initialize();
    await Future.delayed(const Duration(milliseconds: 500));
  });

  setUp(() {
    expect(ParsecWebTestConfig.isConfigured, isTrue, 
           reason: 'Web test configuration should be initialized');
  });

  parsec_tests.main();
}
