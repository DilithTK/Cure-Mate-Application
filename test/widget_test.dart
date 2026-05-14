// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cure_mate/lib/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(const CureMateApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}*/

<<<<<<< HEAD
import 'package:flutter_test/flutter_test.dart';
import 'package:curemate_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CureMate app starts', (tester) async {
    await tester.pumpWidget(const CureMateApp());

    await tester.pumpAndSettle();

    expect(find.byType(CureMateApp), findsOneWidget);
=======
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curemate_app/main.dart';

void main() {
  testWidgets('CureMate app starts', (WidgetTester tester) async {

    // Build app
    await tester.pumpWidget(const CureMateApp());

    // Wait a bit for async/splash
    await tester.pump(const Duration(seconds: 3));

    // Let UI settle
    await tester.pumpAndSettle();

    // Just check app is running (safe check)
    expect(find.byType(MaterialApp), findsOneWidget);
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  });
}
