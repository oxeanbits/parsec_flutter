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
  String equation = "5*5 + 5!";
  String _parsecResult = '';
  final Parsec _parsecPlugin = Parsec();

  @override
  void initState() {
    super.initState();
    initParsec();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initParsec() async {
    String parsecResult;
    try {
      parsecResult =
          await _parsecPlugin.nativeEval(equation) ?? 'Invalid equation';
    } catch (e) {
      log(e.toString());
      parsecResult = 'Failed to eval equation';
    }

    if (!mounted) return;

    setState(() {
      _parsecResult = parsecResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('$equation = $_parsecResult\n'),
        ),
      ),
    );
  }
}
