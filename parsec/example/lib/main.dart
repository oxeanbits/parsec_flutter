import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
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
  TextEditingController controller = TextEditingController();
  String _parsecResult = '';
  final Parsec _parsecPlugin = Parsec();

  Future<void> calculate() async {
    String parsecResult;
    try {
      parsecResult =
          await _parsecPlugin.nativeEval(controller.text) ?? 'Invalid equation';
    } catch (e) {
      log(e.toString());
      parsecResult = 'Failed to eval equation';
    }

    setState(() {
      _parsecResult = parsecResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Parsec plugin example app')),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: controller),
                TextButton(
                  onPressed: () => calculate(),
                  child: const Text("Calculate"),
                ),
                const SizedBox(height: 50),
                Text(
                  _parsecResult,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
