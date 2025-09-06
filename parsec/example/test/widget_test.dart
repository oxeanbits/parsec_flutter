// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:parsec_example/main.dart';

void main() {
  testWidgets('Verify platform info is displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that platform information section is present.
    expect(find.text('🏗️ Platform Info:'), findsOneWidget);

    // Verify that detailed platform info text is rendered (contains 'Platform:').
    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget is Text && widget.data != null && widget.data!.contains('Platform:'),
      ),
      findsWidgets,
    );
  });
}
