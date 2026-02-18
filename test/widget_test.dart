import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silentguard/main.dart';

void main() {
  testWidgets('SilentGuard app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SilentGuardApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
