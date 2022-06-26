import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/fonts/fonts.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_model.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_state.dart';
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
  late RegistrationModel model;
  late Widget testWidget;
  
  const errorMessage = "Something went wrong";
  const List<Map<String, dynamic>> errors = [
    {
      "field": "name",
      "message":  "Your name should contain at least 8 characters"
    },
    {"field": "email", "message":  "Please enter a valid email address"},
    {
      "field": "password",
      "message": "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required."
    },
    {
      "field": "confirmPassword",
      "message":  "Your password and confirmation password do not match"
    }
  ];

  group("Looking for some of important widgets", () {
    setUp(() {
      mockAuthenticationBloc = MockAuthenticationBloc();
      mockRegistrationBloc = MockRegistrationBloc();

      testWidget = buildWidget(
        authenticationBloc: mockAuthenticationBloc,
        registrationBloc: mockRegistrationBloc
      );
    });

     testWidgets("Should display all fields properly", (WidgetTester tester) async {

      when(mockRegistrationBloc.state).thenReturn(const RegistrationInitial());
      when(mockRegistrationBloc.stream).thenAnswer((_) => Stream.fromIterable([const RegistrationInitial()]));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text("Create your account"), findsOneWidget);
      expect(find.byKey(const Key("nameField")), findsOneWidget);
      expect(find.byKey(const Key("emailField")), findsOneWidget);
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
      expect(find.byKey(const Key("confirmPasswordField")), findsOneWidget);
      expect(find.byKey(const Key("submitButton")), findsOneWidget);
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
      model = const RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "");
      
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
        return const Right(null);
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
        expect(find.text("Loading..."), findsNothing);
      });
    });

    testWidgets("Should show and hide RegistrationGeneralError when registration returns NullFailure", (WidgetTester tester) async {
      when(mockRegistrationUsecase(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return Left(NullFailure());
      });

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
      await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
      await tester.pump();

      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();

        RegistrationState expected = RegistrationLoading(model: model);
        expect(registrationBloc.state, expected);
        expect(find.text("Loading..."), findsOneWidget);
        
        await Future.delayed(const Duration(seconds: 2));
        await tester.pump();
        expect(find.text("Loading..."), findsNothing);

        expected = RegistrationGeneralError(message: NullFailure.message, model: model);
        expect(registrationBloc.state, expected);
        expect(find.text(NullFailure.message), findsOneWidget);
        expect(find.byKey(const Key("dismissButton")), findsOneWidget);
        
        await tester.ensureVisible(find.byKey(const Key("dismissButton")));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key("dismissButton")));
        await tester.pump();

        expected = RegistrationNoGeneralError(model: model);
        expect(registrationBloc.state, expected);
        expect(find.text(NullFailure.message), findsNothing);

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
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();

        RegistrationState expected = RegistrationLoading(model: model);
        expect(registrationBloc.state, expected);
        expect(find.text("Loading..."), findsOneWidget);
        
        await Future.delayed(const Duration(seconds: 2));
        await tester.pump();
        expect(find.text("Loading..."), findsNothing);

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
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();

        RegistrationState expected = RegistrationLoading(model: model);
        expect(registrationBloc.state, expected);
        expect(find.text("Loading..."), findsOneWidget);
        
        await Future.delayed(const Duration(seconds: 2));
        await tester.pump();
        expect(find.text("Loading..."), findsNothing);

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
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();

        RegistrationState expected = RegistrationLoading(model: model);
        expect(registrationBloc.state, expected);
        expect(find.text("Loading..."), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));
        await tester.pump();
        expect(find.text("Loading..."), findsNothing);

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
        return const Right(null);
      });

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
      await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
      await tester.pump();

      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();

        RegistrationState expected = RegistrationLoading(model: model);
        expect(registrationBloc.state, expected);
        expect(find.text("Loading..."), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));
        await tester.pump();
        expect(find.text("Loading..."), findsNothing);

        expected = const RegistrationSuccess();
        expect(registrationBloc.state, expected);
      });
    });

    testWidgets("Should return Authenticated after registration is success", (WidgetTester tester) async {
      when(mockRegistrationUsecase(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return const Right(null);
      });

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(authenticationBloc.state, Unauthenticated());

      await tester.enterText(find.byKey(const Key("nameField")), "Fulan");
      await tester.enterText(find.byKey(const Key("emailField")), "fulan@email.com");
      await tester.enterText(find.byKey(const Key("passwordField")), "Password123");
      await tester.enterText(find.byKey(const Key("confirmPasswordField")), "Password123");
      await tester.pump();

      await tester.runAsync(() async {
        await tester.tap(find.byKey(const Key("submitButton")));
        await tester.pump();

        RegistrationState expected = RegistrationLoading(model: model);
        expect(registrationBloc.state, expected);
        expect(find.text("Loading..."), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));
        await tester.pump();
        expect(find.text("Loading..."), findsNothing);

        expected = const RegistrationSuccess();
        expect(registrationBloc.state, expected);
        expect(authenticationBloc.state, Authenticated());
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
    child: MaterialApp(
      theme: ThemeData(
        backgroundColor: CustomColors.secondary,
        fontFamily: FontFamily.poppins,
        colorScheme: const ColorScheme(
          brightness: Brightness.light, 
          primary: CustomColors.primary, 
          onPrimary: Colors.white, 
          secondary: CustomColors.secondary, 
          onSecondary: Colors.white, 
          error: CustomColors.primary, 
          onError: Colors.white, 
          background: Colors.white, 
          onBackground: CustomColors.secondary, 
          surface: Colors.white, 
          onSurface: Colors.white
        ),
        textTheme: const TextTheme(
          headline1: TextStyles.poppinsBold24,
          subtitle1: TextStyles.poppinsBold16,
          bodyText1: TextStyles.poppinsRegular14,
          bodyText2: TextStyles.poppinsRegular12,
          button: TextStyles.poppinsRegular16
        )
      ),
      home: const RegistrationView(),
    )
  );
}
