import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'parsec_custom_function_detector.dart';
import 'parsec_platform.dart';

/// Evaluation Route enum
/// 
/// Defines the different routes an equation can take for evaluation.
enum EvaluationRoute {
  /// Use WebAssembly (parsec-web) for fast evaluation
  webAssembly,
  
  /// Use native platform implementation (Method Channels)
  native,
  
  /// Send to backend server for evaluation
  backend,
}

/// Evaluation Route Decision
/// 
/// Contains information about how an equation should be routed for evaluation.
class EvaluationRouteDecision {
  final EvaluationRoute route;
  final String reasoning;
  final List<String> customFunctions;
  final bool hasCustomFunctions;

  const EvaluationRouteDecision({
    required this.route,
    required this.reasoning,
    required this.customFunctions,
    required this.hasCustomFunctions,
  });

  @override
  String toString() {
    return 'EvaluationRouteDecision(route: $route, hasCustomFunctions: $hasCustomFunctions, customFunctions: $customFunctions, reasoning: $reasoning)';
  }
}

/// Parsec Load Balancer
/// 
/// Smart routing system that analyzes equations and determines the optimal
/// evaluation strategy based on platform capabilities and equation complexity.
/// 
/// Routing Logic:
/// - Web Platform + No Custom Functions → WebAssembly (fastest)
/// - Web Platform + Custom Functions → Backend (database access required)
/// - Native Platform → Method Channels (existing implementation)
class ParsecLoadBalancer {
  
  /// Analyze an equation and determine the optimal evaluation route
  /// 
  /// This is the core intelligence of the load balancer. It considers:
  /// 1. Current platform (web vs native)
  /// 2. Presence of custom functions requiring database access
  /// 3. Performance optimization opportunities
  /// 
  /// Example:
  /// ```dart
  /// final decision = ParsecLoadBalancer.analyzeEquation('2 + 3 * sin(pi/2)');
  /// print(decision.route); // EvaluationRoute.webAssembly (on web)
  /// 
  /// final customDecision = ParsecLoadBalancer.analyzeEquation('xlookup("id", "record.name", "=", "value", "MAX", "record.age")');
  /// print(customDecision.route); // EvaluationRoute.backend
  /// ```
  static EvaluationRouteDecision analyzeEquation(String equation) {
    // Step 1: Detect custom functions
    final bool hasCustomFunctions = ParsecCustomFunctionDetector.hasCustomFunctions(equation);
    final List<String> customFunctions = ParsecCustomFunctionDetector.getCustomFunctions(equation);

    // Step 2: Platform-specific routing logic
    if (kIsWeb) {
      return _analyzeForWebPlatform(equation, hasCustomFunctions, customFunctions);
    } else {
      return _analyzeForNativePlatform(equation, hasCustomFunctions, customFunctions);
    }
  }

  /// Web platform routing logic
  static EvaluationRouteDecision _analyzeForWebPlatform(
    String equation, 
    bool hasCustomFunctions, 
    List<String> customFunctions
  ) {
    if (hasCustomFunctions) {
      // Web platform with custom functions → Must go to backend
      return EvaluationRouteDecision(
        route: EvaluationRoute.backend,
        reasoning: 'Web platform with custom functions requiring database access: ${customFunctions.join(", ")}',
        customFunctions: customFunctions,
        hasCustomFunctions: true,
      );
    } else {
      // Web platform without custom functions → Use WebAssembly for maximum performance
      return EvaluationRouteDecision(
        route: EvaluationRoute.webAssembly,
        reasoning: 'Web platform with pure mathematical equation - using WebAssembly for optimal performance (~1ms vs ~110ms)',
        customFunctions: [],
        hasCustomFunctions: false,
      );
    }
  }

  /// Native platform routing logic
  static EvaluationRouteDecision _analyzeForNativePlatform(
    String equation, 
    bool hasCustomFunctions, 
    List<String> customFunctions
  ) {
    if (hasCustomFunctions) {
      // Native platform with custom functions → Backend (database access required)
      return EvaluationRouteDecision(
        route: EvaluationRoute.backend,
        reasoning: 'Native platform with custom functions requiring database access: ${customFunctions.join(", ")}',
        customFunctions: customFunctions,
        hasCustomFunctions: true,
      );
    } else {
      // Native platform without custom functions → Use existing Method Channels
      return EvaluationRouteDecision(
        route: EvaluationRoute.native,
        reasoning: 'Native platform with pure mathematical equation - using existing Method Channel implementation',
        customFunctions: [],
        hasCustomFunctions: false,
      );
    }
  }

  /// Get current platform information for debugging
  static Map<String, dynamic> getPlatformInfo() {
    return {
      'isWeb': kIsWeb,
      'platform': kIsWeb ? 'web' : _getNativePlatformName(),
      'webAssemblySupported': kIsWeb,
      'nativeMethodChannelsSupported': !kIsWeb,
    };
  }

  /// Get native platform name
  static String _getNativePlatformName() {
    if (kIsWeb) return 'web';
    
    try {
      if (Platform.isAndroid) return 'android';
      if (Platform.isIOS) return 'ios';
      if (Platform.isLinux) return 'linux';
      if (Platform.isWindows) return 'windows';
      if (Platform.isMacOS) return 'macos';
    } catch (e) {
      // Platform.* might not be available in some contexts
    }
    
    return 'unknown';
  }

  /// Performance analysis for different routes
  /// 
  /// Provides estimated performance characteristics for debugging and monitoring.
  static Map<String, String> getPerformanceAnalysis(EvaluationRoute route) {
    switch (route) {
      case EvaluationRoute.webAssembly:
        return {
          'estimatedTime': '~1ms',
          'performance': 'Excellent - Near-native WebAssembly performance',
          'networkRequired': 'No',
          'databaseAccess': 'No',
          'scalability': 'Infinite - Client-side only',
        };
      
      case EvaluationRoute.native:
        return {
          'estimatedTime': '~5-10ms',
          'performance': 'Very Good - Native C++ library via Method Channels',
          'networkRequired': 'No',
          'databaseAccess': 'No',
          'scalability': 'Excellent - Client-side only',
        };
      
      case EvaluationRoute.backend:
        return {
          'estimatedTime': '~110ms',
          'performance': 'Good - Server processing with database access',
          'networkRequired': 'Yes',
          'databaseAccess': 'Yes',
          'scalability': 'Limited - Server infrastructure dependent',
        };
    }
  }
}