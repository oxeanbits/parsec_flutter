import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:parsec/parsec.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  String _platformInfo = '';
  final Parsec _parsec = Parsec();

  final List<Map<String, String>> _testEquations = [
    {'label': 'Simple Addition', 'equation': '2 + 3'},
    {'label': 'Complex Math', 'equation': '2 + 3 * sin(pi/2)'},
    {'label': 'Square Root', 'equation': 'sqrt(16)'},
    {'label': 'Power Function', 'equation': 'pow(2, 3)'},
    {'label': 'Trigonometry', 'equation': 'cos(0) + sin(pi/2)'},
  ];

  Future<void> _calculate() async {
    if (_controller.text.trim().isEmpty) {
      setState(() {
        _result = 'Please enter an equation';
      });
      return;
    }

    try {
      final stopwatch = Stopwatch()..start();
      final result = await _parsec.eval(_controller.text);
      stopwatch.stop();
      
      setState(() {
        _result = '✅ Result: $result\n⏱️ Time: ${stopwatch.elapsedMilliseconds}ms';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Error: $e';
      });
    }
  }

  void _useTestEquation(String equation) {
    _controller.text = equation;
    _calculate();
  }

  @override
  void initState() {
    super.initState();
    _platformInfo = _getPlatformInfo();
  }

  String _getPlatformInfo() {
    return '''
🏗️ PLATFORM INFO:
Platform: ${kIsWeb ? 'Web' : 'Native'}
Implementation: ${kIsWeb ? 'WebAssembly (parsec-web)' : 'Method Channels'}
''';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Parsec Demo'),
          backgroundColor: Colors.blue.shade700,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'e.g., 2 + 3 * sin(pi/2)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Evaluate'),
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
                          return FilterChip(
                            label: Text(test['label']!),
                            backgroundColor: Colors.blue.shade100,
                            onSelected: (selected) => _useTestEquation(test['equation']!),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Row(
                  children: [
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
                                    _result.isEmpty ? 'Enter an equation and press Evaluate' : _result,
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

                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🏗️ Platform Info:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    _platformInfo,
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
