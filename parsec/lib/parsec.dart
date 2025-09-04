import 'package:parsec_platform_interface/parsec_platform_interface.dart';
import 'package:parsec_platform_interface/parsec_load_balancer.dart';
import 'package:parsec_platform_interface/parsec_backend_service.dart';

/// Smart Parsec Evaluator with Load Balancing
/// 
/// This class intelligently routes equations based on their content and platform:
/// - Web + No custom functions → WebAssembly (parsec-web) for ~1ms performance
/// - Web + Custom functions → Backend for database access
/// - Native + No custom functions → Method Channels (existing implementation)  
/// - Native + Custom functions → Backend for database access
class Parsec {
  final ParsecBackendService _backendService = ParsecBackendService();

  /// Evaluate a mathematical equation with intelligent routing
  /// 
  /// The equation is automatically analyzed and routed to the optimal evaluation method:
  /// 
  /// Examples:
  /// ```dart
  /// final parsec = Parsec();
  /// 
  /// // Simple math - routed to WebAssembly on web, native on mobile
  /// final result1 = await parsec.eval('2 + 3 * sin(pi/2)');
  /// 
  /// // Custom function - routed to backend for database access
  /// final result2 = await parsec.eval('xlookup("id", "record.name", "=", "value", "MAX", "record.age")');
  /// ```
  Future<dynamic> eval(String equation) async {
    // Step 1: Analyze the equation and determine optimal route
    final decision = ParsecLoadBalancer.analyzeEquation(equation);
    
    // Step 2: Log the routing decision for debugging
    print('🎯 Parsec Routing Decision: ${decision.reasoning}');
    if (decision.hasCustomFunctions) {
      print('🔧 Custom functions detected: ${decision.customFunctions.join(", ")}');
    }

    // Step 3: Route the equation based on the decision
    try {
      switch (decision.route) {
        case EvaluationRoute.webAssembly:
          // Web platform, no custom functions → Use WebAssembly for maximum performance
          print('🚀 Routing to WebAssembly (parsec-web) for optimal performance');
          return await ParsecPlatform.instance.nativeEval(equation);

        case EvaluationRoute.native:
          // Native platform, no custom functions → Use existing Method Channels
          print('📱 Routing to native Method Channels');
          return await ParsecPlatform.instance.nativeEval(equation);

        case EvaluationRoute.backend:
          // Any platform with custom functions → Use backend for database access
          print('🌐 Routing to backend for custom function evaluation');
          final backendResult = await _backendService.evaluateEquation(equation);
          
          // Convert backend response to the expected format using platform interface
          final jsonString = _formatBackendResponse(backendResult);
          return ParsecPlatform.instance.parseNativeEvalResult(jsonString);
      }
    } catch (e) {
      print('❌ Error during equation evaluation: $e');
      rethrow;
    }
  }

  /// Format backend response to match the expected JSON format
  String _formatBackendResponse(Map<String, dynamic> backendResult) {
    // The backend service already returns the correct format
    // {"val": "result_value", "type": "s", "error": null}
    return '{"val": "${backendResult['val']}", "type": "${backendResult['type']}", "error": ${backendResult['error']}}';
  }

  /// Get information about the current routing decision for an equation
  /// 
  /// Useful for debugging and understanding how equations are being processed.
  /// 
  /// Example:
  /// ```dart
  /// final decision = parsec.analyzeEquation('2 + changed("field")');
  /// print(decision.route); // EvaluationRoute.backend
  /// print(decision.customFunctions); // ["changed"]
  /// ```
  EvaluationRouteDecision analyzeEquation(String equation) {
    return ParsecLoadBalancer.analyzeEquation(equation);
  }

  /// Get current platform and routing information
  /// 
  /// Returns detailed information about the current platform capabilities
  /// and supported evaluation routes.
  Map<String, dynamic> getPlatformInfo() {
    final platformInfo = ParsecLoadBalancer.getPlatformInfo();
    final routes = EvaluationRoute.values;
    
    return {
      ...platformInfo,
      'supportedRoutes': routes.map((r) => r.toString()).toList(),
      'routingLogic': {
        'webWithoutCustomFunctions': 'WebAssembly (~1ms)',
        'webWithCustomFunctions': 'Backend (~110ms)', 
        'nativeWithoutCustomFunctions': 'Method Channels (~5-10ms)',
        'nativeWithCustomFunctions': 'Backend (~110ms)',
      }
    };
  }

  /// Get performance analysis for a specific route
  /// 
  /// Useful for monitoring and optimization decisions.
  Map<String, String> getPerformanceAnalysis(EvaluationRoute route) {
    return ParsecLoadBalancer.getPerformanceAnalysis(route);
  }
}
