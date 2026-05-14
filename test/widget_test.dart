import 'package:flutter_test/flutter_test.dart';
import 'package:curemate_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CureMate app starts', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const CureMateApp());

    // Wait for async / splash / animations
    await tester.pumpAndSettle();

    // Basic check: app widget exists
    expect(find.byType(CureMateApp), findsOneWidget);
  });
}