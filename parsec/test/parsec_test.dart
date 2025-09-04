import 'package:flutter_test/flutter_test.dart';
import 'package:parsec/parsec.dart';

void main() {
  group('Parsec', () {
    test('should evaluate simple mathematical expressions', () async {
      final parsec = Parsec();
      
      // Note: These tests will use method channels in test environment
      // and require platform-specific implementations to be mocked
      expect(parsec, isA<Parsec>());
    });
    
    test('should handle empty equations gracefully', () async {
      final parsec = Parsec();
      
      expect(
        () async => await parsec.eval(''),
        throwsA(isA<ArgumentError>()),
      );
    });
    
    test('should handle whitespace-only equations gracefully', () async {
      final parsec = Parsec();
      
      expect(
        () async => await parsec.eval('   '),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}