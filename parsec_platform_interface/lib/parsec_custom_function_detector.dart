import 'dart:core';

/// Custom Function Detector
/// 
/// Detects custom functions in equations that require database access.
/// Based on Ruby backend patterns, translated to Dart RegExp.
class ParsecCustomFunctionDetector {
  // Basic patterns (translated from Ruby)
  static const String _varPattern = r'[a-zA-Z]\w*';
  static const String _stringPattern = r'"[^"]*"';
  static const String _integerPattern = r'-?\d+';
  static const String _numericPattern = r'-?\d+(?:\.\d+)?';
  static const String _booleanPattern = r'(?:true|false)';
  static const String _nullPattern = r'(?:NULL|null)';
  
  // Parameter patterns
  static const String _stringParam = r'\s*(?:' + _stringPattern + r')\s*';
  static const String _integerParam = r'\s*(?:' + _integerPattern + r')\s*';
  static const String _numericParam = r'\s*(?:' + _numericPattern + r')\s*';
  static const String _booleanParam = r'\s*(?:' + _booleanPattern + r')\s*';
  static const String _nullParam = r'\s*(?:' + _nullPattern + r')\s*';
  static const String _anyParam = r'(?:' + _stringParam + '|' + _numericParam + '|' + _booleanParam + '|' + _nullParam + ')';

  /// Custom function patterns mapped from Ruby backend
  static final Map<String, RegExp> _customFunctionPatterns = {
    // changed("haircut")
    'changed': RegExp(r'changed\((' + _stringParam + r')\)', caseSensitive: false),
    
    // xlookup("6270dd4569ca9c2276a1da02", "record.name", "=", "Arapiraca", "MAX", "record.age")
    'xlookup': RegExp(
      r'xlookup\((' + _stringParam + r')(?:,(' + _stringParam + r'))(?:,(' + _stringParam + r'))(?:,(' + _anyParam + r'))(?:,(' + _stringParam + r'))(?:,(' + _stringParam + r'))\)',
      caseSensitive: false
    ),
    
    // xquery("6270dd4569ca9c2276a1da02", "record.boss > record.name AND ...", "AVG", "record.age")
    'xquery': RegExp(
      r'xquery\((' + _stringParam + r')(?:,(' + _stringParam + r'))(?:,(' + _stringParam + r'))(?:,(' + _stringParam + r'))\)',
      caseSensitive: false
    ),
    
    // association("my_association_column")
    'association': RegExp(r'association\((' + _stringParam + r')\)', caseSensitive: false),
    
    // table_lookup("table_field_key")
    'table_lookup': RegExp(r'table_lookup\("(' + _varPattern + r')"\)', caseSensitive: false),
    
    // table_aggregation_lookup("record.table_key", "table.aggregation_key")
    'table_aggregation_lookup': RegExp(
      r'table_aggregation_lookup\("record\.(' + _varPattern + r')", ?"table\.(' + _varPattern + r')"\)',
      caseSensitive: false
    ),
    
    // has_attachment("column_key")
    'has_attachment': RegExp(r'has_attachment\("(' + _varPattern + r')"\)', caseSensitive: false),
  };

  /// Check if an equation contains any custom functions
  /// 
  /// Returns true if the equation contains custom functions that require
  /// database access, false otherwise.
  /// 
  /// Example:
  /// ```dart
  /// final detector = ParsecCustomFunctionDetector();
  /// 
  /// // This will return false (no custom functions)
  /// detector.hasCustomFunctions('2 + 3 * sin(pi/2)');
  /// 
  /// // This will return true (contains xlookup custom function)
  /// detector.hasCustomFunctions('xlookup("id", "record.name", "=", "value", "MAX", "record.age")');
  /// ```
  static bool hasCustomFunctions(String equation) {
    if (equation.trim().isEmpty) {
      return false;
    }

    // Check each custom function pattern
    for (final entry in _customFunctionPatterns.entries) {
      if (entry.value.hasMatch(equation)) {
        return true;
      }
    }

    return false;
  }

  /// Get list of custom functions found in the equation
  /// 
  /// Returns a list of custom function names that were detected in the equation.
  /// Useful for debugging and logging purposes.
  /// 
  /// Example:
  /// ```dart
  /// final functions = ParsecCustomFunctionDetector.getCustomFunctions(
  ///   'changed("field") + xlookup("id", "record.name", "=", "value", "MAX", "record.age")'
  /// );
  /// print(functions); // ['changed', 'xlookup']
  /// ```
  static List<String> getCustomFunctions(String equation) {
    if (equation.trim().isEmpty) {
      return [];
    }

    final List<String> foundFunctions = [];

    // Check each custom function pattern
    for (final entry in _customFunctionPatterns.entries) {
      if (entry.value.hasMatch(equation)) {
        foundFunctions.add(entry.key);
      }
    }

    return foundFunctions;
  }

  /// Get detailed information about custom functions in the equation
  /// 
  /// Returns a map with function names as keys and their match details as values.
  /// Useful for advanced debugging and analysis.
  static Map<String, List<RegExpMatch>> getCustomFunctionMatches(String equation) {
    if (equation.trim().isEmpty) {
      return {};
    }

    final Map<String, List<RegExpMatch>> matches = {};

    // Find all matches for each custom function pattern
    for (final entry in _customFunctionPatterns.entries) {
      final List<RegExpMatch> functionMatches = entry.value.allMatches(equation).toList();
      if (functionMatches.isNotEmpty) {
        matches[entry.key] = functionMatches;
      }
    }

    return matches;
  }

  /// Check if a specific custom function is present in the equation
  /// 
  /// Example:
  /// ```dart
  /// bool hasXlookup = ParsecCustomFunctionDetector.hasSpecificFunction(equation, 'xlookup');
  /// ```
  static bool hasSpecificFunction(String equation, String functionName) {
    if (equation.trim().isEmpty) {
      return false;
    }

    final pattern = _customFunctionPatterns[functionName.toLowerCase()];
    if (pattern == null) {
      return false;
    }

    return pattern.hasMatch(equation);
  }

  /// Get all available custom function names
  /// 
  /// Returns a list of all custom function names that can be detected.
  static List<String> getSupportedCustomFunctions() {
    return _customFunctionPatterns.keys.toList();
  }
}