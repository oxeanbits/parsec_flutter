import 'package:flutter_test/flutter_test.dart';
import 'package:parsec_platform_interface/parsec_custom_function_detector.dart';
import 'package:parsec_platform_interface/parsec_load_balancer.dart';

void main() {
  group('ParsecCustomFunctionDetector', () {
    test('should detect changed() function', () {
      expect(
        ParsecCustomFunctionDetector.hasCustomFunctions('changed("haircut")'),
        true,
      );
      expect(
        ParsecCustomFunctionDetector.getCustomFunctions('changed("haircut")'),
        ['changed'],
      );
    });

    test('should detect xlookup() function', () {
      const equation = 'xlookup("6270dd4569ca9c2276a1da02", "record.name", "=", "Arapiraca", "MAX", "record.age")';
      expect(
        ParsecCustomFunctionDetector.hasCustomFunctions(equation),
        true,
      );
      expect(
        ParsecCustomFunctionDetector.getCustomFunctions(equation),
        ['xlookup'],
      );
    });

    test('should detect xquery() function', () {
      const equation = 'xquery("6270dd4569ca9c2276a1da02", "record.boss > record.name AND ...", "AVG", "record.age")';
      expect(
        ParsecCustomFunctionDetector.hasCustomFunctions(equation),
        true,
      );
      expect(
        ParsecCustomFunctionDetector.getCustomFunctions(equation),
        ['xquery'],
      );
    });

    test('should detect association() function', () {
      expect(
        ParsecCustomFunctionDetector.hasCustomFunctions('association("my_association_column")'),
        true,
      );
      expect(
        ParsecCustomFunctionDetector.getCustomFunctions('association("my_association_column")'),
        ['association'],
      );
    });

    test('should detect table_lookup() function', () {
      expect(
        ParsecCustomFunctionDetector.hasCustomFunctions('table_lookup("table_field_key")'),
        true,
      );
      expect(
        ParsecCustomFunctionDetector.getCustomFunctions('table_lookup("table_field_key")'),
        ['table_lookup'],
      );
    });

    test('should detect table_aggregation_lookup() function', () {
      expect(
        ParsecCustomFunctionDetector.hasCustomFunctions('table_aggregation_lookup("record.table_key", "table.aggregation_key")'),
        true,
      );
      expect(
        ParsecCustomFunctionDetector.getCustomFunctions('table_aggregation_lookup("record.table_key", "table.aggregation_key")'),
        ['table_aggregation_lookup'],
      );
    });

    test('should detect has_attachment() function', () {
      expect(
        ParsecCustomFunctionDetector.hasCustomFunctions('has_attachment("column_key")'),
        true,
      );
      expect(
        ParsecCustomFunctionDetector.getCustomFunctions('has_attachment("column_key")'),
        ['has_attachment'],
      );
    });

    test('should detect multiple custom functions', () {
      const equation = 'changed("field1") + xlookup("id", "record.name", "=", "value", "MAX", "record.age")';
      expect(
        ParsecCustomFunctionDetector.hasCustomFunctions(equation),
        true,
      );
      final functions = ParsecCustomFunctionDetector.getCustomFunctions(equation);
      expect(functions.contains('changed'), true);
      expect(functions.contains('xlookup'), true);
      expect(functions.length, 2);
    });

    test('should not detect regular math functions', () {
      const equations = [
        '2 + 3 * 4',
        'sin(pi/2) + cos(0)',
        'sqrt(16) + log(10)',
        'abs(-5) + round(3.7)',
        'max(1, 2, 3) + min(4, 5, 6)',
        'concat("hello", " world")',
        'length("test string")',
        'current_date()',
        'daysdiff("2023-01-01", "2023-12-31")',
      ];

      for (final equation in equations) {
        expect(
          ParsecCustomFunctionDetector.hasCustomFunctions(equation),
          false,
          reason: 'Equation "$equation" should not contain custom functions',
        );
      }
    });

    test('should handle empty and invalid input', () {
      expect(ParsecCustomFunctionDetector.hasCustomFunctions(''), false);
      expect(ParsecCustomFunctionDetector.hasCustomFunctions('   '), false);
      expect(ParsecCustomFunctionDetector.getCustomFunctions(''), isEmpty);
    });
  });

  group('ParsecLoadBalancer', () {
    test('should route simple math to appropriate platform', () {
      const equation = '2 + 3 * sin(pi/2)';
      final decision = ParsecLoadBalancer.analyzeEquation(equation);
      
      expect(decision.hasCustomFunctions, false);
      expect(decision.customFunctions, isEmpty);
      
      // The route depends on platform (web vs native)
      // Since we're in test environment, it should be treated as native
      expect(decision.route, EvaluationRoute.native);
    });

    test('should route custom functions to backend', () {
      const equation = 'changed("field") + 5';
      final decision = ParsecLoadBalancer.analyzeEquation(equation);
      
      expect(decision.hasCustomFunctions, true);
      expect(decision.customFunctions, ['changed']);
      expect(decision.route, EvaluationRoute.backend);
      expect(decision.reasoning, contains('custom functions requiring database access'));
    });

    test('should route complex custom functions to backend', () {
      const equation = 'xlookup("id", "record.name", "=", "value", "MAX", "record.age") * 2';
      final decision = ParsecLoadBalancer.analyzeEquation(equation);
      
      expect(decision.hasCustomFunctions, true);
      expect(decision.customFunctions, ['xlookup']);
      expect(decision.route, EvaluationRoute.backend);
    });

    test('should handle mixed equations with multiple custom functions', () {
      const equation = '(changed("field1") + association("field2")) * sin(pi)';
      final decision = ParsecLoadBalancer.analyzeEquation(equation);
      
      expect(decision.hasCustomFunctions, true);
      expect(decision.customFunctions.length, 2);
      expect(decision.customFunctions.contains('changed'), true);
      expect(decision.customFunctions.contains('association'), true);
      expect(decision.route, EvaluationRoute.backend);
    });

    test('should provide platform information', () {
      final platformInfo = ParsecLoadBalancer.getPlatformInfo();
      
      expect(platformInfo.containsKey('isWeb'), true);
      expect(platformInfo.containsKey('platform'), true);
      expect(platformInfo.containsKey('webAssemblySupported'), true);
      expect(platformInfo.containsKey('nativeMethodChannelsSupported'), true);
    });

    test('should provide performance analysis', () {
      final webAssemblyAnalysis = ParsecLoadBalancer.getPerformanceAnalysis(EvaluationRoute.webAssembly);
      expect(webAssemblyAnalysis['estimatedTime'], '~1ms');
      expect(webAssemblyAnalysis['networkRequired'], 'No');

      final backendAnalysis = ParsecLoadBalancer.getPerformanceAnalysis(EvaluationRoute.backend);
      expect(backendAnalysis['estimatedTime'], '~110ms');
      expect(backendAnalysis['networkRequired'], 'Yes');
      expect(backendAnalysis['databaseAccess'], 'Yes');
    });
  });

  group('Integration Tests', () {
    test('should correctly analyze real-world equations', () {
      final testCases = [
        // Simple math equations - should go to native/webassembly
        {
          'equation': '(5 + 1) + (6 - 2)',
          'expectCustomFunctions': false,
          'expectedRoute': EvaluationRoute.native, // In test environment
        },
        {
          'equation': 'sqrt(pow(3,2) + pow(4,2))',
          'expectCustomFunctions': false,
          'expectedRoute': EvaluationRoute.native,
        },
        {
          'equation': 'max(1, 2) + min(3, 4) + sum(5, 6)',
          'expectCustomFunctions': false,
          'expectedRoute': EvaluationRoute.native,
        },

        // Custom function equations - should go to backend
        {
          'equation': '4 > 2 ? changed("status") : "default"',
          'expectCustomFunctions': true,
          'expectedRoute': EvaluationRoute.backend,
        },
        {
          'equation': 'association("user_profile") + 10',
          'expectCustomFunctions': true,
          'expectedRoute': EvaluationRoute.backend,
        },
        {
          'equation': 'table_lookup("lookup_key") * 1.5',
          'expectCustomFunctions': true,
          'expectedRoute': EvaluationRoute.backend,
        },
      ];

      for (final testCase in testCases) {
        final equation = testCase['equation'] as String;
        final decision = ParsecLoadBalancer.analyzeEquation(equation);
        
        expect(
          decision.hasCustomFunctions,
          testCase['expectCustomFunctions'],
          reason: 'Custom function detection failed for: $equation',
        );
        
        expect(
          decision.route,
          testCase['expectedRoute'],
          reason: 'Route decision incorrect for: $equation',
        );
      }
    });
  });
}