import 'package:flutter/material.dart';
import 'dart:async';
import 'package:parsec/parsec.dart';
import 'package:parsec_platform_interface/parsec_load_balancer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();
  String _parsecResult = '';
  String _routingInfo = '';
  final Parsec _parsecPlugin = Parsec();

  // Pre-defined test equations
  final List<Map<String, String>> _testEquations = [
    {'label': 'Simple Math', 'equation': '2 + 3 * sin(pi/2)'},
    {'label': 'Complex Math', 'equation': 'sqrt(pow(3,2) + pow(4,2))'},
    {'label': 'String Function', 'equation': 'concat("Hello", " World")'},
    {'label': 'Date Function', 'equation': 'current_date()'},
    {'label': 'Custom: changed()', 'equation': 'changed("status") + 5'},
    {'label': 'Custom: xlookup()', 'equation': 'xlookup("id", "record.name", "=", "value", "MAX", "record.age")'},
    {'label': 'Custom: association()', 'equation': 'association("user_profile") * 2'},
    {'label': 'Multiple Custom', 'equation': 'changed("field1") + association("field2")'},
  ];

  Future<void> calculate() async {
    if (controller.text.trim().isEmpty) {
      setState(() {
        _parsecResult = 'Please enter an equation';
        _routingInfo = '';
      });
      return;
    }

    // Get routing decision
    final decision = _parsecPlugin.analyzeEquation(controller.text);
    final routingInfo = '''
🎯 ROUTING DECISION:
Route: ${decision.route.toString().split('.').last}
Custom Functions: ${decision.hasCustomFunctions ? decision.customFunctions.join(', ') : 'None'}
Reasoning: ${decision.reasoning}

📊 PERFORMANCE:
${_parsecPlugin.getPerformanceAnalysis(decision.route).entries.map((e) => '${e.key}: ${e.value}').join('\n')}
''';

    dynamic parsecResult;
    try {
      // Evaluate the equation
      final stopwatch = Stopwatch()..start();
      parsecResult = await _parsecPlugin.eval(controller.text);
      stopwatch.stop();
      
      final actualTime = stopwatch.elapsedMilliseconds;
      parsecResult = '✅ Result: $parsecResult\n⏱️ Actual Time: ${actualTime}ms';
      
    } catch (e) {
      parsecResult = '❌ Error: $e';
    }

    setState(() {
      _parsecResult = parsecResult.toString();
      _routingInfo = routingInfo;
    });
  }

  void _useTestEquation(String equation) {
    controller.text = equation;
    calculate();
  }

  @override
  void initState() {
    super.initState();
    // Show platform info on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final platformInfo = _parsecPlugin.getPlatformInfo();
      setState(() {
        _routingInfo = '''
🏗️ PLATFORM INFO:
Platform: ${platformInfo['platform']}
Is Web: ${platformInfo['isWeb']}
WebAssembly Supported: ${platformInfo['webAssemblySupported']}
Method Channels Supported: ${platformInfo['nativeMethodChannelsSupported']}

💡 ROUTING LOGIC:
${platformInfo['routingLogic'].entries.map((e) => '${e.key}: ${e.value}').join('\n')}
''';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Parsec Smart Load Balancer Demo'),
          backgroundColor: Colors.blue.shade700,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🧮 Enter Equation:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'e.g., 2 + 3 * sin(pi/2) or changed("status")',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: calculate,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Evaluate with Smart Routing'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Test Equations
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚡ Quick Test Equations:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _testEquations.map((test) {
                          final hasCustomFunctions = test['label']!.startsWith('Custom');
                          return FilterChip(
                            label: Text(test['label']!),
                            backgroundColor: hasCustomFunctions ? Colors.orange.shade100 : Colors.blue.shade100,
                            onSelected: (selected) => _useTestEquation(test['equation']!),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Results Section
              Expanded(
                child: Row(
                  children: [
                    // Result Column
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '📊 Result:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    _parsecResult.isEmpty ? 'Enter an equation and press Evaluate' : _parsecResult,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Routing Info Column
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🎯 Smart Routing Info:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    _routingInfo,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
