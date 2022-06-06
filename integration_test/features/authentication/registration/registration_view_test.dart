import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_state.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_model.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_state.dart';
import 'package:crosscheck/features/authentication/presentation/registration/views/registration_view.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'registration_view_test.mocks.dart';

@GenerateMocks([
  AuthenticationBloc,
  RegistrationBloc,
  RegistrationUsecase
])
void main() {
  late MockAuthenticationBloc mockAuthenticationBloc;
  late MockRegistrationBloc mockRegistrationBloc;
  late MockRegistrationUsecase mockRegistrationUsecase;
  late AuthenticationBloc authenticationBloc;
  late RegistrationBloc registrationBloc;
  late RegistrationModel model;
  late Widget testWidget;
  
  const String token = "eyJhbGci OiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  const errorMessage = "Something went wrong";
  const List<Map<String, dynamic>> errors = [
    {
      "field": "name",
      "error": "Your name should contain at least 8 characters"
    },
    {"field": "email", "error": "Please enter a valid email address"},
    {
      "field": "password",
      "error":"A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required."
    },
    {
      "field": "confirmPassword",
      "error": "Your password and confirmation password do not match"
    }
  ];

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockRegistrationUsecase = MockRegistrationUsecase();
    authenticationBloc = AuthenticationBloc();
    registrationBloc = RegistrationBloc(registrationUsecase: mockRegistrationUsecase);
    model = const RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "");
    
    testWidget = buildWidget(
      authenticationBloc: authenticationBloc,
      registrationBloc: registrationBloc
    );
  });

  testWidgets("Should display registration view", (WidgetTester tester) async {
    runApp(testWidget);
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

  testWidgets("Should return field's value as the same as the text is entered on TextField widget and keep the state while entering value of each field one by one", (WidgetTester tester) async {
    runApp(testWidget);
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

  setUp(() {
    mockRegistrationUsecase = MockRegistrationUsecase();
    authenticationBloc = AuthenticationBloc();
    registrationBloc = RegistrationBloc(registrationUsecase: mockRegistrationUsecase);
    model = const RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "");
    
    testWidget = buildWidget(
      authenticationBloc: authenticationBloc,
      registrationBloc: registrationBloc
    );
  });

  testWidgets("Should display loading modal/dialog on submit registration", (WidgetTester tester) async {
    when(mockRegistrationUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(AuthenticationEntity(token: token));
    });

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
    await tester.pump();
    await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
    await tester.pump();
    await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
    await tester.pump();
    await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
    await tester.pump();

    RegistrationState expected = const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: ""));
    expect(registrationBloc.state, expected);

    await tester.runAsync(() async {
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
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

  testWidgets("Should show and hide RegistrationGeneralError when registration returns NetworkFailure", (WidgetTester tester) async {
    when(mockRegistrationUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Left(NetworkFailure());
    });

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
    await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
    await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
    await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
    await tester.pump();

    await tester.runAsync(() async {
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      RegistrationState expected = RegistrationLoading(model: model);
      expect(registrationBloc.state, expected);
      expect(find.text("Loading..."), findsOneWidget);
      
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
      expected = RegistrationGeneralError(message: NetworkFailure.message, model: model);
      expect(registrationBloc.state, expected);
      expect(find.text(NetworkFailure.message), findsOneWidget);
      expect(find.byKey(const Key("dismissButton")), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key("dismissButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("dismissButton")));
      await tester.pump();

      expected = RegistrationNoGeneralError(model: model);
      expect(registrationBloc.state, expected);
      expect(find.text(NetworkFailure.message), findsNothing);
    });
  });

  testWidgets("Should show and hide RegistrationGeneralError when registration returns ServerFailure", (WidgetTester tester) async {
      when(mockRegistrationUsecase(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return Left(ServerFailure(message: errorMessage));
      });

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
      await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
      await tester.pump();

      await tester.runAsync(() async {
        await tester.ensureVisible(find.byKey(const Key("submitButton")));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();

        RegistrationState expected = RegistrationLoading(model: model);
        expect(registrationBloc.state, expected);
        expect(find.text("Loading..."), findsOneWidget);
        
        await Future.delayed(const Duration(seconds: 2));
        await tester.pump();
        expected = RegistrationGeneralError(message: errorMessage, model: model);
        expect(registrationBloc.state, expected);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byKey(const Key("dismissButton")), findsOneWidget);

        await tester.ensureVisible(find.byKey(const Key("dismissButton")));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key("dismissButton")));
        await tester.pump();

        expected = RegistrationNoGeneralError(model: model);
        expect(registrationBloc.state, expected);
        expect(find.text(errorMessage), findsNothing);
      });
    });

    testWidgets("Should display and reset error fields when user retype value after registration returns validation error", (WidgetTester tester) async {
    when(mockRegistrationUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return Left(ServerFailure(message: errorMessage, errors: errors));
    });

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
    await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
    await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
    await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
    await tester.pump();

    await tester.runAsync(() async {
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      RegistrationState expected = RegistrationLoading(model: model);
      expect(registrationBloc.state, expected);
      expect(find.text("Loading..."), findsOneWidget);

      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();

      final modifiedModel = model.copyWith(
        errorName: "Your name should contain at least 8 characters",
        errorEmail: "Please enter a valid email address",
        errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.",
        errorConfirmPassword: "Your password and confirmation password do not match"
      );

      expected = RegistrationValidationError(model: modifiedModel);
      expect(registrationBloc.state, expected);
      expect(find.text(modifiedModel.errorName), findsOneWidget);
      expect(find.text(modifiedModel.errorEmail), findsOneWidget);
      expect(find.text(modifiedModel.errorPassword), findsOneWidget);
      expect(find.text(modifiedModel.errorConfirmPassword), findsOneWidget);

      
      await tester.enterText(find.byKey(const Key("nameField")), "Fulano");
      await tester.pump();
      expect(find.text(modifiedModel.errorName), findsNothing);
      await tester.enterText(find.byKey(const Key("emailField")), "fulano@email.com");
      await tester.pump();
      expect(find.text(modifiedModel.errorEmail), findsNothing);
      await tester.enterText(find.byKey(const Key("passwordField")), "Password456");
      await tester.pump();
      expect(find.text(modifiedModel.errorPassword), findsNothing);
      await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password456");
      await tester.pump();
      expect(find.text(modifiedModel.errorConfirmPassword), findsNothing);
    });
  });

  testWidgets("Should return RegistrationSuccess when registration is success", (WidgetTester tester) async {
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

    await tester.runAsync(() async {
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      RegistrationState expected = RegistrationLoading(model: model);
      expect(registrationBloc.state, expected);
      expect(find.text("Loading..."), findsOneWidget);

      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();

      expected = const RegistrationSuccess(token: token);
      expect(registrationBloc.state, expected);
    });
  });

  testWidgets("Should return Authenticated after registration is success", (WidgetTester tester) async {
    when(mockRegistrationUsecase(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return const Right(AuthenticationEntity(token: token));
    });

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    expect(authenticationBloc.state, const Unauthenticated());

    await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
    await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
    await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
    await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
    await tester.pump();

    await tester.runAsync(() async {
      await tester.ensureVisible(find.byKey(const Key("submitButton")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("submitButton")));
      await tester.pump();

      RegistrationState expected = RegistrationLoading(model: model);
      expect(registrationBloc.state, expected);
      expect(find.text("Loading..."), findsOneWidget);

      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();

      expected = const RegistrationSuccess(token: token);
      expect(registrationBloc.state, expected);
      expect(authenticationBloc.state, const Authenticated(token: token));
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
