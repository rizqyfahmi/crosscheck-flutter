import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_model.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_state.dart';
import 'package:crosscheck/features/authentication/presentation/registration/views/registration_view.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'registration_view_test.mocks.dart';

@GenerateMocks([
  AuthenticationBloc,
  RegistrationBloc,
  RegistrationUsecase
])
void main() async {
  late MockAuthenticationBloc mockAuthenticationBloc;
  late MockRegistrationBloc mockRegistrationBloc;
  late MockRegistrationUsecase mockRegistrationUsecase;
  late AuthenticationBloc authenticationBloc;
  late RegistrationBloc registrationBloc;
  late Widget testWidget;
  
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  group("Looking for some of important widgets", () {
    setUp(() {
      mockAuthenticationBloc = MockAuthenticationBloc();
      mockRegistrationBloc = MockRegistrationBloc();

      testWidget = buildWidget(
        authenticationBloc: mockAuthenticationBloc,
        registrationBloc: mockRegistrationBloc
      );
    });

    testWidgets("Should be running well", (WidgetTester tester) async {
      when(mockRegistrationBloc.state).thenReturn(const RegistrationInitial());
      when(mockRegistrationBloc.stream).thenAnswer((_) => Stream.fromIterable([const RegistrationInitial()]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text("Create your account"), findsOneWidget);
    });

    testWidgets("Should display all fields", (WidgetTester tester) async {
      when(mockRegistrationBloc.state).thenReturn(const RegistrationInitial());
      when(mockRegistrationBloc.stream).thenAnswer((_) => Stream.fromIterable([const RegistrationInitial()]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("nameField")), findsOneWidget);
      expect(find.byKey(const Key("emailField")), findsOneWidget);
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
      expect(find.byKey(const Key("confirmPasswordField")), findsOneWidget);
    });

    testWidgets("Should display submit button", (WidgetTester tester) async {
      when(mockRegistrationBloc.state).thenReturn(const RegistrationInitial());
      when(mockRegistrationBloc.stream).thenAnswer((_) => Stream.fromIterable([const RegistrationInitial()]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("submitButton")), findsOneWidget);
    });

    testWidgets("Should display sign in and t&c text button", (WidgetTester tester) async {
      when(mockRegistrationBloc.state).thenReturn(const RegistrationInitial());
      when(mockRegistrationBloc.stream).thenAnswer((_) => Stream.fromIterable([const RegistrationInitial()]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("signInTextButton")), findsOneWidget);
      expect(find.byKey(const Key("tncTextButton")), findsOneWidget);
    });

    testWidgets("Should display error field when registration returns error validation", (WidgetTester tester) async {

      // change screen size
      // tester.binding.window.physicalSizeTestValue = const Size(720, 1634);

      when(mockRegistrationBloc.state).thenReturn(const RegistrationInitial());
      when(mockRegistrationBloc.stream).thenAnswer((_) => Stream.fromIterable([
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

    testWidgets("Should display loading modal/bar when state is RegistrationLoading", (WidgetTester tester) async {

      when(mockRegistrationBloc.state).thenReturn(const RegistrationInitial());
      when(mockRegistrationBloc.stream).thenAnswer((_) => Stream.fromIterable([
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
      await tester.pump();

      expect(find.text("Loading..."), findsOneWidget);
    });
  });

  group("Interaction Test", () {
    setUp(() {
      mockRegistrationUsecase = MockRegistrationUsecase();
      authenticationBloc = AuthenticationBloc();
      registrationBloc = RegistrationBloc(registrationUsecase: mockRegistrationUsecase);
      
      testWidget = buildWidget(
        authenticationBloc: authenticationBloc,
        registrationBloc: registrationBloc
      );
    });
    
    testWidgets("Should return field's value as the same as the text is entered on TextField widget and keep the state while entering value of each field one by one", (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      // Enter a full name
      await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
      await tester.pump();

      RegistrationState expected = const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: ""));
      expect(registrationBloc.state, expected);

      // Enter an email address
      await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
      await tester.pump();

      expected = const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: ""));
      expect(registrationBloc.state, expected);
      
      // Enter a password
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.pump();

      expected = const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "", errorConfirmPassword: ""));
      expect(registrationBloc.state, expected);
      
      // Enter a confirm password
      await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
      await tester.pump();

      expected = const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: ""));
      expect(registrationBloc.state, expected);
    });

    testWidgets("Should display loading modal/dialog on submit registration", (WidgetTester tester) async {
      when(mockRegistrationUsecase(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return const Right(AuthenticationEntity(token: token));
      });

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
      await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
      await tester.pump();

      RegistrationState expected = const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: ""));
      expect(registrationBloc.state, expected);

      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();

        expected = const RegistrationLoading(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: ""));
        expect(registrationBloc.state, expected);
        expect(find.text("Loading..."), findsOneWidget);
        
        await Future.delayed(const Duration(seconds: 2));
        await tester.pump();
        expected = const RegistrationSuccess(token: token);
        expect(registrationBloc.state, expected);
      });
    });
  });

}

Widget buildWidget({
  required AuthenticationBloc authenticationBloc,
  required RegistrationBloc registrationBloc
}) {
  return MultiBlocProvider(
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
}
