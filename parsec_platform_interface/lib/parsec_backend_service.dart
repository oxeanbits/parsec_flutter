/// Backend Service Interface (Mock Implementation)
/// 
/// Handles communication with the Ruby on Rails backend for equations
/// that contain custom functions requiring database access.
/// 
/// This is a mock implementation for development purposes.
class ParsecBackendService {
  
  /// Evaluate an equation on the backend server (Mock)
  /// 
  /// Mock implementation that returns a simple response for any equation
  /// containing custom functions. This will be replaced with actual
  /// backend communication later.
  /// 
  /// Example:
  /// ```dart
  /// final service = ParsecBackendService();
  /// final result = await service.evaluateEquation('xlookup("id", "record.name", "=", "value", "MAX", "record.age")');
  /// // Returns: {"val": "response from backend", "type": "s", "error": null}
  /// ```
  Future<Map<String, dynamic>> evaluateEquation(String equation) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Mock response for any equation with custom functions
    return {
      'val': 'response from backend',
      'type': 's',
      'error': null,
    };
  }
}