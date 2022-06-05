import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:crosscheck/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Should display registration view", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text("Create your account"), findsOneWidget);
  });
}