import 'package:flutter_test/flutter_test.dart';
import 'package:anime_verse/main.dart';

void main() {
  testWidgets('App renders SignInScreen smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
