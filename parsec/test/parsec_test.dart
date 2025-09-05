import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parsec/parsec.dart';
import 'package:parsec_platform_interface/parsec_platform_interface.dart';

/// Mock implementation of ParsecPlatform for testing
class MockParsecPlatform extends ParsecPlatform {
  @override
  Future<dynamic> nativeEval(String equation) async {
    // Validate input
    if (equation.trim().isEmpty) {
      throw ArgumentError('Equation cannot be empty');
    }

    // Return JSON string like the real implementation, which gets parsed by the platform interface
    final jsonResult = _getJsonResult(equation.trim());
    return parseNativeEvalResult(jsonResult);
  }

  String _getJsonResult(String equation) {
    // Mock responses based on the equation input to simulate the actual parser behavior
    switch (equation) {
      // Arithmetic operations
      case '2 + 3':
        return '{"val": "5", "type": "i", "error": null}';
      case '0 + 0':
        return '{"val": "0", "type": "i", "error": null}';
      case '-5 + 3':
        return '{"val": "-2", "type": "i", "error": null}';
      case '1.5 + 2.5':
        return '{"val": "4", "type": "f", "error": null}';
      case '5 - 3':
        return '{"val": "2", "type": "i", "error": null}';
      case '0 - 0':
        return '{"val": "0", "type": "i", "error": null}';
      case '-5 - 3':
        return '{"val": "-8", "type": "i", "error": null}';
      case '10.5 - 2.3':
        return '{"val": "8.2", "type": "f", "error": null}';
      case '3 * 4':
        return '{"val": "12", "type": "i", "error": null}';
      case '0 * 5':
        return '{"val": "0", "type": "i", "error": null}';
      case '-3 * 4':
        return '{"val": "-12", "type": "i", "error": null}';
      case '1.5 * 2':
        return '{"val": "3", "type": "f", "error": null}';
      case '8 / 2':
        return '{"val": "4", "type": "i", "error": null}';
      case '0 / 5':
        return '{"val": "0", "type": "i", "error": null}';
      case '-8 / 2':
        return '{"val": "-4", "type": "i", "error": null}';
      case '7 / 2':
        return '{"val": "3.5", "type": "f", "error": null}';
      case '5 / 0':
        return '{"val": "Infinity", "type": "f", "error": null}';
      case '0 / 0':
        return '{"val": "NaN", "type": "f", "error": null}';

      // Order of operations
      case '2 + 3 * 4':
        return '{"val": "14", "type": "i", "error": null}';
      case '(2 + 3) * 4':
        return '{"val": "20", "type": "i", "error": null}';
      case '2 * 3 + 4':
        return '{"val": "10", "type": "i", "error": null}';
      case '2 * (3 + 4)':
        return '{"val": "14", "type": "i", "error": null}';
      case '((2 + 3) * 4) - 1':
        return '{"val": "19", "type": "i", "error": null}';
      case '2 * ((3 + 4) * 2)':
        return '{"val": "28", "type": "i", "error": null}';

      // Power operations
      case '2 ^ 3':
        return '{"val": "8", "type": "i", "error": null}';
      case '5 ^ 0':
        return '{"val": "1", "type": "i", "error": null}';
      case '4 ^ 0.5':
        return '{"val": "2", "type": "f", "error": null}';
      case 'pow(2, 3)':
        return '{"val": "8", "type": "i", "error": null}';
      case 'pow(5, 0)':
        return '{"val": "1", "type": "i", "error": null}';
      case 'pow(4, 0.5)':
        return '{"val": "2", "type": "f", "error": null}';

      // Mathematical functions
      case 'abs(-5)':
        return '{"val": "5", "type": "i", "error": null}';
      case 'abs(5)':
        return '{"val": "5", "type": "i", "error": null}';
      case 'abs(0)':
        return '{"val": "0", "type": "i", "error": null}';
      case 'sqrt(0)':
        return '{"val": "0", "type": "i", "error": null}';
      case 'sqrt(1)':
        return '{"val": "1", "type": "i", "error": null}';
      case 'sqrt(4)':
        return '{"val": "2", "type": "i", "error": null}';
      case 'sqrt(9)':
        return '{"val": "3", "type": "i", "error": null}';
      case 'sqrt(-1)':
        return '{"val": "NaN", "type": "f", "error": null}';
      case 'cbrt(0)':
        return '{"val": "0", "type": "i", "error": null}';
      case 'cbrt(1)':
        return '{"val": "1", "type": "i", "error": null}';
      case 'cbrt(8)':
        return '{"val": "2", "type": "i", "error": null}';
      case 'cbrt(27)':
        return '{"val": "3", "type": "i", "error": null}';

      // Rounding
      case 'round(3.2)':
        return '{"val": "3", "type": "i", "error": null}';
      case 'round(3.7)':
        return '{"val": "4", "type": "i", "error": null}';
      case 'round(-3.2)':
        return '{"val": "-3", "type": "i", "error": null}';
      case 'round(-3.7)':
        return '{"val": "-4", "type": "i", "error": null}';

      // Min/Max
      case 'min(3, 5)':
        return '{"val": "3", "type": "i", "error": null}';
      case 'min(5, 3)':
        return '{"val": "3", "type": "i", "error": null}';
      case 'min(-2, -5)':
        return '{"val": "-5", "type": "i", "error": null}';
      case 'max(3, 5)':
        return '{"val": "5", "type": "i", "error": null}';
      case 'max(5, 3)':
        return '{"val": "5", "type": "i", "error": null}';
      case 'max(-2, -5)':
        return '{"val": "-2", "type": "i", "error": null}';

      // Constants
      case 'pi':
        return '{"val": "3.141592653589793", "type": "f", "error": null}';
      case 'e':
        return '{"val": "2.718281828459045", "type": "f", "error": null}';

      // Trigonometric
      case 'sin(0)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'sin(pi/2)':
        return '{"val": "1", "type": "f", "error": null}';
      case 'sin(pi)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'cos(0)':
        return '{"val": "1", "type": "f", "error": null}';
      case 'cos(pi/2)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'cos(pi)':
        return '{"val": "-1", "type": "f", "error": null}';
      case 'tan(0)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'tan(pi/4)':
        return '{"val": "1", "type": "f", "error": null}';
      case 'tan(pi)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'asin(0)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'asin(1)':
        return '{"val": "1.5707963267948966", "type": "f", "error": null}';
      case 'acos(1)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'acos(0)':
        return '{"val": "1.5707963267948966", "type": "f", "error": null}';
      case 'atan(0)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'atan(1)':
        return '{"val": "0.7853981633974483", "type": "f", "error": null}';

      // Hyperbolic
      case 'sinh(0)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'sinh(1)':
        return '{"val": "1.1752011936438014", "type": "f", "error": null}';
      case 'cosh(0)':
        return '{"val": "1", "type": "f", "error": null}';
      case 'cosh(1)':
        return '{"val": "1.5430806348152437", "type": "f", "error": null}';
      case 'tanh(0)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'tanh(1)':
        return '{"val": "0.7615941559557649", "type": "f", "error": null}';

      // Logarithmic and exponential
      case 'ln(1)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'ln(e)':
        return '{"val": "1", "type": "f", "error": null}';
      case 'ln(10)':
        return '{"val": "2.302585092994046", "type": "f", "error": null}';
      case 'ln(0)':
        return '{"val": "-Infinity", "type": "f", "error": null}';
      case 'ln(-1)':
        return '{"val": "NaN", "type": "f", "error": null}';
      case 'log10(1)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'log10(10)':
        return '{"val": "1", "type": "f", "error": null}';
      case 'log10(100)':
        return '{"val": "2", "type": "f", "error": null}';
      case 'log10(0)':
        return '{"val": "-Infinity", "type": "f", "error": null}';
      case 'log10(-1)':
        return '{"val": "NaN", "type": "f", "error": null}';
      case 'log2(1)':
        return '{"val": "0", "type": "f", "error": null}';
      case 'log2(2)':
        return '{"val": "1", "type": "f", "error": null}';
      case 'log2(8)':
        return '{"val": "3", "type": "f", "error": null}';
      case 'exp(0)':
        return '{"val": "1", "type": "f", "error": null}';
      case 'exp(1)':
        return '{"val": "2.718281828459045", "type": "f", "error": null}';
      case 'exp(2)':
        return '{"val": "7.38905609893065", "type": "f", "error": null}';

      // String functions
      case '"Hello World"':
        return '{"val": "Hello World", "type": "s", "error": null}';
      case '""':
        return '{"val": "", "type": "s", "error": null}';
      case '"Test String"':
        return '{"val": "Test String", "type": "s", "error": null}';
      case 'concat("Hello", " World")':
        return '{"val": "Hello World", "type": "s", "error": null}';
      case 'concat("", "")':
        return '{"val": "", "type": "s", "error": null}';
      case 'concat("A", "B")':
        return '{"val": "AB", "type": "s", "error": null}';
      case 'length("Hello")':
        return '{"val": "5", "type": "i", "error": null}';
      case 'length("")':
        return '{"val": "0", "type": "i", "error": null}';
      case 'length("Test String")':
        return '{"val": "11", "type": "i", "error": null}';
      case 'toupper("hello")':
        return '{"val": "HELLO", "type": "s", "error": null}';
      case 'toupper("Hello World")':
        return '{"val": "HELLO WORLD", "type": "s", "error": null}';
      case 'toupper("")':
        return '{"val": "", "type": "s", "error": null}';
      case 'tolower("HELLO")':
        return '{"val": "hello", "type": "s", "error": null}';
      case 'tolower("Hello World")':
        return '{"val": "hello world", "type": "s", "error": null}';
      case 'tolower("")':
        return '{"val": "", "type": "s", "error": null}';
      case 'left("Hello World", 5)':
        return '{"val": "Hello", "type": "s", "error": null}';
      case 'left("Test", 2)':
        return '{"val": "Te", "type": "s", "error": null}';
      case 'left("Hello", 10)':
        return '{"val": "Hello", "type": "s", "error": null}';
      case 'right("Hello World", 5)':
        return '{"val": "World", "type": "s", "error": null}';
      case 'right("Test", 2)':
        return '{"val": "st", "type": "s", "error": null}';
      case 'right("Hello", 10)':
        return '{"val": "Hello", "type": "s", "error": null}';
      case 'str2number("42")':
        return '{"val": "42", "type": "i", "error": null}';
      case 'str2number("3.14")':
        return '{"val": "3.14", "type": "f", "error": null}';
      case 'str2number("-5")':
        return '{"val": "-5", "type": "i", "error": null}';
      case 'string(42)':
        return '{"val": "42", "type": "s", "error": null}';
      case 'string(3.14)':
        return '{"val": "3.14", "type": "s", "error": null}';
      case 'string(true)':
        return '{"val": "true", "type": "s", "error": null}';
      case 'string(false)':
        return '{"val": "false", "type": "s", "error": null}';

      // Boolean operations
      case 'true':
        return '{"val": "true", "type": "b", "error": null}';
      case 'false':
        return '{"val": "false", "type": "b", "error": null}';
      case '5 > 3':
        return '{"val": "true", "type": "b", "error": null}';
      case '3 > 5':
        return '{"val": "false", "type": "b", "error": null}';
      case '5 > 5':
        return '{"val": "false", "type": "b", "error": null}';
      case '3 < 5':
        return '{"val": "true", "type": "b", "error": null}';
      case '5 < 3':
        return '{"val": "false", "type": "b", "error": null}';
      case '5 < 5':
        return '{"val": "false", "type": "b", "error": null}';
      case '5 == 5':
        return '{"val": "true", "type": "b", "error": null}';
      case '5 == 3':
        return '{"val": "false", "type": "b", "error": null}';
      case '"hello" == "hello"':
        return '{"val": "true", "type": "b", "error": null}';
      case '"hello" == "world"':
        return '{"val": "false", "type": "b", "error": null}';
      case '5 != 3':
        return '{"val": "true", "type": "b", "error": null}';
      case '5 != 5':
        return '{"val": "false", "type": "b", "error": null}';
      case '"hello" != "world"':
        return '{"val": "true", "type": "b", "error": null}';
      case '"hello" != "hello"':
        return '{"val": "false", "type": "b", "error": null}';
      case 'true && true':
        return '{"val": "true", "type": "b", "error": null}';
      case 'true && false':
        return '{"val": "false", "type": "b", "error": null}';
      case 'false && true':
        return '{"val": "false", "type": "b", "error": null}';
      case 'false && false':
        return '{"val": "false", "type": "b", "error": null}';
      case 'true || true':
        return '{"val": "true", "type": "b", "error": null}';
      case 'true || false':
        return '{"val": "true", "type": "b", "error": null}';
      case 'false || true':
        return '{"val": "true", "type": "b", "error": null}';
      case 'false || false':
        return '{"val": "false", "type": "b", "error": null}';
      case 'true ? 42 : 0':
        return '{"val": "42", "type": "i", "error": null}';
      case 'false ? 42 : 0':
        return '{"val": "0", "type": "i", "error": null}';
      case '5 > 3 ? "yes" : "no"':
        return '{"val": "yes", "type": "s", "error": null}';
      case '2 > 3 ? "yes" : "no"':
        return '{"val": "no", "type": "s", "error": null}';
      case '(5 > 3 && 2 < 4) ? "both true" : "not both"':
        return '{"val": "both true", "type": "s", "error": null}';
      case '(5 > 3 && 2 > 4) ? "both true" : "not both"':
        return '{"val": "not both", "type": "s", "error": null}';

      // Complex expressions
      case 'sin(pi/4) * cos(pi/4)':
        return '{"val": "0.5", "type": "f", "error": null}';
      case 'sqrt(pow(3, 2) + pow(4, 2))':
        return '{"val": "5", "type": "f", "error": null}';
      case 'abs(-sin(pi/6))':
        return '{"val": "0.5", "type": "f", "error": null}';
      case 'string(round(3.7)) + " items"':
        return '{"val": "4 items", "type": "s", "error": null}';
      case 'length("test") * 2':
        return '{"val": "8", "type": "i", "error": null}';

      // Error cases
      case '2 + + 3':
        return '{"val": null, "type": null, "error": "Syntax error: unexpected operator"}';
      case 'undefined_function(5)':
        return '{"val": null, "type": null, "error": "Unknown function: undefined_function"}';

      default:
        return '{"val": null, "type": null, "error": "Unknown equation: $equation"}';
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set up the mock platform implementation
  setUp(() {
    ParsecPlatform.instance = MockParsecPlatform();
  });

  group('Parsec Library', () {
    late Parsec parsec;

    setUpAll(() async {
      parsec = Parsec();
      // Wait a moment for initialization if needed
      await Future.delayed(Duration(milliseconds: 100));
    });

    group('when initializing the parsec library', () {
      test('should create a valid Parsec instance', () {
        expect(parsec, isA<Parsec>());
      });
    });

    group('when evaluating arithmetic expressions', () {
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

    group('when evaluating trigonometric functions', () {
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

    group('when evaluating logarithmic and exponential functions', () {
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

    group('when evaluating string functions', () {
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

    group('when evaluating boolean and comparison operations', () {
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

    group('when evaluating complex expressions', () {
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

    group('when handling error cases', () {
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
  });
}
