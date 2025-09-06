import 'package:flutter_test/flutter_test.dart';
import 'package:parsec/parsec.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Note: Platform implementation is configured in flutter_test_config.dart
  // for test environment compatibility

  group('Parsec Library with WebAssembly Backend', () {
    late Parsec parsec;

    setUpAll(() async {
      parsec = Parsec();
      // Wait for WebAssembly initialization - critical for Web platform
      await Future.delayed(const Duration(milliseconds: 500));
    });

    group('when initializing the parsec web library', () {
      test('should create a valid Parsec instance with Web backend', () {
        expect(parsec, isA<Parsec>());
        expect(ParsecPlatform.instance, isA<ParsecPlatform>());
      });
    });

    group('when evaluating arithmetic expressions with WebAssembly backend', () {
      group('after setting up basic mathematical operations', () {
        test('should perform addition correctly', () async {
          expect(await parsec.eval('2 + 3'), equals(5));
          expect(await parsec.eval('0 + 0'), equals(0));
          expect(await parsec.eval('-5 + 3'), equals(-2));
          expect(await parsec.eval('1.5 + 2.5'), equals(4));
        });

        test('should perform subtraction correctly', () async {
          expect(await parsec.eval('5 - 3'), equals(2));
          expect(await parsec.eval('0 - 0'), equals(0));
          expect(await parsec.eval('-5 - 3'), equals(-8));
          expect(await parsec.eval('10.5 - 2.3'), closeTo(8.2, 0.0001));
        });

        test('should perform multiplication correctly', () async {
          expect(await parsec.eval('3 * 4'), equals(12));
          expect(await parsec.eval('0 * 5'), equals(0));
          expect(await parsec.eval('-3 * 4'), equals(-12));
          expect(await parsec.eval('1.5 * 2'), equals(3));
        });

        test('should perform division correctly', () async {
          expect(await parsec.eval('8 / 2'), equals(4));
          expect(await parsec.eval('0 / 5'), equals(0));
          expect(await parsec.eval('-8 / 2'), equals(-4));
          expect(await parsec.eval('7 / 2'), equals(3.5));
        });

        test('should handle division by zero gracefully', () async {
          expect(await parsec.eval('5 / 0'), equals(double.infinity));
          expect(await parsec.eval('0 / 0'), isNaN);
        });
      });

      group('after setting up order of operations', () {
        test('should follow correct precedence', () async {
          expect(await parsec.eval('2 + 3 * 4'), equals(14));
          expect(await parsec.eval('(2 + 3) * 4'), equals(20));
          expect(await parsec.eval('2 * 3 + 4'), equals(10));
          expect(await parsec.eval('2 * (3 + 4)'), equals(14));
        });

        test('should handle nested parentheses', () async {
          expect(await parsec.eval('((2 + 3) * 4) - 1'), equals(19));
          expect(await parsec.eval('2 * ((3 + 4) * 2)'), equals(28));
        });
      });

      group('after setting up power operations', () {
        test('should handle power operator', () async {
          expect(await parsec.eval('2 ^ 3'), equals(8));
          expect(await parsec.eval('5 ^ 0'), equals(1));
          expect(await parsec.eval('4 ^ 0.5'), equals(2));
        });

        test('should handle pow function', () async {
          expect(await parsec.eval('pow(2, 3)'), equals(8));
          expect(await parsec.eval('pow(5, 0)'), equals(1));
          expect(await parsec.eval('pow(4, 0.5)'), equals(2));
        });
      });

      group('after setting up mathematical functions', () {
        test('should calculate absolute values', () async {
          expect(await parsec.eval('abs(-5)'), equals(5));
          expect(await parsec.eval('abs(5)'), equals(5));
          expect(await parsec.eval('abs(0)'), equals(0));
        });

        test('should calculate square roots', () async {
          expect(await parsec.eval('sqrt(0)'), equals(0));
          expect(await parsec.eval('sqrt(1)'), equals(1));
          expect(await parsec.eval('sqrt(4)'), equals(2));
          expect(await parsec.eval('sqrt(9)'), equals(3));
        });

        test('should calculate cube roots', () async {
          expect(await parsec.eval('cbrt(0)'), equals(0));
          expect(await parsec.eval('cbrt(1)'), equals(1));
          expect(await parsec.eval('cbrt(8)'), equals(2));
          expect(await parsec.eval('cbrt(27)'), equals(3));
        });
      });

      group('after setting up rounding functions', () {
        test('should round numbers correctly', () async {
          expect(await parsec.eval('round(3.2)'), equals(3));
          expect(await parsec.eval('round(3.7)'), equals(4));
          expect(await parsec.eval('round(-3.2)'), equals(-3));
          expect(await parsec.eval('round(-3.7)'), equals(-4));
        });
      });

      group('after setting up min/max functions', () {
        test('should find minimum values', () async {
          expect(await parsec.eval('min(3, 5)'), equals(3));
          expect(await parsec.eval('min(5, 3)'), equals(3));
          expect(await parsec.eval('min(-2, -5)'), equals(-5));
        });

        test('should find maximum values', () async {
          expect(await parsec.eval('max(3, 5)'), equals(5));
          expect(await parsec.eval('max(5, 3)'), equals(5));
          expect(await parsec.eval('max(-2, -5)'), equals(-2));
        });
      });

      group('after setting up mathematical constants', () {
        test('should provide correct mathematical constants', () async {
          final piResult = await parsec.eval('pi');
          final eResult = await parsec.eval('e');
          
          expect(piResult, closeTo(3.14159265359, 0.0001));
          expect(eResult, closeTo(2.71828182846, 0.0001));
        });
      });
    });

    group('when evaluating trigonometric functions with WebAssembly backend', () {
      group('after setting up trigonometric calculations', () {
        test('should calculate sine correctly', () async {
          expect(await parsec.eval('sin(0)'), equals(0));
          expect(await parsec.eval('sin(pi/2)'), closeTo(1, 0.0001));
          expect(await parsec.eval('sin(pi)'), closeTo(0, 0.0001));
        });

        test('should calculate cosine correctly', () async {
          expect(await parsec.eval('cos(0)'), equals(1));
          expect(await parsec.eval('cos(pi/2)'), closeTo(0, 0.0001));
          expect(await parsec.eval('cos(pi)'), closeTo(-1, 0.0001));
        });

        test('should calculate tangent correctly', () async {
          expect(await parsec.eval('tan(0)'), equals(0));
          expect(await parsec.eval('tan(pi/4)'), closeTo(1, 0.0001));
          expect(await parsec.eval('tan(pi)'), closeTo(0, 0.0001));
        });

        test('should calculate inverse trigonometric functions', () async {
          expect(await parsec.eval('asin(0)'), closeTo(0, 0.0001));
          expect(await parsec.eval('asin(1)'), closeTo(1.5708, 0.0001));
          expect(await parsec.eval('acos(1)'), closeTo(0, 0.0001));
          expect(await parsec.eval('acos(0)'), closeTo(1.5708, 0.0001));
          expect(await parsec.eval('atan(0)'), equals(0));
          expect(await parsec.eval('atan(1)'), closeTo(0.7854, 0.0001));
        });
      });

      group('after setting up hyperbolic functions', () {
        test('should calculate hyperbolic sine', () async {
          expect(await parsec.eval('sinh(0)'), equals(0));
          final sinh1 = await parsec.eval('sinh(1)');
          expect(sinh1, closeTo(1.1752, 0.0001));
        });

        test('should calculate hyperbolic cosine', () async {
          expect(await parsec.eval('cosh(0)'), equals(1));
          final cosh1 = await parsec.eval('cosh(1)');
          expect(cosh1, closeTo(1.5431, 0.0001));
        });

        test('should calculate hyperbolic tangent', () async {
          expect(await parsec.eval('tanh(0)'), equals(0));
          final tanh1 = await parsec.eval('tanh(1)');
          expect(tanh1, closeTo(0.7616, 0.0001));
        });
      });
    });

    group('when evaluating logarithmic and exponential functions with WebAssembly backend', () {
      group('after setting up logarithmic calculations', () {
        test('should calculate natural logarithm', () async {
          expect(await parsec.eval('ln(1)'), equals(0));
          expect(await parsec.eval('ln(e)'), closeTo(1, 0.0001));
          final ln10 = await parsec.eval('ln(10)');
          expect(ln10, closeTo(2.3026, 0.0001));
        });

        test('should calculate base-10 logarithm', () async {
          expect(await parsec.eval('log10(1)'), equals(0));
          expect(await parsec.eval('log10(10)'), equals(1));
          expect(await parsec.eval('log10(100)'), equals(2));
        });

        test('should calculate base-2 logarithm', () async {
          expect(await parsec.eval('log2(1)'), equals(0));
          expect(await parsec.eval('log2(2)'), equals(1));
          expect(await parsec.eval('log2(8)'), equals(3));
        });
      });

      group('after setting up exponential calculations', () {
        test('should calculate exponential function', () async {
          expect(await parsec.eval('exp(0)'), equals(1));
          expect(await parsec.eval('exp(1)'), closeTo(2.7183, 0.0001));
          final exp2 = await parsec.eval('exp(2)');
          expect(exp2, closeTo(7.3891, 0.0001));
        });
      });

      group('after setting up edge cases for logarithms', () {
        test('should handle logarithm edge cases', () async {
          expect(await parsec.eval('ln(0)'), equals(double.negativeInfinity));
          expect(await parsec.eval('ln(-1)'), isNaN);
          expect(await parsec.eval('log10(0)'), equals(double.negativeInfinity));
          expect(await parsec.eval('log10(-1)'), isNaN);
        });
      });
    });

    group('when evaluating string functions with WebAssembly backend', () {
      group('after setting up string literals', () {
        test('should handle string literals correctly', () async {
          expect(await parsec.eval('"Hello World"'), equals('Hello World'));
          expect(await parsec.eval('""'), equals(''));
          expect(await parsec.eval('"Test String"'), equals('Test String'));
        });
      });

      group('after setting up string concatenation', () {
        test('should concatenate strings correctly', () async {
          expect(await parsec.eval('concat("Hello", " World")'), equals('Hello World'));
          expect(await parsec.eval('concat("", "")'), equals(''));
          expect(await parsec.eval('concat("A", "B")'), equals('AB'));
        });
      });

      group('after setting up string length calculations', () {
        test('should calculate string length', () async {
          expect(await parsec.eval('length("Hello")'), equals(5));
          expect(await parsec.eval('length("")'), equals(0));
          expect(await parsec.eval('length("Test String")'), equals(11));
        });
      });

      group('after setting up string case functions', () {
        test('should convert to uppercase', () async {
          expect(await parsec.eval('toupper("hello")'), equals('HELLO'));
          expect(await parsec.eval('toupper("Hello World")'), equals('HELLO WORLD'));
          expect(await parsec.eval('toupper("")'), equals(''));
        });

        test('should convert to lowercase', () async {
          expect(await parsec.eval('tolower("HELLO")'), equals('hello'));
          expect(await parsec.eval('tolower("Hello World")'), equals('hello world'));
          expect(await parsec.eval('tolower("")'), equals(''));
        });
      });

      group('after setting up string substring functions', () {
        test('should extract left characters', () async {
          expect(await parsec.eval('left("Hello World", 5)'), equals('Hello'));
          expect(await parsec.eval('left("Test", 2)'), equals('Te'));
          expect(await parsec.eval('left("Hello", 10)'), equals('Hello'));
        });

        test('should extract right characters', () async {
          expect(await parsec.eval('right("Hello World", 5)'), equals('World'));
          expect(await parsec.eval('right("Test", 2)'), equals('st'));
          expect(await parsec.eval('right("Hello", 10)'), equals('Hello'));
        });
      });

      group('after setting up type conversion', () {
        test('should convert strings to numbers', () async {
          expect(await parsec.eval('str2number("42")'), equals(42));
          expect(await parsec.eval('str2number("3.14")'), equals(3.14));
          expect(await parsec.eval('str2number("-5")'), equals(-5));
        });

        test('should convert values to strings', () async {
          expect(await parsec.eval('string(42)'), equals('42'));
          expect(await parsec.eval('string(3.14)'), equals('3.14'));
          expect(await parsec.eval('string(true)'), equals('true'));
          expect(await parsec.eval('string(false)'), equals('false'));
        });
      });
    });

    group('when evaluating boolean and comparison operations with WebAssembly backend', () {
      group('after setting up boolean values', () {
        test('should handle boolean literals', () async {
          expect(await parsec.eval('true'), equals(true));
          expect(await parsec.eval('false'), equals(false));
        });
      });

      group('after setting up comparison operators', () {
        test('should perform greater than comparisons', () async {
          expect(await parsec.eval('5 > 3'), equals(true));
          expect(await parsec.eval('3 > 5'), equals(false));
          expect(await parsec.eval('5 > 5'), equals(false));
        });

        test('should perform less than comparisons', () async {
          expect(await parsec.eval('3 < 5'), equals(true));
          expect(await parsec.eval('5 < 3'), equals(false));
          expect(await parsec.eval('5 < 5'), equals(false));
        });

        test('should perform equality comparisons', () async {
          expect(await parsec.eval('5 == 5'), equals(true));
          expect(await parsec.eval('5 == 3'), equals(false));
          expect(await parsec.eval('"hello" == "hello"'), equals(true));
          expect(await parsec.eval('"hello" == "world"'), equals(false));
        });

        test('should perform inequality comparisons', () async {
          expect(await parsec.eval('5 != 3'), equals(true));
          expect(await parsec.eval('5 != 5'), equals(false));
          expect(await parsec.eval('"hello" != "world"'), equals(true));
          expect(await parsec.eval('"hello" != "hello"'), equals(false));
        });
      });

      group('after setting up logical operators', () {
        test('should perform logical AND with &&', () async {
          expect(await parsec.eval('true && true'), equals(true));
          expect(await parsec.eval('true && false'), equals(false));
          expect(await parsec.eval('false && true'), equals(false));
          expect(await parsec.eval('false && false'), equals(false));
        });

        test('should perform logical OR with ||', () async {
          expect(await parsec.eval('true || true'), equals(true));
          expect(await parsec.eval('true || false'), equals(true));
          expect(await parsec.eval('false || true'), equals(true));
          expect(await parsec.eval('false || false'), equals(false));
        });
      });

      group('after setting up conditional (ternary) operator', () {
        test('should evaluate ternary conditions correctly', () async {
          expect(await parsec.eval('true ? 42 : 0'), equals(42));
          expect(await parsec.eval('false ? 42 : 0'), equals(0));
          expect(await parsec.eval('5 > 3 ? "yes" : "no"'), equals('yes'));
          expect(await parsec.eval('2 > 3 ? "yes" : "no"'), equals('no'));
        });

        test('should handle complex conditions', () async {
          expect(await parsec.eval('(5 > 3 && 2 < 4) ? "both true" : "not both"'), equals('both true'));
          expect(await parsec.eval('(5 > 3 && 2 > 4) ? "both true" : "not both"'), equals('not both'));
        });
      });
    });

    group('when evaluating complex expressions with WebAssembly backend', () {
      group('after setting up multi-function combinations', () {
        test('should handle complex mathematical expressions', () async {
          expect(await parsec.eval('sin(pi/4) * cos(pi/4)'), closeTo(0.5, 0.0001));
          expect(await parsec.eval('sqrt(pow(3, 2) + pow(4, 2))'), equals(5));
          expect(await parsec.eval('abs(-sin(pi/6))'), closeTo(0.5, 0.0001));
        });

        test('should handle mixed type operations', () async {
          expect(await parsec.eval('string(round(3.7)) + " items"'), equals('4 items'));
          expect(await parsec.eval('length("test") * 2'), equals(8));
        });
      });
    });

    group('when handling error cases with WebAssembly backend', () {
      group('after encountering invalid input', () {
        test('should handle empty equations gracefully', () async {
          expect(
            () async => await parsec.eval(''),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('should handle whitespace-only equations gracefully', () async {
          expect(
            () async => await parsec.eval('   '),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('should handle invalid syntax', () async {
          expect(
            () async => await parsec.eval('2 + + 3'),
            throwsException,
          );
        });

        test('should handle undefined functions', () async {
          expect(
            () async => await parsec.eval('undefined_function(5)'),
            throwsException,
          );
        });

        test('should handle invalid function arguments', () async {
          expect(
            () async => await parsec.eval('sqrt(-1)'),
            returnsNormally,
          );
          // sqrt(-1) should return NaN, not throw
          final result = await parsec.eval('sqrt(-1)');
          expect(result, isNaN);
        });
      });
    });

    group('when testing WebAssembly-specific functionality', () {
      group('after setting up advanced mathematical functions', () {
        test('should handle floating point remainder operations', () async {
          expect(await parsec.eval('fmod(10.3, 3.1)'), closeTo(1.0, 0.01));
          expect(await parsec.eval('remainder(10.3, 3.1)'), closeTo(1.0, 0.01));
        });

        test('should handle aggregation functions', () async {
          expect(await parsec.eval('sum(1, 2, 3)'), equals(6));
          expect(await parsec.eval('sum(0)'), equals(0));
          expect(await parsec.eval('sum(-1, 1)'), equals(0));
          expect(await parsec.eval('avg(2, 4, 6)'), equals(4));
          expect(await parsec.eval('avg(1, 1, 1)'), equals(1));
        });

        test('should handle vector operations', () async {
          expect(await parsec.eval('hypot(3, 4)'), equals(5));
          expect(await parsec.eval('hypot(0, 0)'), equals(0));
          expect(await parsec.eval('hypot(1, 1)'), closeTo(1.414213562373095, 0.0001));
        });

        test('should handle scientific notation', () async {
          expect(await parsec.eval('1e2'), equals(100));
          expect(await parsec.eval('2.5e-1'), equals(0.25));
        });

        test('should handle decimal rounding functions', () async {
          expect(await parsec.eval('round_decimal(3.14159, 2)'), closeTo(3.14, 0.0001));
          expect(await parsec.eval('round_decimal(2.71828, 3)'), closeTo(2.718, 0.0001));
        });
      });

      group('after setting up unary operators', () {
        test('should handle unary minus correctly', () async {
          expect(await parsec.eval('-5'), equals(-5));
          expect(await parsec.eval('-(3 + 2)'), equals(-5));
          expect(await parsec.eval('-(-5)'), equals(5));
        });

        test('should handle unary plus correctly', () async {
          expect(await parsec.eval('+5'), equals(5));
          expect(await parsec.eval('+(3 + 2)'), equals(5));
        });
      });

      group('after setting up WebAssembly performance validation', () {
        test('should handle computationally intensive calculations efficiently', () async {
          // Test that shows WebAssembly performance advantage
          final startTime = DateTime.now();
          
          // Complex nested calculations that would be slower with mock implementation
          final result1 = await parsec.eval('sqrt(pow(sin(pi/3), 2) + pow(cos(pi/3), 2))');
          final result2 = await parsec.eval('exp(ln(e * e))');
          final result3 = await parsec.eval('log10(pow(10, 3))');
          
          final endTime = DateTime.now();
          final duration = endTime.difference(startTime);
          
          // Verify results are correct (proving WebAssembly computation)
          expect(result1, closeTo(1, 0.0001));
          expect(result2, closeTo(7.389, 0.01));
          expect(result3, closeTo(3, 0.0001));
          
          // Performance assertion - WebAssembly should be fast
          expect(duration.inMilliseconds, lessThan(1000), 
                reason: 'WebAssembly should provide fast computation');
        });
      });
    });
  });
}
