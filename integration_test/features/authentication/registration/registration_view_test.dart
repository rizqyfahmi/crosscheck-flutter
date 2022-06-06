import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:crosscheck/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Should display registration view", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text("Create your account"), findsOneWidget);
    expect(find.byKey(const Key("logo")), findsOneWidget);
    expect(find.byKey(const Key("nameField")), findsOneWidget);
    expect(find.byKey(const Key("emailField")), findsOneWidget);
    expect(find.byKey(const Key("passwordField")), findsOneWidget);
    expect(find.byKey(const Key("confirmPasswordField")), findsOneWidget);
    expect(find.byKey(const Key("submitButton")), findsOneWidget);
    expect(find.byKey(const Key("signInTextButton")), findsOneWidget);
    expect(find.byKey(const Key("tncTextButton")), findsOneWidget);
  });
}