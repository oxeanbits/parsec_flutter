import 'package:flutter_test/flutter_test.dart';
import '../test_config.dart';
import 'parsec_test.dart' as parsec_tests;

/// Web-specific test runner for parsec_flutter
/// 
/// This runner ensures proper initialization of WebAssembly components
/// before executing the main test suite on the Web platform.
void main() async {
  // Initialize Web testing environment
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Web-specific components
    await ParsecWebTestConfig.initialize();
    
    // Additional setup time for WebAssembly initialization
    await Future.delayed(const Duration(milliseconds: 500));
  });
  
  // Verify configuration before running tests
  setUp(() {
    expect(ParsecWebTestConfig.isConfigured, isTrue, 
           reason: 'Web test configuration should be initialized');
  });
  
  // Run the main test suite
  parsec_tests.main();
}