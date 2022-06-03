import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_model.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_state.dart';
import 'package:crosscheck/features/authentication/presentation/registration/views/registration_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'registration_view_test.mocks.dart';

@GenerateMocks([
  AuthenticationBloc,
  RegistrationBloc
])
void main() async {
  late MockAuthenticationBloc authenticationBloc;
  late MockRegistrationBloc registrationBloc;
  late Widget testWidget;
  
  setUp(() {
    authenticationBloc = MockAuthenticationBloc();
    registrationBloc = MockRegistrationBloc();

    testWidget = MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => authenticationBloc
        ),
        BlocProvider<RegistrationBloc>(
          create: (_) => registrationBloc
        )
      ], 
      child: const MaterialApp(
        home: RegistrationView(),
      )
    );
  });
  
  group("Looking for some of important widgets", () {
    testWidgets("Should be running well", (WidgetTester tester) async {
      when(registrationBloc.state).thenReturn(const RegistrationInitial());
      when(registrationBloc.stream).thenAnswer((_) => Stream.fromIterable([const RegistrationInitial()]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text("Create your account"), findsOneWidget);
    });

    testWidgets("Should display all fields", (WidgetTester tester) async {
      when(registrationBloc.state).thenReturn(const RegistrationInitial());
      when(registrationBloc.stream).thenAnswer((_) => Stream.fromIterable([const RegistrationInitial()]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("nameField")), findsOneWidget);
      expect(find.byKey(const Key("emailField")), findsOneWidget);
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
      expect(find.byKey(const Key("confirmPasswordField")), findsOneWidget);
    });

    testWidgets("Should display submit button", (WidgetTester tester) async {
      when(registrationBloc.state).thenReturn(const RegistrationInitial());
      when(registrationBloc.stream).thenAnswer((_) => Stream.fromIterable([const RegistrationInitial()]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("submitButton")), findsOneWidget);
    });

    testWidgets("Should display sign in and t&c text button", (WidgetTester tester) async {
      when(registrationBloc.state).thenReturn(const RegistrationInitial());
      when(registrationBloc.stream).thenAnswer((_) => Stream.fromIterable([const RegistrationInitial()]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("signInTextButton")), findsOneWidget);
      expect(find.byKey(const Key("tncTextButton")), findsOneWidget);
    });

    testWidgets("Should display error field when registration returns error validation", (WidgetTester tester) async {

      // change screen size
      // tester.binding.window.physicalSizeTestValue = const Size(720, 1634);

      when(registrationBloc.state).thenReturn(const RegistrationInitial());
      when(registrationBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const RegistrationValidationError(model: RegistrationModel(
          errorName: "Field full name is required",
          errorEmail: "Field email address is required",
          errorPassword: "Field password is required",
          errorConfirmPassword: "Field confirm confirm is required"
        )),
      ]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text("Field full name is required"), findsOneWidget);
      expect(find.text("Field email address is required"), findsOneWidget);
      expect(find.text("Field password is required"), findsOneWidget);
      expect(find.text("Field confirm confirm is required"), findsOneWidget);
      
    });

    testWidgets("Should remove error field when registration on submit (state is loading) after error validation", (WidgetTester tester) async {

      // change screen size
      // tester.binding.window.physicalSizeTestValue = const Size(720, 1634);

      when(registrationBloc.state).thenReturn(const RegistrationInitial());
      when(registrationBloc.stream).thenAnswer((_) => Stream.fromIterable([
        const RegistrationValidationError(model: RegistrationModel(
          errorName: "Field full name is required",
          errorEmail: "Field email address is required",
          errorPassword: "Field password is required",
          errorConfirmPassword: "Field confirm confirm is required"
        )),
        const RegistrationLoading(model: RegistrationModel(
          name: "Fulan",
          email: "fulan@email.com",
          password: "fulan123",
          confirmPassword: "fulan123"
        ))
      ]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text("Field full name is required"), findsNothing);
      expect(find.text("Field email address is required"), findsNothing);
      expect(find.text("Field password is required"), findsNothing);
      expect(find.text("Field confirm confirm is required"), findsNothing);
      
    });
  });

}
