import 'package:parsec_platform_interface/parsec_platform_interface.dart';

/// Simplified Parsec Evaluator with Platform-Based Delegation
/// 
/// This class uses a straightforward platform-based approach:
/// - Web platform → WebAssembly (parsec-web) for calculation
/// - Native platforms → Method Channels for calculation
/// 
/// All functions sent to this library are guaranteed to NOT have custom functions,
/// so all calculations can be done offline.
class Parsec {
  
  /// Evaluate a mathematical equation using platform-specific implementation
  /// 
  /// The equation is routed based solely on the platform:
  /// - Web: Uses WebAssembly through parsec-web
  /// - Native (Android/iOS/Desktop): Uses platform channels
  /// 
  /// Examples:
  /// ```dart
  /// final parsec = Parsec();
  /// 
  /// final result1 = await parsec.eval('2 + 3 * sin(pi/2)');
  /// final result2 = await parsec.eval('sqrt(16) + log(10)');
  /// ```
  Future<dynamic> eval(String equation) async {
    return await ParsecPlatform.instance.nativeEval(equation);
  }
}
